//
//  ProfileViewController.swift
//  Staffy
//
//  Created by Aidan Miskella on 05/08/2019.
//  Copyright © 2019 Aidan Miskella. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import Cosmos
import ImagePicker
import GrowingTextView

class ProfileViewController: UIViewController, ImagePickerDelegate {
    
    @IBOutlet weak var topProfileImageView: UIView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var middleRatingView: UIView!
    
    @IBOutlet weak var ratingView: CosmosView!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var bioLabel: GrowingTextView!
    
    @IBOutlet weak var jobAlertView: UIView!
    
    @IBOutlet weak var jobAlertImage: UIImageView!
    
    @IBOutlet weak var jobAlertLabel: UILabel!
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataCells: [ProfileCellData] = []
    private var jobs = [Job]()
    private var jobs_ref: CollectionReference!
    private var jobsListener: ListenerRegistration!
    private var jobsCollectionRef: CollectionReference!
    private var loginHandle: AuthStateDidChangeListenerHandle?
    
    override func viewWillAppear(_ animated: Bool) {
        
        loginHandle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            
            if user != nil {
                
                UserService.observeUserProfile(user!.uid, completion: { (user) in
                    
                    UserService.currentUser = user
                    self.dataCells = self.createArray()
                    self.setUpProfile()
                    self.tableView.reloadData()
                    self.setListener()
                })
            } else {
                
                UserService.currentUser  = nil
                
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.loginViewController)
                self.present(loginVC, animated: true, completion: nil)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
        setUpProfile()
        topProfileImageView.backgroundColor = .lightBlue
        dataCells = createArray()

        tableView.delegate = self
        tableView.dataSource = self

        jobsCollectionRef = Firestore.firestore().collection(Constants.FirebaseDB.jobs_ref)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        profileImage.layer.cornerRadius = profileImage.frame.height / 2.0
    }
    
    func setUpElements() {

        Utilities.styleLabel(label: ratingLabel, font: .subTitle, fontColor: .gray)
        Utilities.styleTextView(textView: bioLabel, font: .editProfileText, fontColor: .darkGray)
        Utilities.styleLabel(label: jobAlertLabel, font: .subTitle, fontColor: .white)
        
        middleRatingView.roundCorners([.topRight, .topLeft], radius: 30.0)
        
        bioLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bioTapped)))
        bioLabel.sizeToFit()
        
        jobAlertView.backgroundColor = .lightBlue
        jobAlertImage.tintColor = .white
        
        profileImage.layer.borderWidth = 4
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.gray.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileImageTapped)))
        
        Utilities.setupNavigationStyleNoBorder(navigationController!)
    }
    
    func setUpProfile() {
        
        guard let currentUser = UserService.currentUser else { return }
        
        ImageService.getImage(withURL: currentUser.avatarURL!) { (image) in
            
            self.profileImage.image = image
        }
        
        ratingView.rating = getStarRating()
        ratingLabel.text = getRatingText()
        bioLabel.text = currentUser.bio
    }
    
    func getStarRating() -> Double {
        
        if UserService.currentUser?.reviewRating == 0 {
            
            return 0
        } else {
            
            return (UserService.currentUser!.reviewRating! / Double(UserService.currentUser!.jobsCompleted!))
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if jobsListener != nil {
            
            jobsListener.remove()
        }
    }
    
    func setListener() {
        
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        jobsListener = jobsCollectionRef
            .whereField(Constants.FirebaseDB.accepted, arrayContains: currentUserId)
            .whereField(Constants.FirebaseDB.status, isEqualTo: "open")
            .order(by: Constants.FirebaseDB.start_date, descending: false)
            .addSnapshotListener({ (snapshot, error) in
                
                if let error = error {
                    
                    debugPrint("Error fetching docs: \(error)")
                } else {
                    
                    self.jobs.removeAll()
                    self.jobs = Job.parseData(snapshot: snapshot)
                    self.getJobs()
                }
            })
    }
    
    func getJobs() {
        
        if jobs.count == 0 {
            
            jobAlertLabel.text = "You have no upcoming jobs, you can search for a job in the Home tab"
        } else {
            
            jobAlertLabel.text = "You have \(jobs.count) upcoming jobs, starting on the \(Utilities.dateFormatterFullMonth(jobs[0].startDate.dateValue())) at \(jobs[0].startTime)"
        }
    }
    
    func getRatingText() -> String {
    
        if UserService.currentUser?.reviewRating == 0 {
            
            return "No reviews yet"
        } else {
            
            let rating = (UserService.currentUser!.reviewRating! / Double(UserService.currentUser!.jobsCompleted!))
            return String(format: "%.1f of 5 Star Rating", rating)
        }
    }
    
    @objc private func profileImageTapped(_ recognizer: UITapGestureRecognizer) {
        
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc private func bioTapped(_ recognizer: UITapGestureRecognizer) {
        
        self.performSegue(withIdentifier: "Bio", sender: self)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        imagePicker.dismiss(animated: true)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        // Get the users avatarURL
        let ref = Firestore.firestore().collection(Constants.FirebaseDB.user_ref)
            .document(Auth.auth().currentUser!.uid)
        let storageRef = Storage.storage().reference().child("avatars").child(Auth.auth().currentUser!.uid)
        
        if let uploadData = images[0].jpegData(compressionQuality: 0.5) {
            
            storageRef.putData(uploadData, metadata: nil) { (metaData, error) in
                
                if let error = error {
                    
                    debugPrint("Error storing image: \(error.localizedDescription)")
                } else {
                    
                    storageRef.downloadURL { (url, error) in
                        
                        guard let avatarURL = url else { return }
                        ref.updateData(["avatarURL": avatarURL.absoluteString], completion: { (error) in
                            
                            self.profileImage.image = images[0]
                        })
                    }
                }
            }
        }
        
        imagePicker.dismiss(animated: true)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        
        imagePicker.dismiss(animated: true)
    }
    
    func setGradientBackground() {
        
        let colorTop =  UIColor(red: 149/255, green: 209/255, blue: 237/255, alpha: 1).cgColor
        let colorBottom = UIColor(red: 45/255, green: 171/255, blue: 235/255, alpha: 1).cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = topProfileImageView.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func createArray() -> [ProfileCellData] {
        
        var tempCells: [ProfileCellData] = []
        guard let currentUser = UserService.currentUser else { return tempCells }
        
        let nameCell = ProfileCellData(title: "Name", data: "\(currentUser.firstName) \(currentUser.lastName)")
        let emailCell = ProfileCellData(title: "Email", data: (Auth.auth().currentUser?.email)!)
        let dateOfBirthCell = ProfileCellData(title: "Date of Birth", data: currentUser.dateOfBirth!)
        let genderCell = ProfileCellData(title: "Gender", data: currentUser.gender!)
        let mobileCell = ProfileCellData(title: "Mobile", data: currentUser.mobile!)
        let addressCell = ProfileCellData(title: "Address", data: currentUser.address!)
        let documentsCell = ProfileCellData(title: "Documents", data: "\(currentUser.documents!.count) Documents")
        let passwordCell = ProfileCellData(title: "Password", data: "*********")
        
        tempCells.append(nameCell)
        tempCells.append(emailCell)
        tempCells.append(dateOfBirthCell)
        tempCells.append(genderCell)
        tempCells.append(mobileCell)
        tempCells.append(addressCell)
        tempCells.append(documentsCell)
        tempCells.append(passwordCell)
        
        return tempCells
    }
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        
        do {
            
            try Auth.auth().signOut()
        } catch let signoutError as NSError {
            
            debugPrint("Error signing out: \(signoutError)")
        }
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return dataCells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let profileData = dataCells[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileTableViewCell

        cell.setCell(profileData: profileData)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.performSegue(withIdentifier: dataCells[indexPath.row].title, sender: self)
    }
}

