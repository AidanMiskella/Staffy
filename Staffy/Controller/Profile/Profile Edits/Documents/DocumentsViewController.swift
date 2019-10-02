//
//  DocumentsViewController.swift
//  Staffy
//
//  Created by Aidan Miskella on 29/09/2019.
//  Copyright © 2019 Aidan Miskella. All rights reserved.
//

import UIKit
import NADocumentPicker

class DocumentsViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupUI() {
        
        topView.layerGradient()
        
        Utilities.styleLabel(label: titleLabel, font: .editProfileTitle, fontColor: .white)
    }
    
    @IBAction func addDocumentsTapped(_ sender: UIBarButtonItem) {
        
        let urlPickedfuture = NADocumentPicker.show(from: UIView(), parentViewController: self)
        
        urlPickedfuture.onSuccess { url in
            
            print("URL: \(url)")
        }
    }
}

extension DocumentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
}
