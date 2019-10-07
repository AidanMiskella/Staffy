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
    
    @IBOutlet weak var mobileImage: UIImageView!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        placeholders()
    }
    
    func setupUI() {
        
        topView.layerGradient()
        errorLabel.alpha = 0
        
        Utilities.styleLabel(label: titleLabel, font: .editProfileTitle, fontColor: .white)
        Utilities.styleTextField(textfield: mobileTextField, font: .editProfileText, fontColor: .black, padding: 40.0)
        Utilities.styleLabel(label: errorLabel, font: .loginError, fontColor: .red)
        Utilities.styleImage(imageView: mobileImage, image: "phone-handset", imageColor: .lightGray)
        Utilities.styleFilledButton(button: saveButton, font: .largeLoginButton, fontColor: .white, backgroundColor: .lightBlue, cornerRadius: 10.0)
    }
    
    func placeholders() {
        
        guard let currentUser = UserService.currentUser else { return }
        
        if currentUser.mobile == "Not set" {
            
            mobileTextField.placeholder = "012 345 6789"
        } else {
            
            mobileTextField.placeholder = currentUser.mobile
        }
    }
    
    @IBAction func saveButtonDidPress(_ sender: UIButton) {
        
        guard let currentUser = UserService.currentUser else { return }
        
        if mobileTextField.text == "" {
            
            errorLabel.alpha = 1
            errorLabel.text = "Please enter a mobile number."
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
