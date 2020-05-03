//
//  MessageCollectionViewController.swift
//  ouat
//
//  Created by Antique on 30/4/20.
//  Copyright © 2020 Antique. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class MessageCollectionViewController : UICollectionViewController {
    var user: QueryDocumentSnapshot?
    var me: DocumentSnapshot?
    var messages = [DocumentSnapshot]()
    var threads = [String]()
    
    
    var textField = PaddedTextField()
    var button = UIButton()
    
    
    var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        return layout
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.round(corners: .allCorners, radius: 22)
        textField.round(corners: .allCorners, radius: 22)
    }
    
    
    func setup() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.setLeftBarButton(UIBarButtonItem(image: UIImage(systemName: "multiply"), style: .done, target: self, action: #selector(close)), animated: true)
        
        
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .clear
        collectionView.register(SenderCell.self, forCellWithReuseIdentifier: "SenderCell")
        collectionView.register(ReceiverCell.self, forCellWithReuseIdentifier: "ReceiverCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "BlankCell")
        
        
        Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).getDocument { (myDocument, error) in
            self.me = myDocument
            
            Firestore.firestore().collection("chats").getDocuments { (snapshot, error) in
                if let error = error {
                    print("[e]: ", error.localizedDescription)
                } else {
                    let myChats = self.me!["chats"] as! [String]
                    
                    for document in snapshot!.documents {
                        if myChats.contains(document.documentID) {
                            self.threads = document["thread"] as! [String]
                            
                            for documentThread in self.threads {
                                Firestore.firestore().collection("messages").document(documentThread).getDocument { (messageSnapshot, error) in
                                    if let error = error {
                                        print("[e]: ", error.localizedDescription)
                                    } else {
                                        if !self.messages.contains(messageSnapshot!) {
                                            self.messages.append(messageSnapshot!)
                                        }
                                        
                                        
                                        self.messages.sort { (one, two) -> Bool in
                                            let oneData = one.data()
                                            let twoData = two.data()
                                            
                                            let oneDate = oneData!["messageTimestamp"] as! Timestamp
                                            let twoDate = twoData!["messageTimestamp"] as! Timestamp
                                            
                                            return oneDate.dateValue() < twoDate.dateValue()
                                        }
                                        
                                        
                                        DispatchQueue.main.async {
                                            self.collectionView.reloadData()
                                            self.title = "\((self.user!["full_name"] as! String).components(separatedBy: " ")[0]) + \((self.me!["full_name"] as! String).components(separatedBy: " ")[0])"
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        
        button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.tintColor = .white
        view.addSubview(button)
        
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        button.widthAnchor.constraint(equalToConstant: 44*1.66).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        
        textField = PaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .secondarySystemBackground
        textField.placeholder = "Aa"
        view.addSubview(textField)
        
        textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        textField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        textField.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -16).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
}


extension MessageCollectionViewController : UICollectionViewDelegateFlowLayout {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let senderCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SenderCell", for: indexPath) as! SenderCell
        let receiverCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReceiverCell", for: indexPath) as! ReceiverCell
        
        
        let message = messages[indexPath.item]
        if self.me!.documentID.isEqualToString(find: message["senderIdentifier"] as! String) {
            senderCell.textView.text = message["messageText"] as? String
            return senderCell
        } else {
            receiverCell.textView.text = message["messageText"] as? String
            return receiverCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    }
}
