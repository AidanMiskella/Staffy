//
//  PasswordEditViewController.swift
//  StaffyAdmin
//
//  Created by Aidan Miskella on 22/10/2019.
//  Copyright © 2019 Aidan Miskella. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SCLAlertView

class PasswordEditViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var emailImage: UIImageView!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var changeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        placeholder()
    }
    
    func setupUI() {
        
        Utilities.setupNavigationStyle(navigationController!)
        
        errorLabel.alpha = 0
        
        Utilities.styleTextField(textfield: emailTextField, font: .editProfileText, fontColor: .black, padding: 40.0)
        Utilities.styleImage(imageView: emailImage, image: "envelope", imageColor: .lightGray)
        Utilities.styleLabel(label: errorLabel, font: .loginError, fontColor: .red)
        Utilities.styleFilledButton(button: changeButton, font: .largeLoginButton, fontColor: .white, backgroundColor: .lightBlue, cornerRadius: 10.0)
    }
    
    func placeholder() {
        
        emailTextField.placeholder = Auth.auth().currentUser?.email
    }
    
    @IBAction func changeButtonPressed(_ sender: Any) {
        
        guard let email = emailTextField.text else { return }
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            
            if let error = error {
                
                let errorCode = AuthErrorCode(rawValue: error._code)
                self.errorLabel.alpha = 1
                self.errorLabel.text = errorCode?.errorMessage
            } else {
                
                let alertView = SCLAlertView(appearance: Constants.AlertView.appearance)
                alertView.addButton("Login", backgroundColor: .lightBlue, textColor: .white) {
                    
                    self.didClickButton()
                }
                
                alertView.showSuccess("Check your email", subTitle: "We have sent an email to \(email) as you have requested to change your password.", animationStyle: .rightToLeft)
            }
        }
    }
    
    func didClickButton() {
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.loginViewController)
        self.present(loginVC, animated: true, completion: nil)
    }
}
