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

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
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
