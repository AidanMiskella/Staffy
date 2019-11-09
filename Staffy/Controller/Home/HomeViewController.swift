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
import FoldingCell

class HomeViewController: UIViewController {
    
    enum Const {
        
        static let closeCellHeight: CGFloat = 150
        static let openCellHeight: CGFloat = 600
        static let rowsCount = 10
    }
    
    var cellHeights: [CGFloat] = []
    
    private var jobs = [Job]()
    private var jobs_ref: CollectionReference!
    private var jobsListener: ListenerRegistration!
    
    private var currentJob: Job?
    
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
        
        cellHeights = Array(repeating: Const.closeCellHeight, count: Const.rowsCount)
        tableView.estimatedRowHeight = Const.closeCellHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor(displayP3Red: 54/255, green: 76/255, blue: 112/255, alpha: 0.1)
        
        Utilities.setupNavigationStyle(navigationController!)
    }
    
    func setListener() {
        
        jobsListener = jobs_ref
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
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return jobs.count
    }
    
    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as DemoCell = cell else {
            return
        }
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == Const.closeCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! DemoCell
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        cell.configureCell(job: jobs[indexPath.row])
        return cell
    }
    
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == Const.closeCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = Const.openCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = Const.closeCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
            
            if cell.frame.maxY > tableView.frame.maxY {
                tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
            }
        }, completion: nil)
    }
}
