//
//  Utilities.swift
//  customauth
//
//  Created by Christopher Ching on 2019-05-09.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    static func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 1, width: textfield.frame.width, height: 1)
        
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
        let paddingView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: textfield.frame.height))
        textfield.leftView = paddingView
        textfield.leftViewMode = UITextField.ViewMode.always

        
    }
    
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 65/255, green: 180/255, blue: 230/255, alpha: 1)
        button.layer.cornerRadius = 20.0
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.init(red: 65/255, green: 180/255, blue: 230/255, alpha: 1).cgColor
        button.layer.cornerRadius = 20.0
        button.tintColor = UIColor.black
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
}
