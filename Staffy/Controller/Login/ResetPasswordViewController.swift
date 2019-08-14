//
//  ResetPasswordViewController.swift
//  Staffy
//
//  Created by Aidan Miskella on 01/08/2019.
//  Copyright © 2019 Aidan Miskella. All rights reserved.
//

import UIKit
import FirebaseAuth
import SCLAlertView

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var topImageHeight: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var emailImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
    }
    
    func setUpElements() {
        
        errorLabel.alpha = 0
        
        Utilities.styleTextField(textfield: emailText, font: .textField, fontColor: .black)
        Utilities.styleFilledButton(button: submitButton, font: .largeLoginButton, fontColor: .white, backgroundColor: .lightBlue, cornerRadius: 20.0)
        Utilities.styleLabel(label: errorLabel, font: .loginError, fontColor: .red)
        Utilities.styleLabel(label: titleLabel, font: .loginTitle, fontColor: .lightGray)
        
        Utilities.styleImage(imageView: emailImage, image: "envelope", imageColor: .lightGray)
        
        topImageHeight.constant = UIScreen.main.bounds.height / 2.25
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        
        guard let email = emailText.text else { return }
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
