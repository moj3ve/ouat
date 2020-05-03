//
//  GettingStartedTabBarController.swift
//  ouat
//
//  Created by Antique on 8/4/20.
//  Copyright © 2020 Antique. All rights reserved.
//

import Foundation
import UIKit


class GettingStartedTabBarController : UITabBarController {
    var gettingStarted = GettingStarted()
    var hobbies = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        
        let detailsNavController = UINavigationController(rootViewController: DetailsViewController())
        detailsNavController.tabBarItem = UITabBarItem(title: "Details", image: UIImage(systemName: "envelope.circle.fill"), tag: 0)
        
        let biographyNavController = UINavigationController(rootViewController: BiographyViewController())
        biographyNavController.tabBarItem = UITabBarItem(title: "Bio", image: UIImage(systemName: "book.circle.fill"), tag: 1)
        
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let addHobbiesNavController = UINavigationController(rootViewController: AddHobbiesCollectionViewController(collectionViewLayout: flowLayout))
        addHobbiesNavController.tabBarItem = UITabBarItem(title: "Hobbies", image: UIImage(systemName: "heart.circle.fill"), tag: 2)
        
        
        let locationNavController = UINavigationController(rootViewController: LocationViewController())
        locationNavController.tabBarItem = UITabBarItem(title: "Location", image: UIImage(systemName: "location.circle.fill"), tag: 3)
        
        
        let createAccountNavController = UINavigationController(rootViewController: CreateAccountViewController())
        createAccountNavController.tabBarItem = UITabBarItem(title: "Create", image: UIImage(systemName: "person.crop.circle.fill.badge.plus"), tag: 4)
        
        
        setViewControllers([detailsNavController, biographyNavController, addHobbiesNavController, locationNavController, createAccountNavController], animated: true)
    }
}
