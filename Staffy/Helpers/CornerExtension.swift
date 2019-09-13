//
//  CornerExtension.swift
//  Staffy
//
//  Created by Aidan Miskella on 10/09/2019.
//  Copyright © 2019 Aidan Miskella. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}
