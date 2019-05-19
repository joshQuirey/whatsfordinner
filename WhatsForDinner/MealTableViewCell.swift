//
//  MealTableViewCell.swift
//  WhatsForDinner
//
//  Created by Josh Quirey on 4/16/19.
//  Copyright © 2019 jquirey. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {

    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var mealFrequency: UILabel!
    @IBOutlet weak var mealCategories: UITextField!
    @IBOutlet weak var mealImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame = newFrame
            frame.origin.y += 8
            frame.size.height -= 2 * 5
            super.frame = frame
        }
    }
}

class PlanTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var planDate: UILabel!
    @IBOutlet weak var planMonth: UILabel!
    @IBOutlet weak var planDay: UILabel!
    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var prep: UILabel!
    @IBOutlet weak var cook: UILabel!
    @IBOutlet weak var serve: UILabel!
    
    
    @IBOutlet weak var mainCellView: UIView!
    
    @IBAction func expandButton(_ sender: Any) {
        let view: UIView = UIView()
        mainCellView.addSubview(view)
        view.frame = CGRect(x: 0, y: 0, width: mainCellView.frame.width, height: mainCellView.frame.height)
        
        view.backgroundColor = .red
        
        let stack: UIStackView = UIStackView()
        view.addSubview(stack)
        stack.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        stack.backgroundColor = .black
        
        let refreshButton: UIButton = UIButton()
        refreshButton.setTitle("Refresh", for: .normal)
        refreshButton.backgroundColor = .blue
        stack.addSubview(refreshButton)
        
        let shuffleButton: UIButton = UIButton()
        shuffleButton.titleLabel?.text = "Shuffle"
        refreshButton.backgroundColor = .green
        stack.addSubview(shuffleButton)
        
        let cancelButton: UIButton = UIButton()
        cancelButton.titleLabel?.text = "Cancel"
        refreshButton.backgroundColor = .purple
        stack.addSubview(cancelButton)
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
//    override var frame: CGRect {
//        get {
//            return super.frame
//        }
//        set (newFrame) {
//            var frame = newFrame
//            frame.origin.y += 8
//            frame.size.height -= 2 * 5
//            super.frame = frame
//        }
//    }
}
