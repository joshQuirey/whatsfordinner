//
//  RecipeDirectionsViewController.swift
//  WhatsForDinner
//
//  Created by Josh Quirey on 8/25/18.
//  Copyright © 2018 jquirey. All rights reserved.
//

import UIKit

class RecipeDirectionsViewController: UIViewController, UITextViewDelegate {

    var meal: Meal?
    var activeTextView = UITextView()
    var directionsActive = false
    @IBOutlet weak var directionsTextView: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var recipeDirections: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotificationHandling()
    }


    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    private func setupNotificationHandling() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillShow(_:)),
                                       name: .UIKeyboardWillShow,
                                       object: nil)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillHide(_:)),
                                       name: .UIKeyboardWillHide,
                                       object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        updateBottomConstraint(notification, isShowing: true)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        updateBottomConstraint(notification, isShowing: false)
    }
    
    func updateBottomConstraint(_ notification: Notification, isShowing: Bool) {
        let userInfo = notification.userInfo!
        let keyboardRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let curve = (userInfo[UIKeyboardAnimationCurveUserInfoKey]! as AnyObject).uint32Value
        
        //let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let convertedFrame = view.convert(keyboardRect, from: nil)
        print(convertedFrame.origin.y)
        let heightOffset = view.bounds.size.height - convertedFrame.origin.y
        let options = UIViewAnimationOptions(rawValue: UInt(curve!) << 16 | UIViewAnimationOptions.beginFromCurrentState.rawValue)
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue
        
        var pureHeightOffset:CGFloat = -heightOffset
        print(pureHeightOffset)
        if isShowing {
            pureHeightOffset = pureHeightOffset + bottomConstraint.constant //+ view.safeAreaInsets.bottom
        } else {
            pureHeightOffset = -10
        }
        
        bottomConstraint.constant = pureHeightOffset
        
        UIView.animate(withDuration: duration!, delay: 0, options: options, animations: {
            self.view.layoutIfNeeded()
        }, completion: { bool in })
    }
}
