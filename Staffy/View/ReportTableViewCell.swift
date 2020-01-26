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
        
    @IBOutlet weak var clockingLabelDate: UILabel!
    
    @IBOutlet weak var clockingLabelTime: UILabel!
    
    var clockingStatus: String!
    var time: String!
    var date: String!
    
    func setCell(currentReport: Report, clocking: String) {
        
        Utilities.styleLabel(label: clockingLabelDate, font: .reportTableRow, fontColor: .black)
        
        clockingStatus = "\(clocking.components(separatedBy: " ")[0]) \(clocking.components(separatedBy: " ")[1])"
        time = "\(clocking.components(separatedBy: " ")[3])"
        date = "\(clocking.components(separatedBy: " ")[7]) \(clocking.components(separatedBy: " ")[8]) \(clocking.components(separatedBy: " ")[9])"
        
        clockingLabelDate.text = "\(date!)"
        clockingLabelTime.text = "\(clockingStatus!) @ \(time!)"
        
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
