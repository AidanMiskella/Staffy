//
//  DateOfBirthEditViewController.swift
//  Staffy
//
//  Created by Aidan Miskella on 26/09/2019.
//  Copyright © 2019 Aidan Miskella. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class DateOfBirthEditViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    
    @IBOutlet weak var dobImage: UIImageView!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        placeholders()
        pickUpDate()
        
        dateOfBirthTextField.delegate = self
    }
    
    func setupUI() {
        
        topView.layerGradient()
        errorLabel.alpha = 0
        
        Utilities.styleLabel(label: titleLabel, font: .editProfileTitle, fontColor: .white)
        Utilities.styleTextField(textfield: dateOfBirthTextField, font: .editProfileText, fontColor: .black, padding: 40.0)
        Utilities.styleImage(imageView: dobImage, image: "calendar", imageColor: .lightGray)
        Utilities.styleLabel(label: errorLabel, font: .loginError, fontColor: .red)
        Utilities.styleFilledButton(button: saveButton, font: .largeLoginButton, fontColor: .white, backgroundColor: .lightBlue, cornerRadius: 10.0)
    }
    
    func placeholders() {
        
        guard let currentUser = UserService.currentUser else { return }
        
        if currentUser.dateOfBirth == "Not set" {
            
            dateOfBirthTextField.placeholder = "19 December 1997"
        } else {
            
            dateOfBirthTextField.placeholder = currentUser.dateOfBirth
        }
    }
    
    func pickUpDate() {
        
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 300))
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = .date
        dateOfBirthTextField.inputView = self.datePicker
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = .lightBlue
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        dateOfBirthTextField.inputAccessoryView = toolBar
    }
    
    @objc func doneClick() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        dateOfBirthTextField.text = formatter.string(from: datePicker.date)
        dateOfBirthTextField.resignFirstResponder()
    }
    @objc func cancelClick() {
        
        dateOfBirthTextField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return false
    }
    
    @IBAction func saveDidPress(_ sender: UIButton) {
        
        guard let currentUser = UserService.currentUser else { return }
        
        if dateOfBirthTextField.text == "" {
            
            errorLabel.alpha = 1
            errorLabel.text = "Please enter a date."
        } else {
            
            let ref = Firestore.firestore().collection(Constants.FirebaseDB.user_ref)
                .document(Auth.auth().currentUser!.uid)
            
            ref.updateData([
                Constants.FirebaseDB.dob: dateOfBirthTextField.text!
            ]) { (error) in
                
                if let error = error {
                    
                    print("Error updating information \(error)")
                } else {
                    
                    currentUser.dateOfBirth = self.dateOfBirthTextField.text!
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
