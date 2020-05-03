//
//  ProfileDetailsCollectionViewController.swift
//  ouat
//
//  Created by Antique on 16/4/20.
//  Copyright © 2020 Antique. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CoreLocation


class ProfileDetailsCollectionViewController : UICollectionViewController {
    var user: QueryDocumentSnapshot?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    func setup() {
        title = user!["full_name"] as? String
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(systemName: "paperplane.fill"), style: .plain, target: self, action: #selector(startConversation)), animated: true)
        
        
        collectionView.backgroundColor = .clear
        collectionView.register(PhotosCollectionViewCellsInCell.self, forCellWithReuseIdentifier: "PhotosCell")
        collectionView.register(MapCell.self, forCellWithReuseIdentifier: "MapCell")
        collectionView.register(HobbyCell.self, forCellWithReuseIdentifier: "HobbyCell")
    }
    
    
    @objc func startConversation() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        
        let messageNavController = UINavigationController(rootViewController: MessageCollectionViewController(collectionViewLayout: flowLayout))
        messageNavController.modalPresentationStyle = .fullScreen
        (messageNavController.viewControllers[0] as! MessageCollectionViewController).user = user
        
        present(messageNavController, animated: true, completion: nil)
    }
}


extension ProfileDetailsCollectionViewController : UICollectionViewDelegateFlowLayout {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        } else {
            return (user!["hobbies"] as! [String]).count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photosCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCell", for: indexPath) as! PhotosCollectionViewCellsInCell
        let mapCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapCell", for: indexPath) as! MapCell
        let hobbyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HobbyCell", for: indexPath) as! HobbyCell
        
        if indexPath.section == 0 {
            photosCell.user = user
            return photosCell
        } else if indexPath.section == 1 {
            let location = user!["location"] as! GeoPoint
            mapCell.latitude = location.latitude
            mapCell.longitude = location.longitude
            return mapCell
        } else {
            let hobbies = user!["hobbies"] as! [String]
            hobbyCell.titleLabel.text = hobbies[indexPath.item]
            hobbyCell.titleLabel.textAlignment = .center
            return hobbyCell
        }
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        if indexPath.section == 0 || indexPath.section == 1 {
            return CGSize(width: width-40, height: (width-40)/1.66)
        } else {
            return CGSize(width: width/2-28, height: 50)
        }
    }
}
