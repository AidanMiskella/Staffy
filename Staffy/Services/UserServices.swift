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
    static var currentCompany: Company?
    
    static func observeUserProfile(_ userId: String, completion: @escaping ((_ user: User?)->())) {
        
        let userRef = Firestore.firestore().collection(Constants.FirebaseDB.user_ref)
            .document(userId)
        
        userRef.getDocument { (snapshot, err) in
            
            var user: User?
            
            if let error = err {
                
                print(error)
            } else {
            
                if let data = snapshot?.data() {
                    
                    if let firstName = data[Constants.FirebaseDB.first_name] as? String,
                    let lastName = data[Constants.FirebaseDB.last_name] as? String,
                    let avatarURL = data[Constants.FirebaseDB.avatar_url] as? String,
                    let bio = data[Constants.FirebaseDB.bio] as? String,
                    let reviewRating = data[Constants.FirebaseDB.reviewRating] as? Double,
                    let mobile = data[Constants.FirebaseDB.mobile] as? String,
                    let documents = data[Constants.FirebaseDB.documents] as? [Any],
                    let address = data[Constants.FirebaseDB.address] as? String,
                    let gender = data[Constants.FirebaseDB.gender] as? String,
                    let dateOfBirth = data[Constants.FirebaseDB.dob] as? String,
                    let dateProfileCreated = data[Constants.FirebaseDB.date_created] as? String,
                    let allApplications = data[Constants.FirebaseDB.all_applicants] as? [String],
                    let jobsApplied = data[Constants.FirebaseDB.jobs_applied] as? [String],
                    let jobsAccepted = data[Constants.FirebaseDB.jobs_accepted] as? [String],
                    let jobsCompleted = data[Constants.FirebaseDB.jobs_completed] as? Int,
                    let url = URL(string: avatarURL) {
                        
                        user = User(userId: userId, firstName: firstName, lastName: lastName, avatarURL: url, bio: bio, reviewRating: reviewRating, mobile: mobile, documents: documents, address: address, gender: gender, dateOfBirth: dateOfBirth, dateProfileCreated: dateProfileCreated, jobsApplied: jobsApplied, allApplications: allApplications, jobsAccepted: jobsAccepted, jobsCompleted: jobsCompleted)
                    }
                    
                    completion(user)
                }
            }
        }
    }
    
    static func observeCompanyProfile(_ userId: String, completion: @escaping ((_ company: Company?)->())) {
        
        let companyRef = Firestore.firestore().collection(Constants.FirebaseDB.company_ref)
            .document(userId)
        
        companyRef.getDocument { (snapshot, err) in
            
            var company: Company?
            
            if let error = err {
                
                print(error)
            } else {
                
                if let data = snapshot?.data() {
                    
                    if let companyName = data[Constants.FirebaseDB.company_name] as? String,
                        let firstName = data[Constants.FirebaseDB.first_name] as? String,
                        let lastName = data[Constants.FirebaseDB.last_name] as? String,
                        let avatarURL = data[Constants.FirebaseDB.avatar_url] as? String,
                        let bio = data[Constants.FirebaseDB.bio] as? String,
                        let reviewRating = data[Constants.FirebaseDB.reviewRating] as? Double,
                        let mobile = data[Constants.FirebaseDB.mobile] as? String,
                        let address = data[Constants.FirebaseDB.address] as? String,
                        let dateProfileCreated = data[Constants.FirebaseDB.date_created] as? String,
                        let jobsCompleted = data[Constants.FirebaseDB.jobs_completed] as? Int,
                        let url = URL(string: avatarURL) {
                        
                        company = Company(userId: userId, companyName: companyName, firstName: firstName, lastName: lastName, avatarURL: url, bio: bio, reviewRating: reviewRating, mobile: mobile, address: address, dateProfileCreated: dateProfileCreated, jobsCompleted: jobsCompleted)
                    }
                    
                    completion(company)
                }
            }
        }
    }
}
