//
//  User.swift
//  Staffy
//
//  Created by Aidan Miskella on 19/09/2019.
//  Copyright © 2019 Aidan Miskella. All rights reserved.
//

import Foundation

class User {
    
    var userId: String
    var firstName: String
    var lastName: String
    var avatarURL: URL?
    var bio: String?
    var reviewRating: Float?
    var mobile: String?
    var documents: [Any]?
    var address: String?
    var gender: String?
    var dateOfBirth: String?
    var dateProfileCreated: String
    var jobsApplied: [Any]?
    var jobsAccepted: [Any]?
    
    init(userId: String,
         firstName: String,
         lastName: String,
         avatarURL: URL,
         bio: String?,
         reviewRating: Float?,
         mobile: String?,
         documents: [Any]?,
         address: String?,
         gender: String?,
         dateOfBirth: String?,
         dateProfileCreated: String,
         jobsApplied: [Any]?,
         jobsAccepted: [Any]?) {
        
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.avatarURL = avatarURL
        self.bio = bio
        self.reviewRating = reviewRating
        self.mobile = mobile
        self.documents = documents
        self.address = address
        self.gender = gender
        self.dateOfBirth = dateOfBirth
        self.dateProfileCreated = dateProfileCreated
        self.jobsApplied = jobsApplied
        self.jobsAccepted = jobsAccepted
    }
}
