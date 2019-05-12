//
//  CreatePlanViewController.swift
//  WhatsForDinner
//
//  Created by Josh Quirey on 4/19/19.
//  Copyright © 2019 jquirey. All rights reserved.
//

import UIKit
import CoreData

class CreatePlanViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var bottomStackViewConstraint: NSLayoutConstraint!
    
    var managedObjectContext: NSManagedObjectContext?
    //var day7Plan: PlannedDay?
    var weekPlan = [PlannedDay?]()
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var childView1: UIView!
    @IBOutlet weak var childView2: UIView!
    @IBOutlet weak var childView3: UIView!
    @IBOutlet weak var childView4: UIView!
    @IBOutlet weak var childView5: UIView!
    @IBOutlet weak var childView6: UIView!
    @IBOutlet weak var childView7: UIView!
    
    @IBOutlet weak var startingDate: UITextField!
    let startingDatePicker = UIDatePicker()
    
    var dateDay1: Date?
    @IBOutlet weak var labelDay1: UILabel!
    @IBOutlet weak var category1: UITextField!
    var dateDay2: Date?
    @IBOutlet weak var labelDay2: UILabel!
    @IBOutlet weak var category2: UITextField!
    var dateDay3: Date?
    @IBOutlet weak var labelDay3: UILabel!
    @IBOutlet weak var category3: UITextField!
    var dateDay4: Date?
    @IBOutlet weak var labelDay4: UILabel!
    @IBOutlet weak var category4: UITextField!
    var dateDay5: Date?
    @IBOutlet weak var labelDay5: UILabel!
    @IBOutlet weak var category5: UITextField!
    var dateDay6: Date?
    @IBOutlet weak var labelDay6: UILabel!
    @IBOutlet weak var category6: UITextField!
    var dateDay7: Date?
    @IBOutlet weak var labelDay7: UILabel!
    @IBOutlet weak var category7: UITextField!
    
    let picker1 = UIPickerView()
    let picker2 = UIPickerView()
    let picker3 = UIPickerView()
    let picker4 = UIPickerView()
    let picker5 = UIPickerView()
    let picker6 = UIPickerView()
    let picker7 = UIPickerView()
    
    var categoryData = [String](arrayLiteral: "Chef's Choice 🎲")
        //"Asian Cuisine 🥡", "Breakfast for Dinner 🥓", "Barbecue 🐷", "Casserole 🥘", "Comfort Food 🛌", "Chicken 🐓", "Mexican  🌮", "Pasta 🍝", "Pizza 🍕", "Pork 🐖", "On The Grill 🥩", "Other", "Salad 🥗", "Sandwich 🥪", "Seafood 🍤", "Slow Cooker ⏲", "Soups Up 🍜", "Vegetarian 🥕")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        showStartingDatePicker()
        startingDate.delegate = self
        showPicker(self.category1, self.picker1)
        showPicker(self.category2, self.picker2)
        showPicker(self.category3, self.picker3)
        showPicker(self.category4, self.picker4)
        showPicker(self.category5, self.picker5)
        showPicker(self.category6, self.picker6)
        showPicker(self.category7, self.picker7)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadCategories()
    }
    
    func loadCategories() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tag")
        fetchRequest.propertiesToFetch = ["name"]
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.returnsDistinctResults = true
        
        self.managedObjectContext?.performAndWait {
            do {
                let tags = try fetchRequest.execute()
    
                for tag in tags {
                    if let dic = (tag as? [String : String]){
                        if let nameString = dic["name"]{
                            categoryData.append(nameString)
                        }
                    }
                }
            } catch {
                let fetchError = error as NSError
                print("Unable to Execute Fetch Request")
                print("\(fetchError), \(fetchError.localizedDescription)")
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func create(_ sender: Any) {
        //Day1
        var plannedMeal = Meal(context: self.managedObjectContext!)
        let day1Plan = PlannedDay(context: self.managedObjectContext!)
        day1Plan.planStartDate = dateDay1
        day1Plan.date = dateDay1
        day1Plan.planEndDate = dateDay7
        day1Plan.category = category1.text
        //Get Meal by Category
        day1Plan.meal = self.getNextMealforCategory(_plannedCategory: day1Plan.category!, _plannedDate: day1Plan.date!, _plannedMeal: &plannedMeal)
        //Get Next Meal
        if (day1Plan.meal!.mealName == nil) {
            day1Plan.meal = self.getNextMeal(_plannedDate: day1Plan.date!, _plannedMeal: &plannedMeal)
        }
        //Order Pizza
        if (day1Plan.meal!.mealName == nil) {
            day1Plan.meal?.mealName = "Order Pizza"
            //Alert User that no meal could be found
        }
        print("Selected Meal 1: \(day1Plan.meal!.mealName!)")
        
        //Day2
        var plannedMeal2 = Meal(context: self.managedObjectContext!)
        let day2Plan = PlannedDay(context: self.managedObjectContext!)
        day2Plan.planStartDate = dateDay1
        day2Plan.date = dateDay2
        day2Plan.planEndDate = dateDay7
        day2Plan.category = category2.text
        //Get Meal by Category
        day2Plan.meal = self.getNextMealforCategory(_plannedCategory: day2Plan.category!, _plannedDate: day2Plan.date!, _plannedMeal: &plannedMeal2)
        //Get Next Meal
        if (day2Plan.meal!.mealName == nil) {
            day2Plan.meal = self.getNextMeal(_plannedDate: day2Plan.date!, _plannedMeal: &plannedMeal2)
        }
        //Order Pizza
        if (day2Plan.meal!.mealName == nil) {
            day2Plan.meal?.mealName = "Order Pizza 2"
            //Alert User that no meal could be found
        }
        print("Selected Meal 2: \(day2Plan.meal!.mealName!)")
       
        
        //Day3
        var plannedMeal3 = Meal(context: self.managedObjectContext!)
        let day3Plan = PlannedDay(context: self.managedObjectContext!)
        day3Plan.planStartDate = dateDay1
        day3Plan.date = dateDay3
        day3Plan.planEndDate = dateDay7
        day3Plan.category = category3.text
        //Get Meal by Category
        day3Plan.meal = self.getNextMealforCategory(_plannedCategory: day3Plan.category!, _plannedDate: day3Plan.date!, _plannedMeal: &plannedMeal3)
        //Get Next Meal
        if (day3Plan.meal!.mealName == nil) {
            day3Plan.meal = self.getNextMeal(_plannedDate: day3Plan.date!, _plannedMeal: &plannedMeal3)
        }
        //Order Pizza
        if (day3Plan.meal!.mealName == nil) {
            day3Plan.meal?.mealName = "Order Pizza 3"
            //Alert User that no meal could be found
        }
        print("Selected Meal 3: \(day3Plan.meal!.mealName!)")
       
        
        //Day4
        var plannedMeal4 = Meal(context: self.managedObjectContext!)
        let day4Plan = PlannedDay(context: self.managedObjectContext!)
        day4Plan.planStartDate = dateDay1
        day4Plan.date = dateDay4
        day4Plan.planEndDate = dateDay7
        day4Plan.category = category4.text
        //Get Meal by Category
        day4Plan.meal = self.getNextMealforCategory(_plannedCategory: day4Plan.category!, _plannedDate: day4Plan.date!, _plannedMeal: &plannedMeal4)
        //Get Next Meal
        if (day4Plan.meal!.mealName == nil) {
            day4Plan.meal = self.getNextMeal(_plannedDate: day4Plan.date!, _plannedMeal: &plannedMeal4)
        }
        //Order Pizza
        if (day4Plan.meal!.mealName == nil) {
            day4Plan.meal?.mealName = "Order Pizza 4"
            //Alert User that no meal could be found
        }
        //Cleanup
        print("Selected Meal 4: \(day4Plan.meal!.mealName!)")
    

        //Day5
        var plannedMeal5 = Meal(context: self.managedObjectContext!)
        let day5Plan = PlannedDay(context: self.managedObjectContext!)
        day5Plan.planStartDate = dateDay1
        day5Plan.date = dateDay5
        day5Plan.planEndDate = dateDay7
        day5Plan.category = category5.text
        //Get Meal by Category
        day5Plan.meal = self.getNextMealforCategory(_plannedCategory: day5Plan.category!, _plannedDate: day5Plan.date!, _plannedMeal: &plannedMeal5)
        //Get Next Meal
        if (day5Plan.meal!.mealName == nil) {
            day5Plan.meal = self.getNextMeal(_plannedDate: day5Plan.date!, _plannedMeal: &plannedMeal5)
        }
        //Order Pizza
        if (day5Plan.meal!.mealName == nil) {
            day5Plan.meal?.mealName = "Order Pizza 5"
            //Alert User that no meal could be found
        }
        print("Selected Meal 5: \(day5Plan.meal!.mealName!)")
        
        
        //Day6
        var plannedMeal6 = Meal(context: self.managedObjectContext!)
        let day6Plan = PlannedDay(context: self.managedObjectContext!)
        day6Plan.planStartDate = dateDay1
        day6Plan.date = dateDay6
        day6Plan.planEndDate = dateDay7
        day6Plan.category = category6.text
        //Get Meal by Category
        day6Plan.meal = self.getNextMealforCategory(_plannedCategory: day6Plan.category!, _plannedDate: day6Plan.date!, _plannedMeal: &plannedMeal6)
        //Get Next Meal
        if (day6Plan.meal!.mealName == nil) {
            day6Plan.meal = self.getNextMeal(_plannedDate: day6Plan.date!, _plannedMeal: &plannedMeal6)
        }
        //Order Pizza
        if (day6Plan.meal!.mealName == nil) {
            day6Plan.meal?.mealName = "Order Pizza 3"
            //Alert User that no meal could be found
        }
        print("Selected Meal 6: \(day6Plan.meal!.mealName!)")

        
        //Day7
        var plannedMeal7 = Meal(context: self.managedObjectContext!)
        let day7Plan = PlannedDay(context: self.managedObjectContext!)
        day7Plan.planStartDate = dateDay1
        day7Plan.date = dateDay7
        day7Plan.planEndDate = dateDay7
        day7Plan.category = category7.text
        //Get Meal by Category
        day7Plan.meal = self.getNextMealforCategory(_plannedCategory: day7Plan.category!, _plannedDate: day7Plan.date!, _plannedMeal: &plannedMeal7)
        //Get Next Meal
        if (day7Plan.meal!.mealName == nil) {
            day7Plan.meal = self.getNextMeal(_plannedDate: day7Plan.date!, _plannedMeal: &plannedMeal7)
        }
        //Order Pizza
        if (day7Plan.meal!.mealName == nil) {
            day7Plan.meal?.mealName = "Order Pizza 7"
            //Alert User that no meal could be found
        }
        print("Selected Meal 7: \(day7Plan.meal!.mealName!)")
    
        //Cleanup
//        self.managedObjectContext?.delete(plannedMeal)
//        self.managedObjectContext?.delete(plannedMeal2)
//        self.managedObjectContext?.delete(plannedMeal3)
//        self.managedObjectContext?.delete(plannedMeal4)
//        self.managedObjectContext?.delete(plannedMeal5)
//        self.managedObjectContext?.delete(plannedMeal6)
//        self.managedObjectContext?.delete(plannedMeal7)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func getNextMealforCategory(_plannedCategory: String, _plannedDate: Date, _plannedMeal: inout Meal) -> Meal? {
        let fetchRequest: NSFetchRequest<Meal> = Meal.fetchRequest()
        
        //Fetch Meals using Category
        fetchRequest.predicate = NSPredicate(format: "ANY tags.name == %@ AND estimatedNextDate != nil", _plannedCategory)
        
        //Sort by estimated next date
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Meal.estimatedNextDate), ascending:true)]
        
        //Perform Fetch Request
        self.managedObjectContext?.performAndWait {
            do {
                //Execute Fetch Request
                let meals = try fetchRequest.execute()
                //Search for Meal
                if (meals.count > 0) {
                    _plannedMeal = FindMeal(_meals: meals, _plannedDate: _plannedDate, _plannedMeal: &_plannedMeal)
                }
            } catch {
                let fetchError = error as NSError
                print("Unable to Execute Fetch Request")
                print("\(fetchError), \(fetchError.localizedDescription)")
            }
        }
        
        return _plannedMeal
    }
    
    func getNextMeal(_plannedDate: Date, _plannedMeal: inout Meal) -> Meal {
        let fetchRequest: NSFetchRequest<Meal> = Meal.fetchRequest()
        
        //Fetch Meals using Category
        fetchRequest.predicate = NSPredicate(format: "ANY estimatedNextDate != nil")
        
        //Sort by estimated next date
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Meal.estimatedNextDate), ascending:true)]
        
        //Perform Fetch Request
        self.managedObjectContext?.performAndWait {
            do {
                //Execute Fetch Request
                let meals = try fetchRequest.execute()
                //Search for Meal
                _plannedMeal = FindMeal(_meals: meals, _plannedDate: _plannedDate, _plannedMeal: &_plannedMeal)
                
            } catch {
                let fetchError = error as NSError
                print("Unable to Execute Fetch Request")
                print("\(fetchError), \(fetchError.localizedDescription)")
            }
        }

        return _plannedMeal
    }
    
    func FindMeal(_meals: [Meal], _plannedDate: Date, _plannedMeal: inout Meal) -> Meal {
        var mealExists: Bool = false
        
        //check to see if meal is in current plan
        for _meal in _meals {
            mealExists = false
            
            //check if meal is already in current plan
            for day in weekPlan {
                //if meal exists already
                if (_meal.objectID == day?.meal?.objectID) {
                    //go to next meal in meals
                    mealExists = true
                    break
                }
            }
            
            if (!mealExists) {
                _plannedMeal = _meal
                _plannedMeal.nextDate = _plannedDate
                _plannedMeal.estimatedNextDate = nil
                break
            }
        }
        
        return _plannedMeal
    }
    
    //Print meals for testing
    //                for meal in meals {
    //                    print("Name \(meal.value(forKey: "mealName") ?? "no name") -- Estimated Next Date \(meal.value(forKey: "estimatedNextDate") ?? "no est") -- Frequency \(meal.value(forKey: "frequency") ?? "no frequency")")
    //
    //                    for category in meal.tags?.allObjects as! [Tag] {
    //                        print(category.name!)
    //                    }
    //                }
    
    /////////////////////////////
    //Text Field Functions
    ////////////////////////////
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField)
        //update each of the day labels
        updateDayDates()
    }
    
    func updateDayDates() {
        print(startingDatePicker.date)
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        
        //Day One
        dateDay1 = startingDatePicker.date
        labelDay1.text = formatter.string(from: startingDatePicker.date)
        
        //Day Two
        dateDay2 = Calendar.current.date(byAdding: .day, value: 1, to: startingDatePicker.date)
        labelDay2.text = formatter.string(from: dateDay2!)
        
        //Day Three
        dateDay3 = Calendar.current.date(byAdding: .day, value: 2, to: startingDatePicker.date)
        labelDay3.text = formatter.string(from: dateDay3!)
        
        //Day Four
        dateDay4 = Calendar.current.date(byAdding: .day, value: 3, to: startingDatePicker.date)
        labelDay4.text = formatter.string(from: dateDay4!)
        
        //Day Five
        dateDay5 = Calendar.current.date(byAdding: .day, value: 4, to: startingDatePicker.date)
        labelDay5.text = formatter.string(from: dateDay5!)
        
        //Day Six
        dateDay6 = Calendar.current.date(byAdding: .day, value: 5, to: startingDatePicker.date)
        labelDay6.text = formatter.string(from: dateDay6!)
        
        //Day Seven
        dateDay7 = Calendar.current.date(byAdding: .day, value: 6, to: startingDatePicker.date)
        labelDay7.text = formatter.string(from: dateDay7!)
    }
    
    /////////////////////////////
    //Date Picker Functions
    /////////////////////////////
    func showStartingDatePicker() {
        //Setup
        startingDate.inputView = startingDatePicker
        startingDatePicker.datePickerMode = .date
        
        //Toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePrepDatePicker))
        //let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker))
        toolbar.setItems([spaceButton,doneButton], animated: false)
        
        startingDate.inputAccessoryView = toolbar
        print(startingDatePicker.date)
    
        //startingDatePicker.date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        startingDate.text = formatter.string(from: startingDatePicker.date)
        updateDayDates()
    }
    
    @objc func donePrepDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        startingDate.text = formatter.string(from: startingDatePicker.date)
        self.view.endEditing(true)
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
        switch (pickerView) {
        case picker1:
            category1.text? = categoryData[row]
            break
        case picker2:
            category2.text? = categoryData[row]
            break
        case picker3:
            category3.text? = categoryData[row]
            break
        case picker4:
            category4.text? = categoryData[row]
            break
        case picker5:
            category5.text? = categoryData[row]
            break
        case picker6:
            category6.text? = categoryData[row]
            break
        case picker7:
            category7.text? = categoryData[row]
            break
        default:
            break
        }
    }
    
    func showPicker(_ textField: UITextField, _ pickerView: UIPickerView) {
        textField.inputView = pickerView
        pickerView.delegate = self

        //Toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTextPicker))
        //let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTextPicker))
        toolbar.setItems([spaceButton,doneButton], animated: false)
        
        textField.inputAccessoryView = toolbar
        textField.text = categoryData[0]
    }
    
    @objc func cancelTextPicker() {
        //category1.text = nil
        self.view.endEditing(true)
    }
    
    @objc func doneTextPicker() {
        self.view.endEditing(true)
    }
}
