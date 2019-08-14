//
//  ErrorExtension.swift
//  Staffy
//
//  Created by Aidan Miskella on 05/08/2019.
//  Copyright © 2019 Aidan Miskella. All rights reserved.
//

import Foundation
import FirebaseAuth

extension AuthErrorCode {
    
    var errorMessage: String {
        
        switch self {
        case .emailAlreadyInUse:
            return Constants.LoginError.email_in_use
        case .userNotFound:
            return Constants.LoginError.user_not_found
        case .userDisabled:
            return Constants.LoginError.user_disabled
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return Constants.LoginError.invalid_email
        case .networkError:
            return Constants.LoginError.network_error
        case .weakPassword:
            return Constants.LoginError.weak_password
        case .wrongPassword:
            return Constants.LoginError.wrong_password
        default:
            return Constants.LoginError.default_error
        }
    }
}
