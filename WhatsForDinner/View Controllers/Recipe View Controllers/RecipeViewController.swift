//
//  RecipeViewController.swift
//  WhatsForDinner
//
//  Created by Josh Quirey on 8/7/18.
//  Copyright © 2018 jquirey. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import Photos

class RecipeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate {
    /////////////////////////////
    //Properties
    /////////////////////////////
    let frequencyData = [String](arrayLiteral: "", "Weekly", "Every Other Week", "Monthly", "Every Other Month", "Every Few Months")
    
    enum Frequency: Int {
        case weekly = 7
        case everyOtherWeek = 14
        case monthly = 30
        case everyOtherMonth = 60
        case everyFewMonths = 90
        case nopreference = 180
    }
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var categories: UITextView!
    @IBOutlet weak var mealDescription: UITextField!
    @IBOutlet weak var frequency: UITextField!
    @IBOutlet weak var serves: UITextField!
    @IBOutlet weak var prepTime: UITextField!
    @IBOutlet weak var cookTime: UITextField!
    @IBOutlet weak var imageButton: UIButton!
    
    let pickImage = UIImagePickerController()
    let pickFrequency = UIPickerView()
    let pickTime = UIDatePicker()
    let pickServing = UIPickerView()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var segmentedParentView: UIView!
    
    var managedObjectContext: NSManagedObjectContext?
    var meal: Meal?
    var imageChanged: Bool = false
    
    /////////////////////////////
    //Segues
    ////////////////////////////
    private enum Segue {
        static let SelectCategories = "SelectCategories"
    }
    
    /////////////////////////////s
    //View Life Cycle
    /////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        pickImage.delegate = self
        //meal = Meal(context: self.managedObjectContext!)
        showPicker(self.frequency, self.pickFrequency)
        showPrepDatePicker()
        showCookDatePicker()
        setupView()
        self.name.attributedPlaceholder = NSAttributedString(string: "Enter Meal Name",attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        //setupNotificationHandling()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        print(self.managedObjectContext!)
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if (meal?.mealImage != nil) {
            imageButton.setTitle(nil, for: .normal)
        }
        
        if (meal != nil) {
            viewMeal()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
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
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        if (meal == nil) {
            meal = Meal(context: managedObjectContext!)
        }
        populateMeal(meal!)
        
        switch identifier {
        case Segue.SelectCategories:
            guard let destination = segue.destination as? CategoriesViewController else {
                return
            }
        
            destination.meal = meal
            if (meal!.tags != nil) {
                destination.selectedTags = (meal?.tags)!
            }
        default:
            break
        }
     }
 
    func viewMeal() {
        name.text = meal!.mealName
        
        //photo
        if (meal!.mealImage != nil && !imageChanged) {
            //imageButton.setImage(UIImage(data: meal!.mealImage!), for: .normal)
            //imageButton.imageView?.image = UIImage(data: meal!.mealImage!)
            imageButton.setBackgroundImage(UIImage(data: meal!.mealImage!), for: .normal)
        }
        

        categories.text = nil
        if (meal!.tags != nil) {
        //if (meal!.tags!.count > 0) {
        for _tag in (meal!.tags?.allObjects)! {
            let tag = _tag as! Tag
            categories.text?.append(tag.name!)
        }
        }
        
        mealDescription.text = meal!.mealDesc
        
        switch meal?.frequency {
        case 7:
            frequency.text = "Weekly"
        case 14:
            frequency.text = "Every Other Week"
        case 30:
            frequency.text = "Monthly"
        case 60:
            frequency.text = "Every Other Month"
        case 90:
            frequency.text = "Every Few Months"
        default:
            frequency.text = "No Preference"
        }
        
        prepTime.text = meal!.prepTime
        cookTime.text = meal!.cookTime
        serves.text = meal!.serves
        recipeDirectionsViewController.recipeDirections.text = meal!.directions
        //ingredients
//        for _tag in (meal!.tags?.allObjects)! {
//            let tag = _tag as! Tag
//            categories.text?.append(tag.name!)
//        }
    }
    
    func populateMeal(_ meal: Meal) {
        meal.mealName = name.text
    
        //photo
        if (imageButton.currentBackgroundImage != nil) {
            guard let imageData = UIImageJPEGRepresentation(imageButton.backgroundImage(for: .normal)!, 1) else {
                print("image error")
                return
            }
        
            meal.mealImage = imageData
        }
        
        //category?
        
        meal.mealDesc = mealDescription.text
        
        print("populate meal")
        var _frequency = 0
        
        switch frequency.text {
        case "Weekly":
            _frequency = 7
        case "Every Other Week":
            _frequency = 14
        case "Monthly":
            _frequency = 30
        case "Every Other Month":
            _frequency = 60
        case "Every Few Months":
            _frequency = 90
        default:
            _frequency = 180
        }
        meal.frequency = Int16(_frequency)

        meal.prepTime = prepTime.text
        meal.cookTime = cookTime.text
        meal.serves = serves.text
        meal.directions = recipeDirectionsViewController.recipeDirections.text
        //ingredientss
        
        if (meal.nextDate == nil) {
            meal.estimatedNextDate =  Calendar.current.date(byAdding: .day, value: Int(meal.frequency), to: Date())
        }
    }

    /////////////////////////////
    //Actions
    /////////////////////////////
    @IBAction func save(_ sender: UIBarButtonItem) {
        if (meal == nil) {
            meal = Meal(context: managedObjectContext!)
        }
        
        populateMeal(meal!)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        if (meal != nil ) {
            if (meal!.mealName == nil) {
                managedObjectContext?.delete(meal!)
            }
        }
       
        self.dismiss(animated: true, completion: nil)
    }
    
//    private func setupNotificationHandling() {
//        let notificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(self,
//                                       selector: #selector(keyboardWillShow(notification:)),
//                                       name: Notification.Name.UIKeyboardWillShow,
//                                       object: nil)
//
//        notificationCenter.addObserver(self,
//                                       selector: #selector(keyboardWillHide(notification:)),
//                                       name: Notification.Name.UIKeyboardWillHide,
//                                       object: nil)
//
////        notificationCenter.addObserver(self,
////                                       selector: #selector(keyboardWillHide(notification:)),
////                                       name: Notification.Name.UIKeyboardWillChangeFrame,
////                                       object: nil)
//    }
    
//    deinit {
//        let notificationCenter = NotificationCenter.default
//        notificationCenter.removeObserver(self,
//                                          name: Notification.Name.UIKeyboardWillShow,
//                                          object: nil)
//
//        notificationCenter.removeObserver(self,
//                                          name: Notification.Name.UIKeyboardWillHide,
//                                          object: nil)
//    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        //self.activeTextField = textField
//        print("recipe controller - textfield did begin editing")
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        print("recipe controller - textfield did end editing")
//    }
//
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        //self.activeTextView = textView
//        print("recipe controller - textview did begin editing")
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        print("recipe controller - textview did end editing")
//    }
//
    
//    @objc func keyboardWillShow(notification: Notification) {
//        print("Keyboard will show")
//        if (true) {
//            var info:NSDictionary = notification.userInfo! as NSDictionary
//            let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
//
//
//            parent!.view.frame.origin.y = -(keyboardSize!.height)
//        }
//    }
    
//    @objc func keyboardWillHide(notification: Notification) {
//        print("Keyboard will hide")
//        //parent!.view.frame.origin.y = 0
//    }
    
    
    /////////////////////////////
    //Image Functions
    /////////////////////////////
    @IBAction func addImage(_ sender: Any) {
        self.showActionSheet(vc: self)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated:true, completion: nil)
        imageChanged = true
        let newImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageButton.setTitle("", for: .normal)
        imageButton.setBackgroundImage(newImage, for: .normal)
    }
    
    func showActionSheet(vc: UIViewController) {
        //currentVC = vc
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Use Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.DisplayPicker(type: .camera)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Use Photo Library", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.DisplayPicker(type: .photoLibrary)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
    func photoFromLibrary() {
        pickImage.allowsEditing = true
        pickImage.delegate = self
        //picker.sourceType = .photoLibrary
        //picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        self.present(pickImage, animated: true, completion: nil)
    }

    func DisplayPicker(type: UIImagePickerControllerSourceType){
        pickImage.mediaTypes = UIImagePickerController.availableMediaTypes(for: type)!
        pickImage.sourceType = type
        pickImage.allowsEditing = false
        
        //DispatchQueue.main.async {
        self.present(pickImage, animated: true, completion: nil)
        //}
    }
    
    /////////////////////////////
    //Picker Functions
    /////////////////////////////
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return frequencyData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return frequencyData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            frequency.text? = frequencyData[row]
            var _frequency = 0
        
            switch frequency.text {
            case "Weekly":
                _frequency = 7
            case "Every Other Week":
                _frequency = 14
            case "Monthly":
                _frequency = 30
            case "Every Other Month":
                _frequency = 60
            case "Every Few Months":
                _frequency = 90
            default:
                _frequency = 180
            }
            meal!.frequency = Int16(_frequency)
    }
    
    func showPicker(_ textField: UITextField, _ pickerView: UIPickerView) {
        textField.inputView = pickerView
        pickerView.delegate = self
        
        //Toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTextPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Choose", style: .plain, target: self, action: #selector(doneTextPicker))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        textField.inputAccessoryView = toolbar
    }
    
    @objc func cancelTextPicker() {
//        categories.text = nil
        self.view.endEditing(true)
    }
    
    @objc func doneTextPicker() {
        self.view.endEditing(true)
    }
    
    func showPrepDatePicker() {
        prepTime.inputView = pickTime
        pickTime.datePickerMode = .countDownTimer
       
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPrepPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Choose", style: .plain, target: self, action: #selector(donePrepPicker))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        prepTime.inputAccessoryView = toolbar
    }

    @objc func donePrepPicker() {
        prepTime.text = calculateTime()
        self.view.endEditing(true)
    }
    
    @objc func cancelPrepPicker() {
        self.view.endEditing(true)
    }
    
    func showCookDatePicker() {
        cookTime.inputView = pickTime
        pickTime.datePickerMode = .countDownTimer
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelCookPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Choose", style: .plain, target: self, action: #selector(doneCookPicker))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        cookTime.inputAccessoryView = toolbar
    }

    @objc func doneCookPicker() {
        cookTime.text = calculateTime()
        self.view.endEditing(true)
    }
    
    @objc func cancelCookPicker() {
        self.view.endEditing(true)
    }
    
    func calculateTime() -> String {
        //Gets total number of minutes
        print(self.pickTime.countDownDuration)
        let minutesTotal = self.pickTime.countDownDuration / 60
        //Get Hours
        let hours = Int(minutesTotal / 60)
        //Get Remainder of Minutes
        let minutes = Int(minutesTotal) - Int(hours * 60)
        
        if (hours > 0) {
            return "\(hours)hrs \(minutes)min"
        } else {
            return "\(minutes)min"
        }
    }


    /////////////////////////////
    //Segmented Control Functions
    /////////////////////////////
    func setupSegmentedControl() {
        // Configure Segmented Control
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "Directions", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Ingredients", at: 1, animated: false)
//        segmentedControl.insertSegment(withTitle: "Directions", at: 2, animated: false)
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        
        // Select First Segment
        segmentedControl.selectedSegmentIndex = 0
    
    }
    
    @objc func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }
    
    private lazy var recipeIngredientViewController: RecipeIngredientViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "RecipeIngredientViewController") as! RecipeIngredientViewController
        viewController.meal = meal
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()

    private lazy var recipeDirectionsViewController: RecipeDirectionsViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "RecipeDirectionsViewController") as! RecipeDirectionsViewController
        viewController.meal = meal
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private func updateView() {
        if segmentedControl.selectedSegmentIndex == 0 {
            add(asChildViewController: recipeDirectionsViewController)
            remove(asChildViewController: recipeIngredientViewController)
            //remove(asChildViewController: recipeDirectionsViewController)
        }
        else { //if segmentedControl.selectedSegmentIndex == 1 {
            remove(asChildViewController: recipeDirectionsViewController)
            add(asChildViewController: recipeIngredientViewController)
            //remove(asChildViewController: recipeDirectionsViewController)
        }
//        else {
//            remove(asChildViewController: recipeDescriptionViewController)
//            remove(asChildViewController: recipeIngredientViewController)
//            add(asChildViewController: recipeDirectionsViewController)
//        }
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
    
    //    private lazy var recipeDescriptionViewController: RecipeDescriptionViewController = {
    //        // Load Storyboard
    //        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    //
    //        // Instantiate View Controller
    //        var viewController = storyboard.instantiateViewController(withIdentifier: "RecipeDescriptionViewController") as! RecipeDescriptionViewController
    //        //let contentSize = viewController.recipeDescription.sizeThatFits(segmentedParentView.bounds.size)
    //        //var frame = viewController.recipeDescription.frame
    //        //height = segmentedParentView.frame.height //contentSize.height
    //        //viewController.recipeDescription.frame = frame
    //
    //        // Add View Controller as Child View Controller
    //        self.add(asChildViewController: viewController)
    //
    //        return viewController
    //    }()
}
