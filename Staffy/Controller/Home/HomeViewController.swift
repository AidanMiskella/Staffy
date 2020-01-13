//
//  HomeViewController.swift
//  Staffy
//
//  Created by Aidan Miskella on 04/08/2019.
//  Copyright © 2019 Aidan Miskella. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class HomeViewController: UIViewController {
    
    private var jobs = [Job]()
    private var jobs_ref: CollectionReference!
    private var jobsListener: ListenerRegistration!
    
    private var currentJob: Job?
    private var selectedJob: Job?
    
    @IBOutlet weak var tableView: UITableView!
    
    private var loginHandle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
        
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
    
    func setListener() {
        
        jobsListener = jobs_ref
            .whereField(Constants.FirebaseDB.status, isEqualTo: "open")
            .order(by: Constants.FirebaseDB.posted_date, descending: true)
            .addSnapshotListener { (snapshot, error) in
                if let error = error {
                    
                    debugPrint("Error fetching docs: \(error)")
                } else {
                    
                    self.jobs.removeAll()
                    self.jobs = Job.parseData(snapshot: snapshot)
                    self.tableView.reloadData()
                }
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
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
