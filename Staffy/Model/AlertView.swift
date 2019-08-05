//
//  AlertView.swift
//  Staffy
//
//  Created by Aidan Miskella on 03/08/2019.
//  Copyright © 2019 Aidan Miskella. All rights reserved.
//

import Foundation
import UIKit

protocol AlertViewDelegate {
    
    func didClickButton()
}

class AlertView: UIView {
    
    @IBOutlet var parentView: UIView!
    
    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var message: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    var delegate: AlertViewDelegate!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        Bundle.main.loadNibNamed("AlertView", owner: self, options: nil)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    func commonInit() {
        
        Utilities.styleFilledButton(button, .largeLoginButton, .white, .lightBlue, 20.0)
        Utilities.styleLabel(title, .largeTitle, .black)
        Utilities.styleLabel(message, .subTitle, .black)
        
        image.layer.cornerRadius = 45
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.borderWidth = 3
        
        alertView.layer.cornerRadius = 8
        
        parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        parentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func showAlert(title :String, message: String, image: UIImageView, buttonText: String) {
        
        self.title.text = title
        self.message.text = message
        self.image.image = UIImage(named: "tick")
        self.button.setTitle(buttonText, for: .normal)
        
        UIApplication.shared.keyWindow?.addSubview(parentView)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        delegate.didClickButton()
    }
}
