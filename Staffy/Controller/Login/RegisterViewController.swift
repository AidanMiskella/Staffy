//
//  RegisterViewController.swift
//  Staffy
//
//  Created by Aidan Miskella on 30/07/2019.
//  Copyright © 2019 Aidan Miskella. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController, AlertViewDelegate {
    
    @IBOutlet weak var topImageHeight: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var firstNameText: UITextField!
    
    @IBOutlet weak var lastNameText: UITextField!
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var firstNameImage: UIImageView!
    
    @IBOutlet weak var lastNameImage: UIImageView!
    
    @IBOutlet weak var emailImage: UIImageView!
    
    @IBOutlet weak var passwordImage: UIImageView!
    
    var alertView: AlertView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertView = AlertView()
        alertView?.delegate = self
        
        setUpElements()
    }
    
    func setUpElements() {
        
        errorLabel.alpha = 0
        
        Utilities.styleTextField(textfield: firstNameText, font: .textField, fontColor: .black)
        Utilities.styleTextField(textfield: lastNameText, font: .textField, fontColor: .black)
        Utilities.styleTextField(textfield: emailText, font: .textField, fontColor: .black)
        Utilities.styleTextField(textfield: passwordText, font: .textField, fontColor: .black)
        Utilities.styleFilledButton(button: submitButton, font: .largeLoginButton, fontColor: .white, backgroundColor: .lightBlue, cornerRadius: 20.0)
        Utilities.styleLabel(label: errorLabel, font: .loginError, fontColor: .red)
        Utilities.styleLabel(label: titleLabel, font: .loginTitle, fontColor: .lightGray)
        
        Utilities.styleImage(imageView: firstNameImage, image: "user", imageColor: .lightGray)
        Utilities.styleImage(imageView: lastNameImage, image: "user", imageColor: .lightGray)
        Utilities.styleImage(imageView: emailImage, image: "envelope", imageColor: .lightGray)
        Utilities.styleImage(imageView: passwordImage, image: "lock", imageColor: .lightGray)
        
        topImageHeight.constant = UIScreen.main.bounds.height / 2.25
    }
    
    @IBAction func createUserButtonTapped(_ sender: UIButton) {
        
        let error = validateFields()
        
        if error != nil {
            
            errorLabel.alpha = 1
            errorLabel.text = error
        } else {
        
            guard let email = emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                let password = passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    
                    let errorCode = AuthErrorCode(rawValue: error._code)
                    self.errorLabel.alpha = 1
                    self.errorLabel.text = errorCode?.errorMessage
                } else {
                    
                    guard let userId = user?.user.uid else { return }
                    self.saveUser(userId)
                    self.sendVerificationEmail()
                }
            }
        }
    }
    
    func saveUser(_ userId: String) {
        
        Firestore.firestore().collection(Constants.FirebaseDB.user_ref).document(userId).setData([
            Constants.FirebaseDB.email: emailText.text!,
            Constants.FirebaseDB.date_created: FieldValue.serverTimestamp(),
            Constants.FirebaseDB.user_id: userId,
            Constants.FirebaseDB.first_name: firstNameText.text!,
            Constants.FirebaseDB.last_name: lastNameText.text!
            ], completion: { (error) in
                if let error = error {
                    
                    debugPrint("Error saving user: \(error.localizedDescription)")
                }
        })
    }
    
    func sendVerificationEmail() {
        
        if Auth.auth().currentUser != nil && Auth.auth().currentUser?.isEmailVerified == false {
            
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                if let error = error {
                    
                    let errorCode = AuthErrorCode(rawValue: error._code)
                    self.errorLabel.alpha = 1
                    self.errorLabel.text = errorCode?.errorMessage
                } else {
                    
                    guard let email = self.emailText.text else { return }
                    self.alertView?.showAlert(title: "Check your mail", message: "We have sent a verification email to \(email) so that we can verify it's you", image: "tick", buttonText: "Return to login")
                }
            })
        }
    }
    
    func validateFields() -> String? {
        
        let error: String
        
        if firstNameText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            error = "Please fill in all fields."
            return error
        }
        
        return nil
    }
    
    func didClickButton() {

        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "loginRoot")
        self.present(loginVC, animated: true, completion: nil)
    }
}
