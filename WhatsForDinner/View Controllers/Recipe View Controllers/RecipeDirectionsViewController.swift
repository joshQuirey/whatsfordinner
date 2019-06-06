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
    
    @IBOutlet weak var recipeDirections: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        print("recipe directions - textview did begin editing")
       // directionsActive = true
        //scrollView.isScrollEnabled = true
//        var info:NSDictionary = notification.userInfo! as NSDictionary
//        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
//        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)

        //scrollView.contentInset = contentInsets
        //scrollView.scrollIndicatorInsets = contentInsets
        
//        var aRect: CGRect = parentView.frame
//        aRect.size.height -= keyboardSize!.height + 100
//        if let activeField = recipeIngredientViewController._ingredient.text {
//            if (!aRect.contains(segmentedParentView.frame.origin)) {
//                scrollView.scrollRectToVisible(segmentedParentView.frame, animated: true)
//            }
//        }
        
        
        
        parent!.view.frame.origin.y = -300
        
        //scrollView.setContentOffset(CGPoint(x: 0,y: 100), animated: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("recipe directions - textview did end editing")
        parent!.view.frame.origin.y = 0
        //directionsActive = false
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
