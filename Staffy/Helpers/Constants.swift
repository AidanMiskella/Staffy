//
//  Constants.swift
//  Staffy
//
//  Created by Aidan Miskella on 03/08/2019.
//  Copyright © 2019 Aidan Miskella. All rights reserved.
//


import Foundation
import SCLAlertView

struct Constants {
    
    struct Storyboard {
        
        static let main = "main"
        static let homeViewController = "homeRoot"
        static let loginViewController = "loginRoot"
    }
    
    struct LoginError {
        
        static let email_in_use = "The email is already in use with another account."
        static let user_not_found = "Account not found for the specified user."
        static let user_disabled = "Your account has been disabled. Please contact support."
        static let invalid_email = "Please enter a valid email."
        static let network_error = "Network error. Please try again."
        static let weak_password = "The password must be 6 characters long or more."
        static let wrong_password = "Your password is incorrect. Please try again."
        static let default_error = "An error has occured."
    }
    
    struct FirebaseDB {
        
        static let user_ref = "users"
        
        static let email = "email"
        static let date_created = "dateCreated"
        static let user_id = "userID"
        static let first_name = "firstName"
        static let last_name = "lastName"
    }
    
    struct AlertView {
        
        static let appearance = SCLAlertView.SCLAppearance(
            
            kWindowWidth: 300.0,
            kWindowHeight: 600.0,
            kTitleFont: .largeTitle,
            kTextFont: .subTitle,
            kButtonFont: .largeLoginButton,
            showCloseButton: false
        )
    }
}
