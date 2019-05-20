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
    var buttonView: UIView!
    
    @IBAction func expandButton(_ sender: Any) {
        buttonView = UIView()
        mainCellView.addSubview(buttonView)
        buttonView.frame = CGRect(x: 0, y: 0, width: mainCellView.frame.width, height: mainCellView.frame.height)
        buttonView.backgroundColor = .clear
//        buttonView.backgroundColor = .red
        
        let stack: UIStackView = UIStackView()
        buttonView.addSubview(stack)
        stack.frame = CGRect(x: 0, y: 0, width: buttonView.frame.width, height: buttonView.frame.height)
        stack.alignment = UIStackViewAlignment.fill
        stack.distribution = UIStackViewDistribution.fillEqually
        stack.backgroundColor = .red

        let replaceButton: UIButton = UIButton()
        replaceButton.setTitle("Replace", for: .normal)
        //replaceButton.backgroundColor = .clear
        stack.addArrangedSubview(replaceButton)
        
        let blur = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blur)
        blurEffectView.alpha = 0.8
        blurEffectView.frame = self.bounds
        blurEffectView.frame = self.bounds
        blurEffectView.isUserInteractionEnabled = false
        replaceButton.insertSubview(blurEffectView, at: 0)
        
        let shuffleButton: UIButton = UIButton()
        shuffleButton.setTitle("Shuffle", for: .normal)
        //shuffleButton.backgroundColor = .clear
        stack.addArrangedSubview(shuffleButton)
        
//        let blur2 = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.dark))
//        blur2.frame = self.bounds
//        blur2.isUserInteractionEnabled = false
//        shuffleButton.insertSubview(blur2, at: 0)
        
        let cancelButton: cellButton = cellButton()
        cancelButton.setTitle("Cancel", for: .normal)
        //cancelButton.backgroundColor = .clear
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        stack.addArrangedSubview(cancelButton)
        
//        let blur3 = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.dark))
//        blur3.frame = self.bounds
//        blur3.isUserInteractionEnabled = false
//        cancelButton.insertSubview(blur3, at: 0)
    }
    
    @objc func replace (sender: UIButton!) {
        
    }
    
    @objc func shuffle (sender: UIButton!) {
        
    }
    
    @objc func cancel (sender: UIButton!) {
        buttonView.removeFromSuperview()
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

class cellButton: UIButton {
    var subView: UIView?
}
