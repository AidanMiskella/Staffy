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
    var currentJob = [Job]()
    
    private var jobs_ref: CollectionReference!
    private var jobsListener: ListenerRegistration!
    private var loginHandle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupElements()
        connectOutlets()
        
        jobs_ref = Firestore.firestore().collection(Constants.FirebaseDB.jobs_ref)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loginHandle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            
            if user != nil {
                
                UserService.observeUserProfile(user!.uid, completion: { (user) in
                    
                    UserService.currentUser = user
                    self.setListener()
                })
            } else {
                
                UserService.currentCompany = nil
                
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.loginViewController)
                self.present(loginVC, animated: true, completion: nil)
            }
        })
    }
    
    func setListener() {
        
        jobsListener = jobs_ref
            .whereField(Constants.FirebaseDB.job_id, isEqualTo: job!.jobId)
            .addSnapshotListener { (snapshot, error) in
                if let error = error {
                    
                    debugPrint("Error fetching docs: \(error)")
                } else {
                    
                    self.currentJob = Job.parseData(snapshot: snapshot)
                    self.job = self.currentJob[0]
                    self.getButtonTitles()
                }
        }
    }
    
    func getButtonTitles() {
        
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
        
        Utilities.styleLabel(label: companyNameLabel, font: .jobViewTitle, fontColor: .black)
        Utilities.styleLabel(label: jobTitleLabel, font: .editProfileText, fontColor: .black)
        Utilities.styleLabel(label: jobCompanyNameLabel, font: .editProfileText, fontColor: .black)
        Utilities.styleLabel(label: jobLocationLabel, font: .editProfileText, fontColor: .black)
        Utilities.styleLabel(label: experienceLabel, font: .editProfileText, fontColor: .black)
        Utilities.styleLabel(label: positionsLabel, font: .editProfileText, fontColor: .black)
        Utilities.styleLabel(label: datesLabel, font: .editProfileText, fontColor: .black)
        Utilities.styleLabel(label: timesLabel, font: .editProfileText, fontColor: .black)
        Utilities.styleLabel(label: payLabel, font: .editProfileText, fontColor: .black)
        Utilities.styleLabel(label: companyEmailLabel, font: .jobViewContactText, fontColor: .black)
        Utilities.styleLabel(label: companyPhoneLabel, font: .jobViewContactText, fontColor: .black)
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
            
            self.companyRating.rating = (company!.reviewRating! / Double(company!.jobsCompleted))
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
        positionsLabel.text = "\(positions) position(s)"
        datesLabel.text = "\(Utilities.dateFormatterFullMonth((job?.startDate.dateValue())!)) - \(Utilities.dateFormatterFullMonth((job?.endDate.dateValue())!))"
        timesLabel.text = "\(startTime) - \(endTime)"
        payLabel.text = String(format: "€%.1f0 per hour", pay)
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
            
            performSegue(withIdentifier: "viewreport", sender: self)
        }
            
        else if (job?.applicants.contains(currentUserId))! {
            
            // remove application
            let job_ref = Firestore.firestore().collection(Constants.FirebaseDB.jobs_ref)
                .document(self.job!.jobId)
            
            batch.updateData([
                Constants.FirebaseDB.applicants: FieldValue.arrayRemove([UserService.currentUser?.userId as Any])
                ], forDocument: job_ref)
            
            let user_ref = Firestore.firestore().collection(Constants.FirebaseDB.user_ref)
                .document(UserService.currentUser!.userId)
            
            batch.updateData([
                Constants.FirebaseDB.jobs_applied: FieldValue.arrayRemove([self.job!.jobId]),
                Constants.FirebaseDB.all_applicants: FieldValue.arrayRemove([self.job!.jobId])
                ], forDocument: user_ref)
            
            manageButton.setTitle("Apply", for: .normal)
        }
            
        else if (job?.accepted.contains(currentUserId))! {
            
            // remove from employment
            let job_ref = Firestore.firestore().collection(Constants.FirebaseDB.jobs_ref)
                .document(self.job!.jobId)
            
            batch.updateData([
                Constants.FirebaseDB.accepted: FieldValue.arrayRemove([UserService.currentUser?.userId as Any])
                ], forDocument: job_ref)
            
            let user_ref = Firestore.firestore().collection(Constants.FirebaseDB.user_ref)
                .document(UserService.currentUser!.userId)
            
            batch.updateData([
                Constants.FirebaseDB.jobs_accepted: FieldValue.arrayRemove([self.job!.jobId]),
                Constants.FirebaseDB.all_applicants: FieldValue.arrayRemove([self.job!.jobId])
                ], forDocument: user_ref)
            
            manageButton.setTitle("Apply", for: .normal)
        }else {
            
            let job_ref = Firestore.firestore().collection(Constants.FirebaseDB.jobs_ref)
                .document(self.job!.jobId)
            
            batch.updateData([
                Constants.FirebaseDB.applicants: FieldValue.arrayUnion([UserService.currentUser?.userId as Any])
                ], forDocument: job_ref)
            
            let user_ref = Firestore.firestore().collection(Constants.FirebaseDB.user_ref)
                .document(UserService.currentUser!.userId)
            
            batch.updateData([
                Constants.FirebaseDB.jobs_applied: FieldValue.arrayUnion([self.job!.jobId]),
                Constants.FirebaseDB.all_applicants: FieldValue.arrayUnion([self.job!.jobId])
                ], forDocument: user_ref)
            
            manageButton.setTitle("Remove Application", for: .normal)
        }
        
        batch.commit() { err in
            if let err = err {
                
                print("Error writing batch \(err)")
            } else {
                
            }
        }
    }
}

