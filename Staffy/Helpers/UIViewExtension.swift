//
//  UIViewExtension.swift
//  Staffy
//
//  Created by Aidan Miskella on 22/09/2019.
//  Copyright © 2019 Aidan Miskella. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func layerGradient() {
        
        let layer : CAGradientLayer = CAGradientLayer()
        layer.frame.size = self.frame.size
        layer.frame.origin = CGPoint(x: 0.0,y: 0.0)
        
        let colorTop =  UIColor(red: 149/255, green: 209/255, blue: 237/255, alpha: 1).cgColor
        let colorBottom = UIColor(red: 45/255, green: 171/255, blue: 235/255, alpha: 1).cgColor
        
        layer.colors = [colorTop,colorBottom]
        layer.locations = [0.0, 1.0]
        self.layer.insertSublayer(layer, at: 0)
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
