//
//  BioEditViewController.swift
//  Staffy
//
//  Created by Aidan Miskella on 01/10/2019.
//  Copyright © 2019 Aidan Miskella. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GrowingTextView

class BioEditViewController: UIViewController {

    @IBOutlet weak var textView: GrowingTextView!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        placeholders()
    }
    
    func setupUI() {
        
        errorLabel.alpha = 0
        
        Utilities.styleTextView(textView: textView, font: .editProfilViewText, fontColor: .black)
        Utilities.styleLabel(label: errorLabel, font: .loginError, fontColor: .red)
        Utilities.styleFilledButton(button: saveButton, font: .largeLoginButton, fontColor: .white, backgroundColor: .lightBlue, cornerRadius: 10.0)
    }
    
    func placeholders() {
        
        guard let currentUser = UserService.currentUser else { return }
        
        textView.trimWhiteSpaceWhenEndEditing = false
        textView.text = currentUser.bio
        textView.textColor = UIColor.black
        textView.maxLength = 200
    }
    
    @IBAction func saveButtonDidPress(_ sender: UIButton) {
        
        guard let currentUser = UserService.currentUser else { return }
        
        if textView.text == "" {
            
            errorLabel.alpha = 1
            errorLabel.text = "Please enter a bio description."
        } else {
            
            let ref = Firestore.firestore().collection(Constants.FirebaseDB.user_ref)
                .document(Auth.auth().currentUser!.uid)
            
            ref.updateData([
                Constants.FirebaseDB.bio: textView.text!
            ]) { (error) in
                
                if let error = error {
                    
                    print("Error updating information \(error)")
                } else {
                    
                    currentUser.bio = self.textView.text!
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
