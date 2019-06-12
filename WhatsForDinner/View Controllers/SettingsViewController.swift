//
//  SettingsViewController.swift
//  WhatsForDinner
//
//  Created by Josh Quirey on 6/4/19.
//  Copyright © 2019 jquirey. All rights reserved.
//

import UIKit

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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch(section) {
            case 0:
                return 1
            case 1:
                return 2
            case 2:
                return 2
            default:
                return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! UITableViewCell
        
        switch(indexPath.section) {
        case 0:
            cell.textLabel!.text = "Placeholder"
            break
        case 1:
            if (indexPath.row == 1) {
                cell.textLabel!.text = "Tips and Tricks"
            } else {
                cell.textLabel!.text = "About Spork Fed"
            }
            break
        case 2:
            if (indexPath.row == 1) {
                cell.textLabel!.text = "Contact Us"
            } else {
                cell.textLabel!.text = "Rate Us"
            }
            break
        default:
            break
        }
        
        return cell
    }
}
