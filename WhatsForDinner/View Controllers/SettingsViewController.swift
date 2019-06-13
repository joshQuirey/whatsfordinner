//
//  SettingsViewController.swift
//  WhatsForDinner
//
//  Created by Josh Quirey on 6/4/19.
//  Copyright © 2019 jquirey. All rights reserved.
//

import UIKit
import StoreKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch(section) {
            case 0:
                return 1
            case 1:
                return 2
            default:
                return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        
        switch(indexPath.section) {
        case 0:
            cell.textLabel!.text = "Tips and Tricks"
            break
        case 1:
            if (indexPath.row == 0) {
                cell.textLabel!.text = "Send Feedback"
            } else {
                cell.textLabel!.text = "Please Rate Spork Fed"
            }
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
            } else {
            }
            break
        case 1:
            if (indexPath.row == 0) {
                
            } else {
                SKStoreReviewController.requestReview()
            }
            break
        default:
            break
        }
    }
}
