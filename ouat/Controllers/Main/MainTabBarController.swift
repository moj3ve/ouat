//
//  MainTabBarController.swift
//  ouat
//
//  Created by Antique on 14/4/20.
//  Copyright © 2020 Antique. All rights reserved.
//

import Foundation
import UIKit


class MainTabBarController : UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let nearbyNavController = UINavigationController(rootViewController: NearbyCollectionViewController(collectionViewLayout: flowLayout))
        nearbyNavController.tabBarItem = UITabBarItem(title: "Nearby", image: UIImage(systemName: "location.circle.fill"), tag: 0)
        
        
        setViewControllers([nearbyNavController], animated: true)
    }
}
