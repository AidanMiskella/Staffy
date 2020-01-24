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
        static let profileViewController = "profileRoot"
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
        static let company_ref = "companies"
        static let jobs_ref = "jobs"
        static let reports_ref = "reports"
        
        static let user_id = "userID"
        static let email = "email"
        static let company_name = "companyName"
        static let first_name = "firstName"
        static let last_name = "lastName"
        static let avatar_url = "avatarURL"
        static let bio = "bio"
        static let reviewRating = "rating"
        static let mobile = "mobile"
        static let documents = "documents"
        static let address = "address"
        static let gender = "gender"
        static let dob = "dob"
        static let date_created = "dateCreated"
        static let jobs_created = "jobsCreated"
        static let jobs_applied = "jobsApplied"
        static let jobs_accepted = "jobsAccepted"
        
        static let job_id = "jobId"
        static let company_id = "companyId"
        static let title = "title"
        static let job_company_name = "jobCompanyName"
        static let experience = "experience"
        static let positions = "positions"
        static let posted_date = "postedDate"
        static let start_date = "startDate"
        static let end_date = "endDate"
        static let start_time = "startTime"
        static let end_time = "endTime"
        static let description = "description"
        static let pay = "pay"
        static let company_email = "companyEmail"
        static let company_phone = "companyPhone"
        static let applicants = "applicants"
        static let accepted = "accepted"
        static let status = "status"
        static let all_applicants = "allApplicants"
        static let jobs_completed = "jobsCompleted"
        
        static let report_id = "reportId"
        static let report_status = "reportStatus"
        static let clocking_messages = "clockingMessages"
        static let employer_star_rating = "employerStarRating"
        static let employer_comment = "employerComment"
        static let signature_url = "signatureURL"
        static let employee_star_rating = "employeeStarRating"
        static let employee_comment = "employeeComment"
        static let signature_employer_name = "signatureEmployerName"
        static let signature_employer_position = "signatureEmployerPosition"
        static let report_open = "reportOpen"
    }
    
    struct Profile {
        
        static let ratingError = "An error has occured getting your rating"
        static let rating = "of 5 Average Rating"
        static let no_rating = "No reviews yet"
        static let notSet = "Not set"
        static let bioDescription = """
                                    This is a few short lines to describe who you are, what you do and what kind of job you are looking for. Edit your personal statement by clicking below.
                                    """
    }
    
    struct Report {
        
        static let notClockedIn = "Not clocked in"
        static let clockedIn = "Clocked in"
        static let onBreak = "On break"
        static let clockedOut = "Clocked out"
        static let reportComlpete = "Report complete"
    }
    
    struct Arrays {
        
        static let genderArray = ["Male", "Female", "Other"]
        static let countyArray = ["Co. Antrim", "Co. Armagh", "Co. Carlow", "Co. Cavan", "Co. Clare", "Co. Cork", "Co. Derry", "Co. Donegal", "Co. Down", "Co. Dublin", "Co. Fermanagh", "Co. Galway", "Co. Kerry", "Co. Kildare", "Co. Kilkenny", "Co. Laois", "Co. Leitrim", "Co. Limerick", "Co. Longford", "Co. Louth", "Co. Mayo", "Co. Meath", "Co. Monaghan", "Co. Offaly", "Co. Roscommon", "Co. Sligo", "Co. Tipperary", "Co. Tyrone", "Co. Waterford", "Co. Westmeath", "Co. Wexford", "Co. Wicklow"]
        static let experienceArray = ["No Experience Required", "Experience Required", "Experience Required (1+ Year)", "Experience Required (2+ Years)", "Experience Required (3+ Years)", "Experience Required (4+ Years)", "Experience Required (5+ Year)", "Experience Required (10+ Year)"]
        static let positionsArray = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10+", "20+", "50+", "100+"]
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
