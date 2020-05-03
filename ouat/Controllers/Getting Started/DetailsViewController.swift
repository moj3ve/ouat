//
//  CreateAccountViewController.swift
//  ouat
//
//  Created by Antique on 8/4/20.
//  Copyright © 2020 Antique. All rights reserved.
//

import Foundation
import UIKit


class DetailsViewController : UIViewController {
    var gettingStarted = GettingStarted()
    
    
    var emailTextField = PaddedTextField()
    var passwordTextField = PaddedTextField()
    var nameTextField = PaddedTextField()
    var birthTextField = PaddedTextField()
    
    
    var saveButton: GeneralButton = {
        let button = GeneralButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.setup(color: .systemBlue)
        
        return button
    }()
    
    
    var takePhoto = UIButton()
    var pictureCaptured = false
    var image = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        emailTextField.round(corners: .allCorners, radius: 14)
        passwordTextField.round(corners: .allCorners, radius: 14)
        nameTextField.round(corners: .allCorners, radius: 14)
        birthTextField.round(corners: [.topLeft, .bottomLeft], radius: 14)
        
        takePhoto.round(corners: [.topRight, .bottomRight], radius: 14)
    }
    
    
    func setup() {
        view.backgroundColor = .systemBackground
        title = "Details"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        let gettingStartedTabBarController = tabBarController as! GettingStartedTabBarController
        gettingStarted = gettingStartedTabBarController.gettingStarted // our data
        
        
        emailTextField = PaddedTextField()
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.backgroundColor = .secondarySystemBackground
        emailTextField.autocapitalizationType = .none
        emailTextField.placeholder = "Email"
        view.addSubview(emailTextField)
        
        emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        passwordTextField = PaddedTextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.backgroundColor = .secondarySystemBackground
        passwordTextField.autocapitalizationType = .none
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        view.addSubview(passwordTextField)
        
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        nameTextField = PaddedTextField()
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.backgroundColor = .secondarySystemBackground
        nameTextField.autocapitalizationType = .words
        nameTextField.placeholder = "Full Name"
        view.addSubview(nameTextField)
        
        nameTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        takePhoto = UIButton()
        takePhoto.translatesAutoresizingMaskIntoConstraints = false
        takePhoto.backgroundColor = .systemBlue
        takePhoto.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        takePhoto.tintColor = .white
        takePhoto.addTarget(self, action: #selector(capture(sender:)), for: .touchUpInside)
        view.addSubview(takePhoto)
        
        takePhoto.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20).isActive = true
        takePhoto.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        takePhoto.widthAnchor.constraint(equalToConstant: 60).isActive = true
        takePhoto.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        
        birthTextField = PaddedTextField()
        birthTextField.translatesAutoresizingMaskIntoConstraints = false
        birthTextField.backgroundColor = .secondarySystemBackground
        birthTextField.placeholder = "Date of Birth"
        birthTextField.datePicker(target: self, selector: #selector(chooseDate))
        view.addSubview(birthTextField)
        
        birthTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20).isActive = true
        birthTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        birthTextField.trailingAnchor.constraint(equalTo: takePhoto.leadingAnchor).isActive = true
        birthTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        let goToLoginButton = UIButton()
        goToLoginButton.translatesAutoresizingMaskIntoConstraints = false
        goToLoginButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        goToLoginButton.setTitle("Already have an account?", for: .normal)
        goToLoginButton.setTitleColor(.systemBlue, for: .normal)
        goToLoginButton.addTarget(self, action: #selector(goToLogin), for: .touchUpInside)
        view.addSubview(goToLoginButton)
        
        goToLoginButton.topAnchor.constraint(equalTo: birthTextField.bottomAnchor, constant: 4).isActive = true
        goToLoginButton.leadingAnchor.constraint(equalTo: birthTextField.leadingAnchor).isActive = true
        
        
        saveButton.addTarget(self, action: #selector(saveDetails), for: .touchUpInside)
        view.addSubview(saveButton)
        saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
    @objc func saveDetails() {
        if !isValidEmail(email: emailTextField.text!) {
            showAlert(title: "Oh no!", message: "We couldn't verify your email, please ensure you've entered it correctly before trying again.")
        } else if !isValidPassword(password: passwordTextField.text!) {
            showAlert(title: "Oh no!", message: "We value security and so should you. Please check your password to ensure it follows the guidelines below.\n\n1 Uppercase Letter\n1 Lowercase Letter\n1 Number\n8-15 Characters")
        } else if nameTextField.text! == "" {
            showAlert(title: "Who are you?", message: "Looks like you've forgotten to enter a name, please check your details and try save again.")
        } else if birthTextField.text! == "" {
            showAlert(title: "Goo goo gaga", message: "Looks like you've forgotten to select your birth date, please ensure you've entered all details.")
        } else if !pictureCaptured {
            showAlert(title: "John Cena?", message: "All users of ouat are required to take a picture for use as their profile picture. We use the camera to make sure all images are real and aren't taken from another source.")
        } else {
            print("we made an account successfully!")
            
            if !gettingStarted.savedDetails {
                gettingStarted.userDetails = [emailTextField.text!, passwordTextField.text!, nameTextField.text!, birthTextField.text!]
                gettingStarted.savedDetails = true
            }
        }
    }
    
    @objc func capture(sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func chooseDate() {
        if let datePicker = birthTextField.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .long
            birthTextField.text = dateformatter.string(from: datePicker.date)
        }
        birthTextField.resignFirstResponder()
    }
    
    @objc func goToLogin() {
        let loginNavController = UINavigationController(rootViewController: LoginViewController())
        loginNavController.modalPresentationStyle = .fullScreen
        present(loginNavController, animated: true, completion: nil)
    }
    
    
    func isValidEmail(email: String) -> Bool {
        let predicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}")
        return predicate.evaluate(with: email)
    }
    
    func isValidPassword(password: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,15}")
        return predicate.evaluate(with: password)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}


extension DetailsViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        image = info[.originalImage] as! UIImage
        gettingStarted.profile_image = image.pngData()!
        pictureCaptured = true
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        pictureCaptured = false
        picker.dismiss(animated: true, completion: nil)
    }
}
