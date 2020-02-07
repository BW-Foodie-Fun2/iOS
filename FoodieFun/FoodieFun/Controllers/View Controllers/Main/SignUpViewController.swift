//
//  SignUpViewController.swift
//  FoodieFun
//
//  Created by Aaron Cleveland on 2/4/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    let auth = Auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        // perform signup operation
        print("Sign Up Button Tapped")
        if let username = usernameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty,
            let email = emailTextField.text,
            !email.isEmpty,
            let location = locationTextField.text,
            !location.isEmpty {
            let user = UserRepresentation(username: username, password: password, email: email, location: location)

            auth.signUp(with: user) { (error) in
                if let error = error {
                    print("Error occured during signup: \(error)")
                } else {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "signupShowTabbar", sender: self)
                    }
                }
            }
        } else {
            Alert.showBasic(title: "Oops!", message: "You didn't fill out a required field", vc: self)
        }
    }
}
