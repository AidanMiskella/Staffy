//
//  JobViewController.swift
//  Staffy
//
//  Created by Aidan Miskella on 24/11/2019.
//  Copyright © 2019 Aidan Miskella. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SCLAlertView
import Cosmos
import GrowingTextView

class JobViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var companyNameLabel: UILabel!
    
    @IBOutlet weak var companyRating: CosmosView!
    
    @IBOutlet weak var manageButton: UIButton!
    
    @IBOutlet weak var deleteJob: UIButton!
    
    @IBOutlet weak var jobTitleLabel: UILabel!
    
    @IBOutlet weak var jobCompanyNameLabel: UILabel!
    
    @IBOutlet weak var jobLocationLabel: UILabel!
    
    @IBOutlet weak var experienceLabel: UILabel!
    
    @IBOutlet weak var positionsLabel: UILabel!
    
    @IBOutlet weak var datesLabel: UILabel!
    
    @IBOutlet weak var timesLabel: UILabel!
    
    @IBOutlet weak var payLabel: UILabel!
    
    @IBOutlet weak var companyEmailLabel: UILabel!
    
    @IBOutlet weak var companyPhoneLabel: UILabel!
    
    @IBOutlet weak var jobDescriptionTextView: GrowingTextView!
    
    var job: Job?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupElements()
        connectOutlets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        if job?.status == "inProgress" || job?.status == "closed" {
            
            manageButton.setTitle("View Report", for: .normal)
        }
        
        else if (job?.applicants.contains(currentUserId))! {
            
            manageButton.setTitle("Remove Application", for: .normal)
        }
        
        else if (job?.accepted.contains(currentUserId))! {
            
            manageButton.setTitle("Leave Job", for: .normal)
        }else {
            
            manageButton.setTitle("Apply", for: .normal)
        }
    }
    
    func setupElements() {
        
        Utilities.styleLabel(label: companyNameLabel, font: .largeTitle, fontColor: .black)
        Utilities.styleLabel(label: jobTitleLabel, font: .editProfileText, fontColor: .black)
        Utilities.styleLabel(label: jobCompanyNameLabel, font: .editProfileText, fontColor: .black)
        Utilities.styleLabel(label: jobLocationLabel, font: .editProfileText, fontColor: .black)
        Utilities.styleLabel(label: experienceLabel, font: .editProfileText, fontColor: .black)
        Utilities.styleLabel(label: positionsLabel, font: .editProfileText, fontColor: .black)
        Utilities.styleLabel(label: datesLabel, font: .editProfileText, fontColor: .black)
        Utilities.styleLabel(label: timesLabel, font: .editProfileText, fontColor: .black)
        Utilities.styleLabel(label: payLabel, font: .editProfileText, fontColor: .black)
        Utilities.styleLabel(label: companyEmailLabel, font: .editProfileText, fontColor: .black)
        Utilities.styleLabel(label: companyPhoneLabel, font: .editProfileText, fontColor: .black)
        Utilities.styleFilledButton(button: manageButton, font: .largeLoginButton, fontColor: .white, backgroundColor: .lightBlue, cornerRadius: 10.0)
        Utilities.styleTextView(textView: jobDescriptionTextView, font: .editProfileText, fontColor: .black)
    }
    
    func connectOutlets() {
        
        companyRating.isUserInteractionEnabled = false
        
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.masksToBounds = false
        avatarImageView.layer.borderColor = UIColor.gray.cgColor
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        avatarImageView.clipsToBounds = true
        
        UserService.observeCompanyProfile(job!.companyId) { (company) in
            
            ImageService.getImage(withURL: company!.avatarURL!) { (image) in
                
                self.avatarImageView.image = image
            }
        }
        
        guard let positions = job?.positions,
            let startTime = job?.startTime,
            let endTime = job?.endTime,
            let pay = job?.pay else { return }
        
        companyNameLabel.text = job?.companyName
        jobTitleLabel.text = job?.title
        jobCompanyNameLabel.text = job?.jobCompanyName
        jobLocationLabel.text = job?.address
        experienceLabel.text = job?.experince
        positionsLabel.text = "\(positions) positions"
        datesLabel.text = "\(Utilities.dateFormatterShortMonth((job?.startDate.dateValue())!)) - \(Utilities.dateFormatterShortMonth((job?.endDate.dateValue())!))"
        timesLabel.text = "\(startTime) - \(endTime)"
        payLabel.text = "€\(pay)"
        companyEmailLabel.text = job?.companyEmail
        companyPhoneLabel.text = job?.companyPhone
        jobDescriptionTextView.text = job?.description
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "viewreport" {
            
            let vc = segue.destination as! ReportViewController
            vc.job = job
        }
    }
    
    @IBAction func actionButton(_ sender: Any) {
        
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        let batch = Firestore.firestore().batch()
        
        if job?.status == "inProgress" || job?.status == "closed" {
            
            // view report
            performSegue(withIdentifier: "viewreport", sender: self)
        }
            
        else if (job?.applicants.contains(currentUserId))! {
            
            // remove application
            let job_ref = Firestore.firestore().collection(Constants.FirebaseDB.jobs_ref)
                .document(self.job!.jobId)
            
            batch.updateData([
                Constants.FirebaseDB.applicants: FieldValue.arrayRemove([UserService.currentUser?.userId as Any]),
                Constants.FirebaseDB.all_applicants: FieldValue.arrayRemove([UserService.currentUser?.userId as Any])
                ], forDocument: job_ref)
            
            let user_ref = Firestore.firestore().collection(Constants.FirebaseDB.user_ref)
                .document(UserService.currentUser!.userId)
            
            batch.updateData([
                Constants.FirebaseDB.jobs_applied: FieldValue.arrayRemove([self.job!.jobId])
                ], forDocument: user_ref)
        }
            
        else if (job?.accepted.contains(currentUserId))! {
            
            // remove from employment
            let job_ref = Firestore.firestore().collection(Constants.FirebaseDB.jobs_ref)
                .document(self.job!.jobId)
            
            batch.updateData([
                Constants.FirebaseDB.accepted: FieldValue.arrayRemove([UserService.currentUser?.userId as Any]),
                Constants.FirebaseDB.all_applicants: FieldValue.arrayRemove([UserService.currentUser?.userId as Any])
                ], forDocument: job_ref)
            
            let user_ref = Firestore.firestore().collection(Constants.FirebaseDB.user_ref)
                .document(UserService.currentUser!.userId)
            
            batch.updateData([
                Constants.FirebaseDB.jobs_accepted: FieldValue.arrayRemove([self.job!.jobId])
                ], forDocument: user_ref)
        }else {
            
            let job_ref = Firestore.firestore().collection(Constants.FirebaseDB.jobs_ref)
                .document(self.job!.jobId)
            
            batch.updateData([
                Constants.FirebaseDB.applicants: FieldValue.arrayUnion([UserService.currentUser?.userId as Any]),
                Constants.FirebaseDB.all_applicants: FieldValue.arrayUnion([UserService.currentUser?.userId as Any])
                ], forDocument: job_ref)
            
            let user_ref = Firestore.firestore().collection(Constants.FirebaseDB.user_ref)
                .document(UserService.currentUser!.userId)
            
            batch.updateData([
                Constants.FirebaseDB.jobs_applied: FieldValue.arrayUnion([self.job!.jobId])
                ], forDocument: user_ref)
        }
        
        batch.commit() { err in
            if let err = err {
                
                print("Error writing batch \(err)")
            } else {
                
            }
        }
    }
}

