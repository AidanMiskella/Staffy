//
//  EmailEditViewController.swift
//  Staffy
//
//  Created by Aidan Miskella on 26/09/2019.
//  Copyright © 2019 Aidan Miskella. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SCLAlertView

class EmailEditViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        placeholders()
    }
    
    func setupUI() {
        
        topView.layerGradient()
        
        Utilities.styleLabel(label: titleLabel, font: .editProfileTitle, fontColor: .white)
        Utilities.styleTextField(textfield: emailTextField, font: .editProfileText, fontColor: .black, padding: 0.0)
        Utilities.styleTextField(textfield: passwordTextField, font: .editProfileText, fontColor: .black, padding: 0.0)
        Utilities.styleFilledButton(button: saveButton, font: .largeLoginButton, fontColor: .white, backgroundColor: .lightBlue, cornerRadius: 10.0)
    }
    
    func placeholders() {
        
        guard let currentUser = UserService.currentUser else { return }
        
        emailTextField.placeholder = currentUser.email
        passwordTextField.placeholder = "Current password"
    }
    
    func sendVerificationEmail() {
            
        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
            if let error = error {
                
                print("Error \(error)")
            } else {
                
                guard let email = self.emailTextField.text else { return }
                let alertView = SCLAlertView(appearance: Constants.AlertView.appearance)
                
                alertView.addButton("Continue", backgroundColor: .lightBlue, textColor: .white) {
                    
                    self.didClickButton()
                }
                
                alertView.showSuccess("Check your email", subTitle: "We have sent a verification email to \(email) so we can verify it's you.", animationStyle: .rightToLeft)
            }
        })
    }
    
    func didClickButton() {
        
        dismiss(animated: true)
        
        do {
            
            try Auth.auth().signOut()
        } catch let signoutError as NSError {
            
            debugPrint("Error signing out: \(signoutError)")
        }
    }
    
    @IBAction func saveButtonDidPress(_ sender: UIButton) {
     
        guard let currentUser = UserService.currentUser else { return }
        
        if emailTextField.text == "" {
            
            self.navigationController?.popViewController(animated: true)
        } else {
            
            let credentials: AuthCredential = EmailAuthProvider.credential(withEmail: currentUser.email!, password: passwordTextField.text!)
            
            Auth.auth().currentUser?.reauthenticate(with: credentials, completion: { (authData, error) in
                
                if let error = error {
                    
                    print("Error \(error)")
                } else {
                    
                    Auth.auth().currentUser?.updateEmail(to: self.emailTextField.text!, completion: { (error) in
                        
                        if let error = error {
                            
                            print("Error \(error)")
                        } else {
                            
                            let ref = Firestore.firestore().collection(Constants.FirebaseDB.user_ref)
                                .document(Auth.auth().currentUser!.uid)
                            
                            ref.updateData([
                                Constants.FirebaseDB.email: self.emailTextField.text!
                            ]) { (error) in
                                
                                if let error = error {
                                    
                                    print("Error updating information \(error)")
                                } else {
                                    
                                    currentUser.email = self.emailTextField.text
                                    self.sendVerificationEmail()
                                }
                            }
                        }
                    })
                }
            })
        }
    }
}
