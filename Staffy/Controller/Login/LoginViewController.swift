//
//  LoginViewController.swift
//  Staffy
//
//  Created by Aidan Miskella on 30/07/2019.
//  Copyright © 2019 Aidan Miskella. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var topImageHeight: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var emailImage: UIImageView!
    
    @IBOutlet weak var passwordImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements() {
        
        errorLabel.alpha = 0
        
        Utilities.styleTextField(emailText, .textField, .black)
        Utilities.styleTextField(passwordText, .textField, .black)
        Utilities.styleHollowButton(loginButton, .largeLoginButton, .lightBlue, 2.0, 20.0)
        Utilities.styleHollowButton(forgotPasswordButton, .smallLoginButton, .lightBlue, 0.0, 0.0)
        Utilities.styleFilledButton(registerButton, .largeLoginButton, .white, .lightBlue, 20.0)
        Utilities.styleLabel(errorLabel, .loginError, .red)
        Utilities.styleLabel(titleLabel, .loginTitle, .lightGray)
        
        emailImage.tintColor = .lightGray
        passwordImage.tintColor = .lightGray
        
        topImageHeight.constant = UIScreen.main.bounds.height / 2.25
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        guard let email = emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            let password = passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            
            if let error = error {
                
                let errorCode = AuthErrorCode(rawValue: error._code)
                self.errorLabel.alpha = 1
                self.errorLabel.text = errorCode?.errorMessage
            } else {
                
                if let authResult = authResult {
                    if authResult.user.isEmailVerified {
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let homeVC = storyboard.instantiateViewController(withIdentifier: "homeVC")
                        self.present(homeVC, animated: true, completion: nil)
                    } else {
                        
                        self.errorLabel.alpha = 1
                        self.errorLabel.text = "Please verify your account."
                    }
                }
            }
        }
    }
}
