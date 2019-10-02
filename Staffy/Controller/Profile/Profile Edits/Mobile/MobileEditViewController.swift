//
//  MobileEditViewController.swift
//  Staffy
//
//  Created by Aidan Miskella on 26/09/2019.
//  Copyright © 2019 Aidan Miskella. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MobileEditViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var mobileTextField: UITextField!
    
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
        Utilities.styleTextField(textfield: mobileTextField, font: .editProfileText, fontColor: .black, padding: 0.0)
        Utilities.styleFilledButton(button: saveButton, font: .largeLoginButton, fontColor: .white, backgroundColor: .lightBlue, cornerRadius: 10.0)
    }
    
    func placeholders() {
        
        guard let currentUser = UserService.currentUser else { return }
        
        if currentUser.mobile == "Not set" {
            
            mobileTextField.placeholder = "01 234 5678"
        } else {
            
            mobileTextField.placeholder = currentUser.mobile
        }
    }
    
    @IBAction func saveButtonDidPress(_ sender: UIButton) {
        
        guard let currentUser = UserService.currentUser else { return }
        
        if mobileTextField.text == "" {
            
            self.navigationController?.popViewController(animated: true)
        } else {
            
            let ref = Firestore.firestore().collection(Constants.FirebaseDB.user_ref)
                .document(Auth.auth().currentUser!.uid)
            
            ref.updateData([
                Constants.FirebaseDB.mobile: mobileTextField.text!
            ]) { (error) in
                
                if let error = error {
                    
                    print("Error updating information \(error)")
                } else {
                    
                    currentUser.mobile = self.mobileTextField.text!
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
