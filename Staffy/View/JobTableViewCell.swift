//
//  JobTableViewCell.swift
//  Staffy
//
//  Created by Aidan Miskella on 24/11/2019.
//  Copyright © 2019 Aidan Miskella. All rights reserved.
//

import UIKit
import Cosmos
import FirebaseAuth

class JobTableViewCell: UITableViewCell {
    
    @IBOutlet weak var companyImageView: UIImageView!
    
    @IBOutlet weak var companyStarRating: CosmosView!
    
    @IBOutlet weak var jobTitleLabel: UILabel!
    
    @IBOutlet weak var jobCompanyNameLabel: UILabel!
    
    @IBOutlet weak var jobLocationLabel: UILabel!
    
    @IBOutlet weak var jobPostedTimeLabel: UILabel!
    
    func setCell(job: Job) {
        
        Utilities.styleLabel(label: jobTitleLabel, font: .jobCellTitle, fontColor: .black)
        Utilities.styleLabel(label: jobCompanyNameLabel, font: .jobCellInfo, fontColor: .black)
        Utilities.styleLabel(label: jobLocationLabel, font: .jobCellInfo, fontColor: .black)
        Utilities.styleLabel(label: jobPostedTimeLabel, font: .jobCellPoseted, fontColor: .black)
        
        companyStarRating.isUserInteractionEnabled = false
        
        companyImageView.layer.borderWidth = 1
        companyImageView.layer.masksToBounds = false
        companyImageView.layer.borderColor = UIColor.gray.cgColor
        companyImageView.layer.cornerRadius = companyImageView.frame.height / 2
        companyImageView.clipsToBounds = true
        
        UserService.observeCompanyProfile(job.companyId) { (company) in
            
            ImageService.getImage(withURL: company!.avatarURL!) { (image) in
                
                self.companyImageView.image = image
            }
            
            self.companyStarRating.rating = (company!.reviewRating! / Double(company!.jobsCompleted))
            self.jobTitleLabel.text = job.title
            self.jobCompanyNameLabel.text = job.jobCompanyName
            self.jobLocationLabel.text = job.address
            self.jobPostedTimeLabel.text = Utilities.timeAgoSinceDate(job.postedDate.dateValue(), currentDate: Date(), numericDates: true)
        }
    }
}


