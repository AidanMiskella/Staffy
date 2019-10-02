//
//  NameEditViewController.swift
//  Staffy
//
//  Created by Aidan Miskella on 26/09/2019.
//  Copyright © 2019 Aidan Miskella. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class NameEditViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
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
        Utilities.styleTextField(textfield: firstNameTextField, font: .editProfileText, fontColor: .black, padding: 0.0)
        Utilities.styleTextField(textfield: lastNameTextField, font: .editProfileText, fontColor: .black, padding: 0.0)
        Utilities.styleFilledButton(button: saveButton, font: .largeLoginButton, fontColor: .white, backgroundColor: .lightBlue, cornerRadius: 10.0)
    }
    
    func placeholders() {
        
        guard let currentUser = UserService.currentUser else { return }
        
        firstNameTextField.placeholder = currentUser.firstName
        lastNameTextField.placeholder = currentUser.lastName
    }
    
    @IBAction func saveButtonDidPress(_ sender: Any) {
        
        guard let currentUser = UserService.currentUser else { return }
        
        var newFirstName = currentUser.firstName
        var newLastName = currentUser.lastName
        
        if firstNameTextField.text == "" && lastNameTextField.text == "" {
            
            self.navigationController?.popViewController(animated: true)
        } else {
        
            if firstNameTextField.text != "" {
                
                newFirstName = firstNameTextField.text!
            }
            
            if lastNameTextField.text != "" {
                
                newLastName = lastNameTextField.text!
            }
        }
        
        let ref = Firestore.firestore().collection(Constants.FirebaseDB.user_ref)
            .document(Auth.auth().currentUser!.uid)
        
        ref.updateData([
            Constants.FirebaseDB.first_name: newFirstName,
            Constants.FirebaseDB.last_name: newLastName
        ]) { (error) in
            
            if let error = error {
                
                print("Error updating information \(error)")
            } else {
                
                currentUser.firstName = newFirstName
                currentUser.lastName = newLastName
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
