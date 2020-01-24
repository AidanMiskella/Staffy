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
    var email: String
    var firstName: String
    var lastName: String
    var avatarURL: URL?
    var bio: String?
    var reviewRating: Double?
    var mobile: String?
    var documents: [Any]?
    var address: String?
    var gender: String?
    var dateOfBirth: String?
    var dateProfileCreated: String
    var allApplications: [String]?
    var jobsApplied: [String]?
    var jobsAccepted: [String]?
    var jobsCompleted: Int?
    
    init(userId: String,
         email: String,
         firstName: String,
         lastName: String,
         avatarURL: URL,
         bio: String?,
         reviewRating: Double?,
         mobile: String?,
         documents: [Any]?,
         address: String?,
         gender: String?,
         dateOfBirth: String?,
         dateProfileCreated: String,
         jobsApplied: [String]?,
         allApplications: [String]?,
         jobsAccepted: [String]?,
         jobsCompleted: Int?) {
        
        self.userId = userId
        self.email = email
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
        self.allApplications = allApplications
        self.jobsApplied = jobsApplied
        self.jobsAccepted = jobsAccepted
        self.jobsCompleted = jobsCompleted
    }
}
