//
//  RecipeViewController.swift
//  WhatsForDinner
//
//  Created by Josh Quirey on 8/7/18.
//  Copyright © 2018 jquirey. All rights reserved.
//

import UIKit
import CoreData

class RecipeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /////////////////////////////
    //Properties
    /////////////////////////////
    let categoryData = [String](arrayLiteral: "Italian", "Mexican", "Greek")
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var category: UITextField!
    @IBOutlet weak var serves: UITextField!
    @IBOutlet weak var prepTime: UITextField!
    @IBOutlet weak var cookTime: UITextField!
    
    //let picker = UIImagePickerController()
    let pickCategory = UIPickerView()
    let pickTime = UIDatePicker()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var segmentedParentView: UIView!
    
    var managedObjectContext: NSManagedObjectContext?
  
    
    /////////////////////////////
    //View Life Cycle
    /////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        //picker.delegate = self
        showCategoryPicker()
        showPrepDatePicker()
        showCookDatePicker()
        
        setupView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func setupView() {
        setupSegmentedControl()
        updateView()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

    
    /////////////////////////////
    //Actions
    /////////////////////////////
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let managedObjectContext = managedObjectContext else {
                return }
        //guard let mealName = name.text, !mealName.isEmpty else {
            //showAlert(with: "Name Missing", and: "Your meal needs a name.")
         //   return
       // }

        let meal = Meal(context: managedObjectContext)
        meal.mealName = name.text // mealName
        //thumbnai
        meal.category = category.text
        if (serves.text != "") {
            meal.serves = Int16(serves.text!)!
        }
        meal.prepTime = prepTime.text
        meal.cookTime = cookTime.text
        meal.mealDesc = recipeDescriptionViewController.recipeDescription.text
        //meal.ingredients
     
        print("saved7")
        //_ = navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        //clear out each box
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImage(_ sender: Any) {
        self.showActionSheet(vc: self)
    }
 
    
    /////////////////////////////
    //Image Functions
    /////////////////////////////
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var newImage: UIImage
        
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        // do something interesting here!
        thumbnail.contentMode = .scaleAspectFit
        thumbnail.image = newImage
        dismiss(animated:true, completion: nil) //5

    }
    
    func showActionSheet(vc: UIViewController) {
        //currentVC = vc
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            //self.cameera
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoFromLibrary()
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
    func photoFromLibrary() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        //picker.sourceType = .photoLibrary
        //picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }

    
    /////////////////////////////
    //Picker Functions
    /////////////////////////////
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return categoryData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        category.text? = categoryData[row]
    }
    
    func showCategoryPicker() {
        category.inputView = pickCategory
        pickCategory.delegate = self
        
        //Toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTextPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTextPicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        category.inputAccessoryView = toolbar
    }
    
    @objc func cancelTextPicker() {
        category.text = nil
        self.view.endEditing(true)
    }
    
    @objc func doneTextPicker() {
        self.view.endEditing(true)
    }
    
    func showPrepDatePicker() {
        //Setup
        prepTime.inputView = pickTime
        pickTime.datePickerMode = .countDownTimer
        
        //Toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePrepDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        prepTime.inputAccessoryView = toolbar
    }

    @objc func donePrepDatePicker() {
        prepTime.text = calculateTime()
        self.view.endEditing(true)
    }
    
    func showCookDatePicker() {
        //Setup
        cookTime.inputView = pickTime
        pickTime.datePickerMode = .countDownTimer
        
        //Toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneCookDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        cookTime.inputAccessoryView = toolbar
    }

    @objc func doneCookDatePicker() {
        cookTime.text = calculateTime()
        self.view.endEditing(true)
    }
    
    @objc func cancelPicker() {
        self.view.endEditing(true)
    }
    
    func calculateTime() -> String {
        //Gets total number of minutes
        print(self.pickTime.countDownDuration)
        let minutesTotal = self.pickTime.countDownDuration / 60
        print(minutesTotal)
        //Get Hours
        let hours = Int(minutesTotal / 60)
        print(hours)
        //Get Remainder of Minutes
        let minutes = Int(minutesTotal) - Int(hours * 60)
        print(minutes)
        
        return "\(hours) hour(s) \(minutes) minute(s)"
    }

    
    /////////////////////////////
    //Segmented Control Functions
    /////////////////////////////
    func setupSegmentedControl() {
        // Configure Segmented Control
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "Description", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Ingredients", at: 1, animated: false)
        segmentedControl.insertSegment(withTitle: "Directions", at: 2, animated: false)
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        
        // Select First Segment
        segmentedControl.selectedSegmentIndex = 0
    }
    
    @objc func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }
    
    private lazy var recipeDescriptionViewController: RecipeDescriptionViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "RecipeDescriptionViewController") as! RecipeDescriptionViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var recipeIngredientViewController: RecipeIngredientViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "RecipeIngredientViewController") as! RecipeIngredientViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()

    private lazy var recipeDirectionsViewController: RecipeDirectionsViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "RecipeDirectionsViewController") as! RecipeDirectionsViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private func updateView() {
        if segmentedControl.selectedSegmentIndex == 0 {
            add(asChildViewController: recipeDescriptionViewController)
            remove(asChildViewController: recipeIngredientViewController)
            remove(asChildViewController: recipeDirectionsViewController)
        }
        else if segmentedControl.selectedSegmentIndex == 1 {
            remove(asChildViewController: recipeDescriptionViewController)
            add(asChildViewController: recipeIngredientViewController)
            remove(asChildViewController: recipeDirectionsViewController)
        }
        else {
            remove(asChildViewController: recipeDescriptionViewController)
            remove(asChildViewController: recipeIngredientViewController)
            add(asChildViewController: recipeDirectionsViewController)
        }
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        self.segmentedParentView.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
    

}
