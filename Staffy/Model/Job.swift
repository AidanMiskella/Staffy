//
//  FoldingCellData.swift
//  StaffyAdmin
//
//  Created by Aidan Miskella on 15/10/2019.
//  Copyright © 2019 Aidan Miskella. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class Job {
    
    private(set) var jobId: String
    private(set) var companyId: String
    private(set) var title: String
    private(set) var jobCompanyName: String
    private(set) var companyName: String
    private(set) var address: String
    private(set) var experince: String
    private(set) var positions: String
    private(set) var postedDate: Timestamp
    private(set) var startDate: Timestamp
    private(set) var endDate: Timestamp
    private(set) var startTime: String
    private(set) var endTime: String
    private(set) var description: String
    private(set) var pay: Double
    private(set) var companyEmail: String
    private(set) var companyPhone: String
    private(set) var status: String
    private(set) var applicants: [String]
    private(set) var accepted: [String]
    
    init(jobId: String,
         companyId: String,
         title: String,
         companyName: String,
         jobCompanyName: String,
         address: String,
         experince: String,
         positions: String,
         postedDate: Timestamp,
         startDate: Timestamp,
         endDate: Timestamp,
         startTime: String,
         endTime: String,
         description: String,
         pay: Double,
         companyEmail: String,
         companyPhone: String,
         status: String,
         applicants: [String],
         accepted: [String]) {
        
        self.jobId = jobId
        self.companyId = companyId
        self.title = title
        self.companyName = companyName
        self.jobCompanyName = jobCompanyName
        self.address = address
        self.experince = experince
        self.positions = positions
        self.postedDate = postedDate
        self.startDate = startDate
        self.endDate = endDate
        self.startTime = startTime
        self.endTime = endTime
        self.description = description
        self.pay = pay
        self.companyEmail = companyEmail
        self.companyPhone = companyPhone
        self.status = status
        self.applicants = applicants
        self.accepted = accepted
    }
    
    class func parseData(snapshot: QuerySnapshot?) -> [Job] {
        
        var jobs = [Job]()
        
        guard let snap = snapshot else { return jobs }
        for document in snap.documents {
            
            let data = document.data()
            let jobId = document.documentID
            let companyId = data["companyId"] as? String
            let title = data["title"] as? String ?? ""
            let companyName = data["companyName"] as? String ?? ""
            let jobCompanyName = data["jobCompanyName"] as? String ?? ""
            let address = data["address"] as? String ?? ""
            let experience = data["experience"] as? String ?? ""
            let positions = data["positions"] as? String ?? ""
            let postedDate = data["postedDate"] as? Timestamp ?? Timestamp()
            let startDate = data["startDate"] as? Timestamp ?? Timestamp()
            let endDate = data["endDate"] as? Timestamp ?? Timestamp()
            let startTime = data["startTime"] as? String ?? ""
            let endTime = data["endTime"] as? String ?? ""
            let description = data["description"] as? String ?? ""
            let pay = data["pay"] as? Double ?? 0.0
            let companyEmail = data["companyEmail"] as? String ?? ""
            let companyPhone = data["companyPhone"] as? String ?? ""
            let status = data["status"] as? String ?? ""
            let applicants = data["applicants"] as? [String] ?? []
            let accepted = data["accepted"] as? [String] ?? []
            
            let newJob = Job(jobId: jobId, companyId: companyId!, title: title, companyName: companyName, jobCompanyName: jobCompanyName, address: address, experince: experience, positions: positions, postedDate: postedDate, startDate: startDate, endDate: endDate, startTime: startTime, endTime: endTime, description: description, pay: pay, companyEmail: companyEmail, companyPhone: companyPhone, status: status, applicants: applicants, accepted: accepted)
            jobs.append(newJob)
        }
        
        return jobs
    }
}
