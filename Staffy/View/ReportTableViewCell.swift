//
//  ReportTableViewCell.swift
//  Staffy
//
//  Created by Aidan Miskella on 04/01/2020.
//  Copyright © 2020 Aidan Miskella. All rights reserved.
//

import UIKit
import Cosmos
import FirebaseAuth

class ReportTableViewCell: UITableViewCell {
    
    @IBOutlet weak var clockingSymbolImageView: UIImageView!
    
    @IBOutlet weak var clockingLabel: UILabel!
    
    func setCell(currentReport: Report, clocking: String) {
        
        Utilities.styleLabel(label: clockingLabel, font: .reportTableRow, fontColor: .black)
        
        clockingLabel.text = clocking
        
        if clocking.contains("Clocked in") {
            
            Utilities.styleImage(imageView: clockingSymbolImageView, image: "clock", imageColor: .green)
        } else if clocking.contains("Started break") {
            
            Utilities.styleImage(imageView: clockingSymbolImageView, image: "clock", imageColor: .yellow)
        } else if clocking.contains("Ended break") {
            
            Utilities.styleImage(imageView: clockingSymbolImageView, image: "clock", imageColor: .green)
        } else {
            
            Utilities.styleImage(imageView: clockingSymbolImageView, image: "clock", imageColor: .red)
        }
    }
}
