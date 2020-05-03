//
//  AddHobbiesCollectionViewController.swift
//  ouat
//
//  Created by Antique on 8/4/20.
//  Copyright © 2020 Antique. All rights reserved.
//

import Foundation
import UIKit


class AddHobbiesCollectionViewController : UICollectionViewController {
    var gettingStarted = GettingStarted()
    var hobbies = [String]()
    
    var alreadyLoaded = false
    
    
    var saveButton: GeneralButton = {
        let button = GeneralButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save Hobbies", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.setup(color: .systemBlue)
        
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !alreadyLoaded {
            showAlert(title: "Adding Hobbies", message: "Tap any hobbies that apply to you, tapping them again will remove the selection.")
            alreadyLoaded = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for hobby in hobbies {
            if gettingStarted.hobbies.contains(hobby) {
                let index = gettingStarted.hobbies.firstIndex(of: hobby)
                collectionView.selectItem(at: IndexPath(row: index!, section: 0), animated: true, scrollPosition: .centeredVertically)
            }
        }
    }
    
    
    func setup() {
        title = "Hobbies"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = true
        collectionView.register(HobbyCell.self, forCellWithReuseIdentifier: "HobbyCell")
        
        
        let gettingStartedTabBarController = tabBarController as! GettingStartedTabBarController
        gettingStarted = gettingStartedTabBarController.gettingStarted // our data
        
        
        hobbies = ["Reading", "Watching TV", "Family Time", "Going to Movies", "Fishing", "Computer", "Gardening", "Renting Movies", "Walking", "Exercise", "Listening to Music", "Entertaining", "Hunting", "Team Sports", "Shopping", "Traveling", "Sleeping", "Socializing", "Sewing", "Golf", "Church Activities", "Relaxing", "Playing Music", "Housework", "Crafts", "Watching Sports", "Bicycling", "Playing Cards", "Hiking", "Cooking", "Eating Out", "Dating Online", "Swimming", "Camping", "Skiing", "Working on Cars", "Writing", "Boating", "Motorcycling", "Animal Care", "Bowling", "Painting", "Running", "Dancing", "Horseback Riding", "Tennis", "Theater", "Billiards", "Beach", "Volunteer Work"
        ].sorted()
    }
}


extension AddHobbiesCollectionViewController : UICollectionViewDelegateFlowLayout {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hobbies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HobbyCell", for: indexPath) as! HobbyCell
        
        cell.titleLabel.text = hobbies[indexPath.item]
        
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.isSelected = true
        
        if !gettingStarted.hobbies.contains(hobbies[indexPath.item]) {
            gettingStarted.hobbies.append(hobbies[indexPath.item])
        }
        print("[*]: (+) ", gettingStarted.hobbies)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.isSelected = false
        
        if gettingStarted.hobbies.contains(hobbies[indexPath.item]) {
            gettingStarted.hobbies.remove(element: hobbies[indexPath.item])
        }
        print("[*]: (-) ", gettingStarted.hobbies)
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
        return CGSize(width: width/2-28, height: 50)
    }
}

