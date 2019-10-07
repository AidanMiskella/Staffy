//
//  AddressEditViewController.swift
//  Staffy
//
//  Created by Aidan Miskella on 26/09/2019.
//  Copyright © 2019 Aidan Miskella. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AddressEditViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var address1: UITextField!
    
    @IBOutlet weak var address2: UITextField!
    
    @IBOutlet weak var address3: UITextField!
    
    @IBOutlet weak var address4: UITextField!
    
    @IBOutlet weak var address1Image: UIImageView!
    
    @IBOutlet weak var address2Image: UIImageView!
    
    @IBOutlet weak var address3Image: UIImageView!
    
    @IBOutlet weak var address4Image: UIImageView!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var countyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        placeholders()
        pickUpDate()
        
        self.countyPicker.delegate = self
        self.countyPicker.dataSource = self
        address4.delegate = self
    }
    
    func setupUI() {
        
        topView.layerGradient()
        errorLabel.alpha = 0
        
        Utilities.styleLabel(label: titleLabel, font: .editProfileTitle, fontColor: .white)
        Utilities.styleTextField(textfield: address1, font: .editProfileText, fontColor: .black, padding: 40.0)
        Utilities.styleTextField(textfield: address2, font: .editProfileText, fontColor: .black, padding: 40.0)
        Utilities.styleTextField(textfield: address3, font: .editProfileText, fontColor: .black, padding: 40.0)
        Utilities.styleTextField(textfield: address4, font: .editProfileText, fontColor: .black, padding: 40.0)
        Utilities.styleImage(imageView: address1Image, image: "home", imageColor: .lightGray)
        Utilities.styleImage(imageView: address2Image, image: "home", imageColor: .lightGray)
        Utilities.styleImage(imageView: address3Image, image: "home", imageColor: .lightGray)
        Utilities.styleImage(imageView: address4Image, image: "home", imageColor: .lightGray)
        Utilities.styleLabel(label: errorLabel, font: .loginError, fontColor: .red)
        Utilities.styleFilledButton(button: saveButton, font: .largeLoginButton, fontColor: .white, backgroundColor: .lightBlue, cornerRadius: 10.0)
    }
    
    func placeholders() {
        
        address1.placeholder = "Address 1"
        address2.placeholder = "Address 2 (Optional)"
        address3.placeholder = "Town/City"
        address4.placeholder = "County"
    }
    
    func pickUpDate() {
        
        self.countyPicker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 300))
        self.countyPicker.backgroundColor = UIColor.white
        
        address4.inputView = self.countyPicker
        
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
        address4.inputAccessoryView = toolBar
    }
    
    @objc func doneClick() {
        
        address4.text = Constants.Profile.countyArray[self.countyPicker.selectedRow(inComponent: 0)]
        address4.resignFirstResponder()
    }
    
    @objc func cancelClick() {
        
        address4.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return Constants.Profile.countyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return Constants.Profile.countyArray[row]
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return false
    }
    
    @IBAction func saveButtonDidPress(_ sender: UIButton) {
        
        guard let currentUser = UserService.currentUser else { return }
        
        if address1.text == "" || address3.text == "" || address4.text == "" {
            
            errorLabel.alpha = 1
            errorLabel.text = "Please fill in all fields."
        } else {
            
            var fullAddress: String
            let ref = Firestore.firestore().collection(Constants.FirebaseDB.user_ref)
                .document(Auth.auth().currentUser!.uid)
            
            if address2.text == "" {
                
                fullAddress = "\(address1.text!), \(address3.text!), \(address4.text!)"
            } else {
                
                fullAddress = "\(address1.text!), \(address2.text!), \(address3.text!), \(address4.text!)"
            }
            
            ref.updateData([
                Constants.FirebaseDB.address: fullAddress
            ]) { (error) in
                
                if let error = error {
                    
                    print("Error updating information \(error)")
                } else {
                    
                    currentUser.address = fullAddress
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
