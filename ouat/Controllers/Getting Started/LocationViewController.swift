//
//  LocationViewController.swift
//  ouat
//
//  Created by Antique on 8/4/20.
//  Copyright © 2020 Antique. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit


class LocationViewController : UIViewController {
    var gettingStarted = GettingStarted()
    
    
    var locationManager = CLLocationManager()
    
    
    var mapView = MKMapView()
    var locationLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .secondaryLabel

        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.round(corners: .allCorners, radius: 14)
    }
    
    
    func setup() {
        view.backgroundColor = .systemBackground
        title = "Location"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        let gettingStartedTabBarController = tabBarController as! GettingStartedTabBarController
        gettingStarted = gettingStartedTabBarController.gettingStarted // our data
        
        
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        
        mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        mapView.isUserInteractionEnabled = false
        mapView.showsUserLocation = true
        let annotation = MKPointAnnotation()
        annotation.title = "Home"
        annotation.coordinate = mapView.userLocation.coordinate
        mapView.addAnnotation(annotation)
        view.addSubview(mapView)
        
        mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        
        view.addSubview(locationLabel)
        
        locationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        locationLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 4).isActive = true
        locationLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20).isActive = true
        locationLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20).isActive = true
        
        
        if isConnectedToVPN() {
            showAlert(title: "VPN", message: "We've detected that you may be using a VPN while accessing ouat. Please disable it and reopen the app to finish creating your account.")
        }
    }
}


extension LocationViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        var region = MKCoordinateRegion()
        region.center = userLocation.coordinate
        region.span.longitudeDelta = 0.01
        region.span.latitudeDelta = 0.01
        
        
        mapView.setRegion(region, animated: true)
        
        var locale = String()
        LocationManager().getLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude, completion: { (placemark, error) in
            if let error = error {
                print("[e]: ", error.localizedDescription)
            } else {
                locale = placemark!.locality ?? "Not found"
                if !self.gettingStarted.savedLocation {
                    self.gettingStarted.locale = locale
                    self.gettingStarted.location = [userLocation.coordinate.latitude, userLocation.coordinate.longitude]
                    self.gettingStarted.savedLocation = true
                }
                
                DispatchQueue.main.async {
                    self.locationLabel.text = "\(placemark!.locality ?? "Not found")"
                }
            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showAlert(title: "Almost There!", message: "We've added your suburb/city to your account, this information is not accessible to anyone else and is only used to show you people near your location.")
        }
    }
    
    
    func isConnectedToVPN() -> Bool {
        let cfDict = CFNetworkCopySystemProxySettings()
        let nsDict = cfDict!.takeRetainedValue() as NSDictionary
        let keys = nsDict["__SCOPED__"] as! NSDictionary
        for key: String in keys.allKeys as! [String] {
               if (key == "tap" || key == "tun" || key == "ppp" || key == "ipsec" || key == "ipsec0" || key == "utun1" || key == "utun2") {
                   return true
               }
           }
           return false
    }
}
