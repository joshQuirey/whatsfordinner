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
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        parent!.view.frame.origin.y = -300
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        parent!.view.frame.origin.y = 0
    }
}
