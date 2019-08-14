//
//  Utilities.swift
//  Staffy
//
//  Created by Aidan Miskella on 03/08/2019.
//  Copyright © 2019 Aidan Miskella. All rights reserved.
//


import Foundation
import UIKit
import FirebaseAuth

class Utilities {
    
    static func styleLabel(label: UILabel, font: UIFont, fontColor: UIColor) {
        
        label.font = font
        label.textColor = fontColor
    }
    
    static func styleTextField(textfield: UITextField, font: UIFont, fontColor: UIColor) {
        
        textfield.font = font
        textfield.textColor = fontColor
        
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
    
    static func styleFilledButton(button: UIButton, font: UIFont, fontColor: UIColor, backgroundColor: UIColor, cornerRadius: CGFloat) {
        
        button.titleLabel?.font = font
        button.tintColor = fontColor
        
        // Filled rounded corner style
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = cornerRadius
    }
    
    static func styleHollowButton(button: UIButton, font: UIFont, fontColor: UIColor, borderWidth: CGFloat, cornerRadius: CGFloat) {
        
        button.titleLabel?.font = font
        button.tintColor = fontColor
        
        // Hollow rounded corner style
        button.layer.borderWidth = borderWidth
        button.layer.borderColor = fontColor.cgColor
        button.layer.cornerRadius = cornerRadius
    }
    
    static func styleImage(imageView: UIImageView, image: String, imageColor: UIColor) {
        
        imageView.image = UIImage(named: image)
        imageView.tintColor = imageColor
    }
}
