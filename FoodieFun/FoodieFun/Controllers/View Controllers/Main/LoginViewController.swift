//
//  LoginViewController.swift
//  FoodieFun
//
//  Created by Aaron Cleveland on 2/5/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let auth = Auth()
    
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        print("Login Button Tapped")
        if let username = usernameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty {
            let user = User(username: username, password: password, email: "", location: "")
            
            auth.signIn(with: user) { (error) in
                if let error = error {
                    DispatchQueue.main.async {
                        Alert.showBasic(title: "Error Signing", message: "Please check your login information!", vc: self)
                    }
                    print("Error occured during signin: \(error)")
                } else {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "loginShowTabbar", sender: nil)
                    }
                }
            }
        }
    }
}
