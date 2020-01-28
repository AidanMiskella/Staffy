//
//  ReportViewController.swift
//  Staffy
//
//  Created by Aidan Miskella on 29/12/2019.
//  Copyright © 2019 Aidan Miskella. All rights reserved.
//

import UIKit
import SCLAlertView
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ReportViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var userEmailLabel: UILabel!
    
    @IBOutlet weak var userPhoneLabel: UILabel!
        
    @IBOutlet weak var statusImageView: UIImageView!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var currentTime: UILabel!
    
    @IBOutlet weak var clockingButton: UIButton!
    
    @IBOutlet weak var breakButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    private var timer = Timer()
    
    var job: Job!
    
    var currentReport: Report!
    var reports = [Report]()
    var clockingMessages = [String]()
    
    private var report_ref: CollectionReference!
    private var clockingsListener: ListenerRegistration!
    private var loginHandle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        connectOutlets()
        setupElements()
        getCurrentTime()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        report_ref = Firestore.firestore().collection(Constants.FirebaseDB.jobs_ref).document(job!.jobId).collection(Constants.FirebaseDB.reports_ref)
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2.0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if clockingsListener != nil {
            
            clockingsListener.remove()
        }
    }
    
    func setupElements() {
        
        Utilities.styleLabel(label: currentTime, font: .largeTime, fontColor: .black)
        Utilities.styleLabel(label: statusLabel, font: .reportClockingStatus, fontColor: .black)
        Utilities.styleLabel(label: nameLabel, font: .reportNameTitle, fontColor: .black)
        Utilities.styleFilledButton(button: clockingButton, font: .largeLoginButton, fontColor: .white, backgroundColor: .lightBlue, cornerRadius: 10.0)
        Utilities.styleFilledButton(button: breakButton, font: .largeLoginButton, fontColor: .white, backgroundColor: .lightBlue, cornerRadius: 10.0)
    }
    
    func connectOutlets() {
        
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.masksToBounds = false
        avatarImageView.layer.borderColor = UIColor.gray.cgColor
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        avatarImageView.clipsToBounds = true
        
        statusImageView.layer.borderWidth = 1
        statusImageView.layer.masksToBounds = false
        statusImageView.layer.borderColor = UIColor.gray.cgColor
        statusImageView.layer.cornerRadius = statusImageView.frame.height / 2
        statusImageView.clipsToBounds = true
        
        UserService.observeUserProfile(UserService.currentUser!.userId, completion: { (user) in
            
            self.nameLabel.text = "\(user!.firstName) \(user!.lastName)"
            
            ImageService.getImage(withURL: user!.avatarURL!) { (image) in
                
                self.avatarImageView.image = image
            }
        })
    }
    
    func setListener() {
        
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        clockingsListener = report_ref
            .whereField(Constants.FirebaseDB.user_id, isEqualTo: currentUserId)
            .addSnapshotListener({ (snapshot, error) in
                
                if let error = error {
                    
                    debugPrint("Error fetching docs: \(error)")
                } else {
                    
                    self.reports.removeAll()
                    self.reports = Report.parseData(snapshot: snapshot)
                    self.currentReport = self.reports[0]
                    self.clockingMessages = self.currentReport.clockingMessages.reversed()
                    self.clockingButtonTitle()
                    self.tableView.reloadData()
                }
            })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "goToEmployerFeedback" {

            let vc = segue.destination as! EmployerFeedbackViewController
            vc.job = job
            vc.currentReport = currentReport
        }
    }
    
    @IBAction func nextButton(_ sender: Any) {
        
        if (Calendar.current.isDateInToday(self.job!.endDate.dateValue()) && currentReport.reportStatus == Constants.Report.clockedOut) || currentReport.reportOpen == false {
            
            performSegue(withIdentifier: "goToEmployerFeedback", sender: self)
        } else {
            
            let alertView = SCLAlertView(appearance: Constants.AlertView.appearance)
            
            alertView.addButton("Continue", backgroundColor: .lightBlue, textColor: .white) {
                
                alertView.dismiss(animated: true)
            }
            
            alertView.showError("Job not finished", subTitle: "This job ends on the \(Utilities.dateFormatterFullMonth(self.job!.endDate.dateValue())). To continue, make sure you are clocked out from the job and the job ends on the specified end date.", animationStyle: .rightToLeft)
        }
    }
    
    func clockingButtonTitle() {
        
        if currentReport.reportOpen == true {
        
            if currentReport.reportStatus == Constants.Report.notClockedIn {
                
                clockingButton.setTitle("Clock in", for: .normal)
                statusLabel.text = Constants.Report.notClockedIn
                breakButton.backgroundColor = .gray
                breakButton.isEnabled = false
                Utilities.styleImage(imageView: statusImageView, image: "dot", imageColor: .orange)
            }
            
           else if currentReport.reportStatus == Constants.Report.clockedIn {
                
                clockingButton.setTitle("Clock out", for: .normal)
                breakButton.setTitle("Start break", for: .normal)
                statusLabel.text = Constants.Report.clockedIn
                breakButton.backgroundColor = .lightBlue
                breakButton.isEnabled = true
                clockingButton.backgroundColor = .lightBlue
                clockingButton.isEnabled = true
                Utilities.styleImage(imageView: statusImageView, image: "dot", imageColor: .green)
            }
                
            else if currentReport.reportStatus == Constants.Report.clockedOut {
                
                clockingButton.setTitle("Clock in", for: .normal)
                statusLabel.text = Constants.Report.clockedOut
                breakButton.backgroundColor = .gray
                breakButton.isEnabled = false
                Utilities.styleImage(imageView: statusImageView, image: "dot", imageColor: .red)
            }
            
            else if currentReport.reportStatus == Constants.Report.onBreak {
                
                breakButton.setTitle("End break", for: .normal)
                statusLabel.text = Constants.Report.onBreak
                clockingButton.backgroundColor = .gray
                clockingButton.isEnabled = false
                Utilities.styleImage(imageView: statusImageView, image: "dot", imageColor: .yellow)
            } else {
                
                breakButton.setTitle("Start break", for: .normal)
                statusLabel.text = Constants.Report.clockedIn
                Utilities.styleImage(imageView: statusImageView, image: "dot", imageColor: .green)
            }
        } else {
            
            breakButton.backgroundColor = .gray
            breakButton.isEnabled = false
            clockingButton.backgroundColor = .gray
            clockingButton.isEnabled = false
            statusLabel.text = Constants.Report.reportComlpete
            Utilities.styleImage(imageView: statusImageView, image: "dot", imageColor: .lightBlue)
        }
    }
    
    private func getCurrentTime() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.currentTimer), userInfo: nil, repeats: true)
    }
    
    @objc func currentTimer() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        currentTime.text = formatter.string(from: Date())
    }
    
    @IBAction func clockingButtonPressed(_ sender: Any) {
        
        let formatter = DateFormatter()
        let formatter2 = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter2.dateFormat = "dd MMMM YYYY"
        
        let batch = Firestore.firestore().batch()
        
        let report_ref = Firestore.firestore().collection(Constants.FirebaseDB.jobs_ref).document(job!.jobId).collection(Constants.FirebaseDB.reports_ref).document(currentReport.reportId)
        
        if currentReport.reportStatus == "Clocked out" || currentReport.reportStatus == "Not clocked in" {
            
            batch.updateData([
                Constants.FirebaseDB.clocking_messages: FieldValue.arrayUnion(["Clocked in at \(formatter.string(from: Date())) on the \(formatter2.string(from: Date()))"]), Constants.FirebaseDB.report_status: Constants.Report.clockedIn
                ], forDocument: report_ref)
            
        } else {
            
            batch.updateData([
                Constants.FirebaseDB.clocking_messages: FieldValue.arrayUnion(["Clocked out at \(formatter.string(from: Date())) on the \(formatter2.string(from: Date()))"]), Constants.FirebaseDB.report_status: Constants.Report.clockedOut
                ], forDocument: report_ref)
        }
        
        clockingButtonTitle()
    
        batch.commit() { err in
            
            if let err = err {
        
                print("Error writing batch \(err)")
            } else {
        
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func breakButtonPressed(_ sender: Any) {
        
        let formatter = DateFormatter()
        let formatter2 = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter2.dateFormat = "dd MMMM YYYY"
        
        let batch = Firestore.firestore().batch()
        
        let report_ref = Firestore.firestore().collection(Constants.FirebaseDB.jobs_ref).document(job!.jobId).collection(Constants.FirebaseDB.reports_ref).document(currentReport.reportId)
        
        if currentReport.reportStatus == "Clocked in" {
            
            batch.updateData([
                Constants.FirebaseDB.clocking_messages: FieldValue.arrayUnion(["Started break at \(formatter.string(from: Date())) on the \(formatter2.string(from: Date()))"]), Constants.FirebaseDB.report_status: Constants.Report.onBreak
                ], forDocument: report_ref)
            
        } else {
            
            batch.updateData([
                Constants.FirebaseDB.clocking_messages: FieldValue.arrayUnion(["Ended break at \(formatter.string(from: Date())) on the \(formatter2.string(from: Date()))"]), Constants.FirebaseDB.report_status: Constants.Report.clockedIn
                ], forDocument: report_ref)
        }
        
        clockingButtonTitle()
        
        batch.commit() { err in
            
            if let err = err {
                
                print("Error writing batch \(err)")
            } else {
                
                self.tableView.reloadData()
            }
        }
    }
}

extension ReportViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return clockingMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let clocking = clockingMessages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportCell") as! ReportTableViewCell

        cell.setCell(currentReport: currentReport, clocking: clocking)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}
