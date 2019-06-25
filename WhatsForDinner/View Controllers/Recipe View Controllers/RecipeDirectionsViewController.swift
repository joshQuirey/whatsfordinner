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
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var recipeDirections: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotificationHandling()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }

    @IBAction func done(_ sender: Any) {
        meal?.directions = recipeDirections.text
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recipeDirections.text = meal?.directions
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
        
        let convertedFrame = view.convert(keyboardRect, from: nil)
        let heightOffset = view.bounds.size.height - convertedFrame.origin.y
        let options = UIViewAnimationOptions(rawValue: UInt(curve!) << 16 | UIViewAnimationOptions.beginFromCurrentState.rawValue)
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue
        
        var pureHeightOffset:CGFloat = -heightOffset
        
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
