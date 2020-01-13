//
//  EmployeeFeedbackViewController.swift
//  Staffy
//
//  Created by Aidan Miskella on 07/01/2020.
//  Copyright © 2020 Aidan Miskella. All rights reserved.
//

import UIKit
import GrowingTextView
import Cosmos
import SignaturePad
import SCLAlertView
import Firebase
import FirebaseAuth

class EmployeeFeedbackViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var starRating: CosmosView!
    
    @IBOutlet weak var commentsTextView: GrowingTextView!
    
    var job: Job!
    var currentReport: Report!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupElements()
        connectOutlets()
    }
    
    func setupElements() {
        
        Utilities.styleTextView(textView: commentsTextView, font: .editProfileText, fontColor: .black)
    }
    
    func connectOutlets() {
        
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.masksToBounds = false
        avatarImageView.layer.borderColor = UIColor.gray.cgColor
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        avatarImageView.clipsToBounds = true
        
        UserService.observeCompanyProfile(job.companyId) { (company) in
            
            ImageService.getImage(withURL: company!.avatarURL!) { (image) in
                
                self.avatarImageView.image = image
            }
        }
        
        if currentReport.reportOpen == false {
            
            starRating.isUserInteractionEnabled = false
            commentsTextView.isEditable = false
            starRating.rating = currentReport.employeeStarRating
            commentsTextView.text = currentReport.employeeComment
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @IBAction func finishButtonTapped(_ sender: Any) {
        
        UserService.observeCompanyProfile(job.companyId) { (company) in
            
            let batch = Firestore.firestore().batch()
            
            let company_ref = Firestore.firestore().collection(Constants.FirebaseDB.company_ref).document(company!.userId)
            let report_ref =  Firestore.firestore().collection(Constants.FirebaseDB.jobs_ref).document(self.job!.jobId).collection(Constants.FirebaseDB.reports_ref).document(self.currentReport.reportId)
            
            batch.updateData([Constants.FirebaseDB.reviewRating: self.starRating.rating + company!.reviewRating!,
                              Constants.FirebaseDB.jobs_completed: company!.jobsCompleted + 1], forDocument: company_ref)
            
            batch.updateData([Constants.FirebaseDB.employee_star_rating: self.starRating.rating,
                              Constants.FirebaseDB.employee_comment: self.commentsTextView.text!,
                              Constants.FirebaseDB.report_open: false], forDocument: report_ref)
            
            batch.commit() { err in
                
                if let err = err {
                    
                    print("Error writing batch \(err)")
                } else {
                    
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
}
