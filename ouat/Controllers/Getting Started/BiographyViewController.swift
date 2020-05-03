//
//  BiographyViewController.swift
//  ouat
//
//  Created by Antique on 9/4/20.
//  Copyright © 2020 Antique. All rights reserved.
//

import Foundation
import UIKit


class BiographyViewController : UIViewController {
    var gettingStarted = GettingStarted()
    
    
    var subtitleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textAlignment = .right
        label.textColor = .secondaryLabel

        return label
    }()
    
    
    var textView = PaddedTextView()
    
    
    var saveButton: GeneralButton = {
        let button = GeneralButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.setup(color: .systemBlue)
        
        return button
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.round(corners: .allCorners, radius: 14)
    }
    
    
    func setup() {
        view.backgroundColor = .systemBackground
        title = "Biography"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        let gettingStartedTabBarController = tabBarController as! GettingStartedTabBarController
        gettingStarted = gettingStartedTabBarController.gettingStarted // our data
        
        
        textView = PaddedTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        textView.font = UIFont.systemFont(ofSize: 17)
        view.addSubview(textView)
        
        textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        
        
        subtitleLabel.text = "Characters remaining: 60"
        view.addSubview(subtitleLabel)
        
        subtitleLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 4).isActive = true
        subtitleLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor).isActive = true
        
        
        saveButton.addTarget(self, action: #selector(saveBiography), for: .touchUpInside)
        view.addSubview(saveButton)
        saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
    @objc func saveBiography() {
        if textView.text.count > 0 && !gettingStarted.savedBiography {
            gettingStarted.biography = textView.text
            gettingStarted.savedBiography = true
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}


extension BiographyViewController : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        DispatchQueue.main.async {
            self.subtitleLabel.text = String(format: "Characters remaining: %i", 60-updatedText.count)
        }
        
        let existingLines = textView.text.components(separatedBy: CharacterSet.newlines)
        let newLines = text.components(separatedBy: CharacterSet.newlines)
        let linesAfterChange = existingLines.count + newLines.count - 1
        
        if text == "\n" {
            return linesAfterChange <= 5
        }
        
        return updatedText.count <= 60
    }
}
