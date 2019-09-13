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
import StarryStars
import ImagePicker

class ProfileViewController: UIViewController, ImagePickerDelegate {
    
    @IBOutlet weak var topProfileImageView: UIView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var firstNameLabel: UILabel!
    
    @IBOutlet weak var middleRatingView: UIView!
    
    @IBOutlet weak var ratingView: RatingView!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var editProfileButton: UIButton!
    
    @IBOutlet weak var jobAlertView: UIView!
    
    @IBOutlet weak var jobAlertLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        
        setUpProfile()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements() {
     
        Utilities.styleFilledButton(button: editProfileButton, font: .largeLoginButton, fontColor: .white, backgroundColor: .lightBlue, cornerRadius: 10.0)
        
        middleRatingView.roundCorners([.topLeft, .topRight], radius: 30)
        
        profileImage.layer.borderWidth = 4
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileImageTapped)))
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    func setUpProfile() {
        
        let ref = Firestore.firestore().collection(Constants.FirebaseDB.user_ref)
            .document(Auth.auth().currentUser!.uid)

        ref.getDocument { (snapshot, err) in
            if let data = snapshot?.data() {
                
                self.firstNameLabel.text = "\(data[Constants.FirebaseDB.first_name]!) \(data[Constants.FirebaseDB.last_name]!)"
                self.ratingView.rating = data[Constants.FirebaseDB.reviewRating]! as! Float
                self.ratingLabel.text = self.getRatingText(rating: data[Constants.FirebaseDB.reviewRating]! as! Float)
                self.bioLabel.text = "\(data[Constants.FirebaseDB.bio]!)"
            } else {
                
                print("Couldn't find the document")
            }
        }
    }
    
    func getRatingText(rating: Float) -> String {
    
        switch rating {
        
        case 0:
            return "\(Constants.Profile.no_rating)"
        case 1:
            return "1 \(Constants.Profile.rating)"
        case 2:
            return "2 \(Constants.Profile.rating)"
        case 3:
            return "3 \(Constants.Profile.rating)"
        case 4:
            return "4 \(Constants.Profile.rating)"
        case 5:
            return "5 \(Constants.Profile.rating)"
        default:
            return "\(Constants.Profile.ratingError)"
        }
    }
    
    @objc private func profileImageTapped(_ recognizer: UITapGestureRecognizer) {
        
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 5
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        
        
    }
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        
        do {
            
            try Auth.auth().signOut()
        } catch let signoutError as NSError {
            
            debugPrint("Error signing out: \(signoutError)")
        }
    }
}
