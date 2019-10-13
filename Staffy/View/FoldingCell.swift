//
//  FoldingCell.swift
//  Staffy
//
//  Created by Aidan Miskella on 07/10/2019.
//  Copyright © 2019 Aidan Miskella. All rights reserved.
//

import Foundation
import UIKit
import FoldingCell

class DemoCell: FoldingCell {
    
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
}
