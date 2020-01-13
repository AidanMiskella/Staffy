//
//  Report.swift
//  Staffy
//
//  Created by Aidan Miskella on 04/01/2020.
//  Copyright © 2020 Aidan Miskella. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class Report {
    
    private(set) var userId: String
    private(set) var reportId: String
    private(set) var reportStatus: String
    private(set) var clockingMessages: [String]
    private(set) var employerStarRating: Double
    private(set) var employerComment: String
    private(set) var signatureURL: URL?
    private(set) var employeeStarRating: Double
    private(set) var employeeComment: String
    private(set) var reportOpen: Bool
    
    init(userId: String,
         reportId: String,
         reportStatus: String,
         clockingMessages: [String],
         employerStarRating: Double,
         employerComment: String,
         signatureURL: URL?,
         employeeStarRating: Double,
         employeeComment: String,
         reportOpen: Bool) {
        
        self.userId = userId
        self.reportId = reportId
        self.reportStatus = reportStatus
        self.clockingMessages = clockingMessages
        self.employerStarRating = employerStarRating
        self.employerComment = employerComment
        self.signatureURL = signatureURL
        self.employeeStarRating = employeeStarRating
        self.employeeComment = employeeComment
        self.reportOpen = reportOpen
        
    }
    
    class func parseData(snapshot: QuerySnapshot?) -> [Report] {
        
        var reports = [Report]()
        
        guard let snap = snapshot else { return reports }
        for document in snap.documents {
            
            let data = document.data()
            let userId = data["userId"] as? String ?? ""
            let reportId = data["reportId"] as? String ?? ""
            let reportStatus = data["reportStatus"] as? String ?? ""
            let clockingMessages = data["clockingMessages"] as? [String] ?? [""]
            let employerStarRating = data["employeeStarRating"] as? Double ?? 0.0
            let employerComment = data["employerComment"] as? String ?? ""
            let signatureURL = data["signatureURL"] as? String ?? ""
            let employeeStarRating = data["employeeStarRating"] as? Double ?? 0.0
            let employeeComment = data["employeeComment"] as? String ?? ""
            let reportOpen = data["reportOpen"] as? Bool ?? true
            let url = URL(string: signatureURL)
                
            let newReport = Report(userId: userId, reportId: reportId, reportStatus: reportStatus, clockingMessages: clockingMessages, employerStarRating: employerStarRating, employerComment: employerComment, signatureURL: url, employeeStarRating: employeeStarRating, employeeComment: employeeComment, reportOpen: reportOpen)
            reports.append(newReport)
        }
        
        return reports
    }
}
