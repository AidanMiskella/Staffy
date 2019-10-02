//
//  UserServices.swift
//  Staffy
//
//  Created by Aidan Miskella on 19/09/2019.
//  Copyright © 2019 Aidan Miskella. All rights reserved.
//

import Foundation
import Firebase

class UserService {
    
    static var currentUser: User?
    
    static func observeUserProfile(_ userId: String, completion: @escaping ((_ user: User?)->())) {
        
        let userRef = Firestore.firestore().collection(Constants.FirebaseDB.user_ref)
            .document(userId)
        
        userRef.getDocument { (snapshot, err) in
            
            var user: User?
            
            if let error = err {
                
                print(error)
            } else {
            
                if let data = snapshot?.data() {
                    
                    if let email = data[Constants.FirebaseDB.email] as? String,
                    let firstName = data[Constants.FirebaseDB.first_name] as? String,
                    let lastName = data[Constants.FirebaseDB.last_name] as? String,
                    let avatarURL = data[Constants.FirebaseDB.avatar_url] as? String,
                    let bio = data[Constants.FirebaseDB.bio] as? String,
                    let reviewRating = data[Constants.FirebaseDB.reviewRating] as? Float,
                    let mobile = data[Constants.FirebaseDB.mobile] as? String,
                    let documents = data[Constants.FirebaseDB.documents] as? [Any],
                    let address = data[Constants.FirebaseDB.address] as? String,
                    let gender = data[Constants.FirebaseDB.gender] as? String,
                    let dateOfBirth = data[Constants.FirebaseDB.dob] as? String,
                    let dateProfileCreated = data[Constants.FirebaseDB.date_created] as? String,
                    let jobsApplied = data[Constants.FirebaseDB.jobs_applied] as? [Any],
                    let jobsAccepted = data[Constants.FirebaseDB.jobs_accepted] as? [Any],
                    let url = URL(string: avatarURL) {
                        
                        user = User(userId: userId, email: email, firstName: firstName, lastName: lastName, avatarURL: url, bio: bio, reviewRating: reviewRating, mobile: mobile, documents: documents, address: address, gender: gender, dateOfBirth: dateOfBirth, dateProfileCreated: dateProfileCreated, jobsApplied: jobsApplied, jobsAccepted: jobsAccepted)
                    }
                    
                    completion(user)
                }
            }
        }
    }
}
