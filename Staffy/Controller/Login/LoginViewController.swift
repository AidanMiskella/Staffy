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

        setUpElements()
    }
    
    func setUpElements() {
        
        errorLabel.alpha = 0
        
        Utilities.styleTextField(textfield: emailText, font: .textField, fontColor: .black, padding: 40.0)
        Utilities.styleTextField(textfield: passwordText, font: .textField, fontColor: .black, padding: 40.0)
        Utilities.styleHollowButton(button: loginButton, font: .largeLoginButton, fontColor: .lightBlue, borderWidth: 2.0, cornerRadius: 20.0)
        Utilities.styleHollowButton(button: forgotPasswordButton, font: .smallLoginButton, fontColor: .lightBlue, borderWidth: 0.0, cornerRadius: 0.0)
        Utilities.styleFilledButton(button: registerButton, font: .largeLoginButton, fontColor: .white, backgroundColor: .lightBlue, cornerRadius: 20.0)
        Utilities.styleLabel(label: errorLabel, font: .loginError, fontColor: .red)
        
        Utilities.styleImage(imageView: emailImage, image: "envelope", imageColor: .lightGray)
        Utilities.styleImage(imageView: passwordImage, image: "lock", imageColor: .lightGray)
        
        Utilities.setupNavigationStyle(navigationController!)
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
                        let homeVC = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.main)
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
