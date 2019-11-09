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
    
    static func styleTextView(textView: UITextView, font: UIFont, fontColor: UIColor) {
        
        textView.font = font
        textView.textColor = fontColor
        
        textView.layer.backgroundColor = UIColor.white.cgColor
        
        textView.layer.masksToBounds = false
        textView.layer.shadowColor = UIColor.lightGray.cgColor
        textView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        textView.layer.shadowOpacity = 1.0
        textView.layer.shadowRadius = 0.0
    }
    
    static func styleLabel(label: UILabel, font: UIFont, fontColor: UIColor) {
        
        label.font = font
        label.textColor = fontColor
    }
    
    static func styleTextField(textfield: UITextField, font: UIFont, fontColor: UIColor, padding: CGFloat) {
        
        textfield.font = font
        textfield.textColor = fontColor
        textfield.clearButtonMode = UITextField.ViewMode.whileEditing
        
        textfield.borderStyle = .none
        textfield.layer.backgroundColor = UIColor.white.cgColor
        
        textfield.layer.masksToBounds = false
        textfield.layer.shadowColor = UIColor.lightGray.cgColor
        textfield.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        textfield.layer.shadowOpacity = 1.0
        textfield.layer.shadowRadius = 0.0
        
        let paddingView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: padding, height: textfield.frame.height))
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
    
    static func setupNavigationStyle(_ nav: UINavigationController) {
        
        nav.navigationBar.barTintColor = .lightBlue
        nav.navigationBar.tintColor = .white
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldLargeTitle]
    }
    
    static func setupNavigationStyleNoBorder(_ nav: UINavigationController) {
        
        nav.navigationBar.barTintColor = .lightBlue
        nav.navigationBar.tintColor = .white
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        nav.navigationBar.shadowImage = UIImage()
        nav.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldLargeTitle]
    }
    
    static func dateFormatterFullMonth(_ date: Date) -> String {
        
        let df = DateFormatter()
        df.dateFormat = "dd MMMM yyyy"
        let result = df.string(from: date)
        
        return result
    }
    
    static func dateFormatterShortMonth(_ date: Date) -> String {
        
        let df = DateFormatter()
        df.dateFormat = "dd MMM yyyy"
        let result = df.string(from: date)
        
        return result
    }
    
    static func dateFormatterWeekDay(_ date: Date) -> String {
        
        let df = DateFormatter()
        df.dateFormat = "EEEE"
        let result = df.string(from: date)
        
        return result
    }
    
    static func timeAgoSinceDate(_ date:Date,currentDate:Date, numericDates:Bool) -> String {
        
        let calendar = Calendar.current
        let now = currentDate
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
    }
}
