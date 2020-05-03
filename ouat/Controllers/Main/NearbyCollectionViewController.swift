//
//  NearbyCollectionViewController.swift
//  ouat
//
//  Created by Antique on 14/4/20.
//  Copyright © 2020 Antique. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CoreLocation


class NearbyCollectionViewController : UICollectionViewController {
    var users = [QueryDocumentSnapshot]()
    var me: DocumentSnapshot?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    func setup() {
        title = "Nearby"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        collectionView.backgroundColor = .clear
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: "UserCell")
        
        
        Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).getDocument { (myDocument, error) in
            self.me = myDocument
            
            Firestore.firestore().collection("users").getDocuments { (snapshot, error) in
                if let error = error {
                    print("[e]: ", error.localizedDescription)
                } else {
                    for document in snapshot!.documents {
                        if !(document.documentID == myDocument?.documentID) {
                            let location = document["location"] as! GeoPoint
                            let nearbyLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
                            
                            let location2 = myDocument!["location"] as! GeoPoint
                            let myLocation = CLLocation(latitude: location2.latitude, longitude: location2.longitude)
                            
                            
                            let distance = nearbyLocation.distance(from: myLocation) / 1000 // km
                            if distance >= 0 || distance <= 0 {
                                if !self.users.contains(document) {
                                    self.users.append(document)
                                }
                                
                                DispatchQueue.main.async {
                                    self.collectionView.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}


extension NearbyCollectionViewController : UICollectionViewDelegateFlowLayout {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as! UserCell
        
        let profile_picture_ref = Storage.storage().reference().child("\(users[indexPath.item].documentID)/profile_image.png")
        profile_picture_ref.downloadURL { (url, error) in
            if let error = error {
                print("[e]: ", error.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    cell.imageView.image = UIImage(data: try! Data(contentsOf: url!))
                }
            }
        }
        
        cell.titleLabel.text = "\(users[indexPath.item]["full_name"] ?? "Unknown")".replacingOccurrences(of: " ", with: "\n")
        cell.subtitleLabel.text = "\(distance(me: me!, other: users[indexPath.item]))km away"
        
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = users[indexPath.item] as QueryDocumentSnapshot
        
        let flowLayout = UICollectionViewFlowLayout()
        let profileCollectionViewController = ProfileDetailsCollectionViewController(collectionViewLayout: flowLayout)
        profileCollectionViewController.user = user
        let profileDetailsNavController = UINavigationController(rootViewController: profileCollectionViewController)
        present(profileDetailsNavController, animated: true, completion: nil)
    }
    
    
    func distance(me: DocumentSnapshot, other: DocumentSnapshot) -> Double {
        let location = other["location"] as! GeoPoint
        let nearbyLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        let location2 = me["location"] as! GeoPoint
        let myLocation = CLLocation(latitude: location2.latitude, longitude: location2.longitude)
        
        
        let distance = nearbyLocation.distance(from: myLocation) / 1000 // km
        return distance
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width/3-28, height: (width/3-28)*1.66)
    }
}

