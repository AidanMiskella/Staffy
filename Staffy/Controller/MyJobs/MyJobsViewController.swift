//
//  MyJobsViewController.swift
//  Staffy
//
//  Created by Aidan Miskella on 05/08/2019.
//  Copyright © 2019 Aidan Miskella. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

enum StatusCategory: String {
    
    case applied = "APPLIED"
    case accepted = "ACCEPTED"
    case in_progress = "IN-PROGRESS"
    case closed = "CLOSED"
}

class MyJobsViewController: UIViewController {

    private var jobs = [Job]()
    private var jobs_ref: CollectionReference!
    private var jobsListener: ListenerRegistration!
    
    private var currentJob: Job?
    private var selectedJob: Job?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet private weak var segmentControl: UISegmentedControl!
    
    private var selectedCategory = StatusCategory.applied.rawValue
    
    private var loginHandle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
        getJobCount()
        segmentControl.tintColor = .lightBlue
        segmentControl.addUnderlineForSelectedSegment()
        segmentControl.setFontSize(10)
        
        tableView.delegate = self
        tableView.dataSource = self
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if jobsListener != nil {
            
            jobsListener.remove()
        }
    }
    
    private func setup() {
        
        Utilities.setupNavigationStyle(navigationController!)
    }
    
    func getJobCount() {
        
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        let appliedArray = Firestore.firestore().collection(Constants.FirebaseDB.jobs_ref)
            .whereField(Constants.FirebaseDB.applicants, arrayContains: currentUserId)
            .whereField(Constants.FirebaseDB.status, isEqualTo: "open")
        appliedArray.getDocuments { (snapshot, error) in
            
            self.segmentControl.setTitle("APPLIED (\(snapshot!.count))", forSegmentAt: 0)
        }
        
        let acceptedArray = Firestore.firestore().collection(Constants.FirebaseDB.jobs_ref)
            .whereField(Constants.FirebaseDB.accepted, arrayContains: currentUserId)
            .whereField(Constants.FirebaseDB.status, isEqualTo: "open")
        acceptedArray.getDocuments { (snapshot, error) in
            
            self.segmentControl.setTitle("ACCEPTED (\(snapshot!.count))", forSegmentAt: 1)
        }
        
        let inprogressArray = Firestore.firestore().collection(Constants.FirebaseDB.jobs_ref)
            .whereField(Constants.FirebaseDB.accepted, arrayContains: currentUserId)
            .whereField(Constants.FirebaseDB.status, isEqualTo: "inProgress")
        inprogressArray.getDocuments { (snapshot, error) in
            
            self.segmentControl.setTitle("IN-PROGRESS (\(snapshot!.count))", forSegmentAt: 2)
        }
        
        let closedArray = Firestore.firestore().collection(Constants.FirebaseDB.jobs_ref)
            .whereField(Constants.FirebaseDB.accepted, arrayContains: currentUserId)
            .whereField(Constants.FirebaseDB.status, isEqualTo: "closed")
        closedArray.getDocuments { (snapshot, error) in
            
            self.segmentControl.setTitle("CLOSED (\(snapshot!.count))", forSegmentAt: 3)
        }
    }
    
    @IBAction func categoryChanged(_ sender: Any) {
        
        segmentControl.changeUnderlinePosition()
        
        if segmentControl.selectedSegmentIndex == 0 {
            
            selectedCategory = StatusCategory.applied.rawValue
        } else if segmentControl.selectedSegmentIndex == 1 {
            
            selectedCategory = StatusCategory.accepted.rawValue
        } else if segmentControl.selectedSegmentIndex == 2 {
            
            selectedCategory = StatusCategory.in_progress.rawValue
        } else {
            
            selectedCategory = StatusCategory.closed.rawValue
        }
        
        jobsListener.remove()
        setListener()
    }
    
    func setListener() {
        
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        if selectedCategory == StatusCategory.applied.rawValue {
            
            jobsListener = jobs_ref
                .whereField(Constants.FirebaseDB.applicants, arrayContains: currentUserId)
                .whereField(Constants.FirebaseDB.status, isEqualTo: "open")
                .order(by: Constants.FirebaseDB.posted_date, descending: true)
                .addSnapshotListener({ (snapshot, error) in
                    
                    if let error = error {
                        
                        debugPrint("Error fetching docs: \(error)")
                    } else {
                        
                        self.jobs.removeAll()
                        self.jobs = Job.parseData(snapshot: snapshot)
                        self.getJobCount()
                        self.tableView.reloadData()
                    }
                })
        } else if selectedCategory == StatusCategory.accepted.rawValue {
            
            jobsListener = jobs_ref
                .whereField(Constants.FirebaseDB.accepted, arrayContains: currentUserId)
                .whereField(Constants.FirebaseDB.status, isEqualTo: "open")
                .order(by: Constants.FirebaseDB.posted_date, descending: true)
                .addSnapshotListener({ (snapshot, error) in
                    
                    if let error = error {
                        
                        debugPrint("Error fetching docs: \(error)")
                    } else {
                        
                        self.jobs.removeAll()
                        self.jobs = Job.parseData(snapshot: snapshot)
                        self.getJobCount()
                        self.tableView.reloadData()
                    }
                })
        } else if selectedCategory == StatusCategory.in_progress.rawValue {
            
            jobsListener = jobs_ref
                .whereField(Constants.FirebaseDB.accepted, arrayContains: currentUserId)
                .whereField(Constants.FirebaseDB.status, isEqualTo: "inProgress")
                .order(by: Constants.FirebaseDB.posted_date, descending: true)
                .addSnapshotListener({ (snapshot, error) in
                    
                    if let error = error {
                        
                        debugPrint("Error fetching docs: \(error)")
                    } else {
                        
                        self.jobs.removeAll()
                        self.jobs = Job.parseData(snapshot: snapshot)
                        self.getJobCount()
                        self.tableView.reloadData()
                    }
                })
        } else {
            
            jobsListener = jobs_ref
                .whereField(Constants.FirebaseDB.accepted, arrayContains: currentUserId)
                .whereField(Constants.FirebaseDB.status, isEqualTo: "closed")
                .order(by: Constants.FirebaseDB.posted_date, descending: true)
                .addSnapshotListener({ (snapshot, error) in
                    
                    if let error = error {
                        
                        debugPrint("Error fetching docs: \(error)")
                    } else {
                        
                        self.jobs.removeAll()
                        self.jobs = Job.parseData(snapshot: snapshot)
                        self.getJobCount()
                        self.tableView.reloadData()
                    }
                })
        }
    }
}

extension MyJobsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let job = jobs[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobCell") as! JobTableViewCell
        
        cell.setCell(job: job)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedJob = jobs[indexPath.row]
        performSegue(withIdentifier: "goToJobDetails", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToJobDetails" {
            
            let vc = segue.destination as! JobViewController
            vc.job = selectedJob
        }
    }
}

