//
//  EmployerFeedbackViewController.swift
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

class EmployerFeedbackViewController: UIViewController, SignaturePadDelegate {
    
    @IBOutlet weak var signaturePadView: SignaturePad!
    
    @IBOutlet weak var clearSignature: UIButton!
    
    var job: Job!
    var currentReport: Report!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupElements()
        connectOutlets()
        
        signaturePadView.delegate = self
    }
    
    func setupElements() {
        
        Utilities.styleFilledButton(button: clearSignature, font: .largeLoginButton, fontColor: .white, backgroundColor: .lightBlue, cornerRadius: 10.0)
    }
    
    func connectOutlets() {
        
        guard let signature = currentReport.signatureURL else { return }
        
        ImageService.downloadImage(withURL: signature) { (image) in
            
            self.signaturePadView.setSignature(_image: image!)
        }
        
        if currentReport.reportOpen == false {
            
            signaturePadView.isUserInteractionEnabled = false
            clearSignature.isEnabled = false
        }
    }
    
    func didStart() {
        
        
    }
    
    func didFinish() {
        
        
    }
    
    @IBAction func clearSignaturePressed(_ sender: Any) {
        
        signaturePadView.clear()
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        if signaturePadView.isSigned {
            
            let report_ref =  Firestore.firestore().collection(Constants.FirebaseDB.jobs_ref).document(self.job!.jobId).collection(Constants.FirebaseDB.reports_ref).document(self.currentReport.reportId)
            let storageRef = Storage.storage().reference().child("signatures").child(job.jobId).child(UserService.currentUser!.userId)
            
            if let uploadData = signaturePadView.getSignature()!.pngData() {
                
                storageRef.putData(uploadData, metadata: nil) { (metaData, error) in
                    
                    if let error = error {
                        
                        debugPrint("Error storing image: \(error.localizedDescription)")
                    } else {
                        
                        storageRef.downloadURL { (url, error) in
                            
                            guard let signatureURL = url else { return }
                            report_ref.updateData([Constants.FirebaseDB.signature_url: signatureURL.absoluteString], completion: { (error) in
                            })
                        }
                    }
                }
            }
            
            performSegue(withIdentifier: "goToEmployeeFeedback", sender: self)
        } else {
            
            // warning view
            let alertView = SCLAlertView(appearance: Constants.AlertView.appearance)
            
            alertView.addButton("Continue", backgroundColor: .lightBlue, textColor: .white) {
                
                alertView.dismiss(animated: true)
            }
            
            alertView.showWarning("Provide Signature", subTitle: "Please provide a signature by a manager or someone in a more senior position. This is needed to confirm the employees attendance and to successfully close the job.", animationStyle: .rightToLeft)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToEmployeeFeedback" {
            
            let vc = segue.destination as! EmployeeFeedbackViewController
            vc.job = job
            vc.currentReport = currentReport
        }
    }
}
