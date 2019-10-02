//
//  ProfileTableViewCell.swift
//  Staffy
//
//  Created by Aidan Miskella on 17/09/2019.
//  Copyright © 2019 Aidan Miskella. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var headingLabel: UILabel!
    
    @IBOutlet weak var dataLabel: UILabel!
    
    func setCell(profileData: ProfileCellData) {
        
        Utilities.styleLabel(label: headingLabel, font: .profileTableHeading, fontColor: .lightBlue)
        Utilities.styleLabel(label: dataLabel, font: .profileTableData, fontColor: .darkGray)

        headingLabel.text = profileData.title
        dataLabel.text = profileData.data
    }
}
