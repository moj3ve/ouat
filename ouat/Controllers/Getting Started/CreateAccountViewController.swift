//
//  CreateAccountViewController.swift
//  ouat
//
//  Created by Antique on 11/4/20.
//  Copyright © 2020 Antique. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class CreateAccountViewController : UITableViewController {
    var gettingStarted = GettingStarted()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(createAccount))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }


    func setup() {
        view.backgroundColor = .systemBackground
        title = "Create"
        navigationController?.navigationBar.prefersLargeTitles = true
        
    
        let gettingStartedTabBarController = tabBarController as! GettingStartedTabBarController
        gettingStarted = gettingStartedTabBarController.gettingStarted // our data
    }
    
    
    @objc func createAccount() {
        Auth.auth().createUser(withEmail: gettingStarted.userDetails[0], password: AESCrypt.encrypt(gettingStarted.userDetails[1], password: gettingStarted.userDetails[0])) { (result, error) in
            if let error = error {
                print("[e]: ", error.localizedDescription)
            } else {
                Firestore.firestore().collection("users").document((result?.user.uid)!).setData([
                    "bio" : self.gettingStarted.biography,
                    "birth_date" : self.gettingStarted.userDetails[3],
                    "email" : self.gettingStarted.userDetails[0],
                    "full_name" : self.gettingStarted.userDetails[2],
                    "hobbies" : FieldValue.arrayUnion(self.gettingStarted.hobbies),
                    "location" : GeoPoint(latitude: self.gettingStarted.location[0], longitude: self.gettingStarted.location[1]),
                    "password" : AESCrypt.encrypt(self.gettingStarted.userDetails[1], password: self.gettingStarted.userDetails[0])!
                ]) { (error) in
                    if let error = error {
                        print("[e]: ", error.localizedDescription)
                    } else {
                        let ref = Storage.storage().reference().child("\((result?.user.uid)!)/profile_image.png")
                        ref.putData(self.gettingStarted.profile_image)
                        
                        
                        UserDefaults().set("email", forKey: self.gettingStarted.userDetails[0])
                        UserDefaults().set("password", forKey: AESCrypt.encrypt(self.gettingStarted.userDetails[1], password: self.gettingStarted.userDetails[0])!)
                        
                        
                        let mainTabBarController = MainTabBarController()
                        mainTabBarController.modalPresentationStyle = .fullScreen
                        self.present(mainTabBarController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.textColor = .label
        cell.detailTextLabel?.textColor = .secondaryLabel
        cell.textLabel?.font = UIFont.systemFont(ofSize: 19, weight: .semibold)

        let index = indexPath.row
        if index == 0 {
            if gettingStarted.savedDetails {
                cell.textLabel?.text = String(format: "%@", gettingStarted.userDetails[0])
                cell.detailTextLabel?.text = "Login Details"
            } else {
                cell.textLabel?.text = "No details have been saved."
                cell.detailTextLabel?.text = "Login Details"
            }
        } else if index == 1 {
            if gettingStarted.savedBiography {
                cell.textLabel?.text = String(format: "%@", gettingStarted.biography)
                cell.detailTextLabel?.text = "Biography"
            } else {
                cell.textLabel?.text = "No biography has been saved."
                cell.detailTextLabel?.text = "Biography"
            }
        } else if index == 2 {
            if gettingStarted.hobbies.count > 0 {
                cell.textLabel?.text = String(format: "%@ and %i more", gettingStarted.hobbies[0], gettingStarted.hobbies.count-1)
                cell.detailTextLabel?.text = "Hobbies"
            } else {
                cell.textLabel?.text = "No hobbies have been saved."
                cell.detailTextLabel?.text = "Hobbies"
            }
        } else {
            if gettingStarted.savedLocation {
                cell.textLabel?.text = String(format: "%@", gettingStarted.locale)
                cell.detailTextLabel?.text = "Location"
            } else {
                cell.textLabel?.text = "No location has been saved."
                cell.detailTextLabel?.text = "Location"
            }
        }
        
        return cell
    }
}
