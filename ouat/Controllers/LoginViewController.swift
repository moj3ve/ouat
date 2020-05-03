//
//  LoginViewController.swift
//  ouat
//
//  Created by Antique on 12/4/20.
//  Copyright © 2020 Antique. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class LoginViewController : UIViewController {
    var emailTextField = PaddedTextField()
    var passwordTextField = PaddedTextField()
    
    
    var saveButton: GeneralButton = {
        let button = GeneralButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
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
        emailTextField.round(corners: .allCorners, radius: 14)
        passwordTextField.round(corners: .allCorners, radius: 14)
    }
    
    
    func setup() {
        view.backgroundColor = .systemBackground
        title = "Login"
        navigationController?.navigationBar.prefersLargeTitles = true

        
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
        
        let goToCreateButton = UIButton()
        goToCreateButton.translatesAutoresizingMaskIntoConstraints = false
        goToCreateButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        goToCreateButton.setTitle("Don't have an account?", for: .normal)
        goToCreateButton.setTitleColor(.systemBlue, for: .normal)
        goToCreateButton.addTarget(self, action: #selector(goToCreate), for: .touchUpInside)
        view.addSubview(goToCreateButton)
        
        goToCreateButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 4).isActive = true
        goToCreateButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor).isActive = true
        
        
        saveButton.addTarget(self, action: #selector(loginAccount), for: .touchUpInside)
        view.addSubview(saveButton)
        saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
    @objc func loginAccount() {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: AESCrypt.encrypt(passwordTextField.text!, password: emailTextField.text!)) { (result, error) in
            if let error = error {
                print("[e]: ", error.localizedDescription)
            } else {
                UserDefaults.standard.set(self.emailTextField.text!, forKey: "email")
                UserDefaults.standard.set(AESCrypt.encrypt(self.passwordTextField.text!, password: self.emailTextField.text!), forKey: "password")
                
                
                let mainTabBarController = MainTabBarController()
                mainTabBarController.modalPresentationStyle = .fullScreen
                self.present(mainTabBarController, animated: true, completion: nil)
            }
        }
    }
    
    @objc func goToCreate() {
        let gettingStartedViewController = GettingStartedTabBarController()
        gettingStartedViewController.modalPresentationStyle = .fullScreen
        present(gettingStartedViewController, animated: true, completion: nil)
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
