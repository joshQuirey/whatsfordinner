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
    
    let categoryData = [String](arrayLiteral: "Asian Cuisine 🥡", "Breakfast for Dinner 🥓", "Barbecue 🐷", "Casserole 🥘", "Comfort Food 🛌", "Chicken 🐓", "Mexican  🌮", "Pasta 🍝", "Pizza 🍕", "Pork 🐖", "On The Grill 🥩", "Other", "Salad 🥗", "Sandwich 🥪", "Seafood 🍤", "Slow Cooker ⏲", "Soups Up 🍜", "Vegetarian 🥕")

    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func create(_ sender: Any) {
      
        //Day7
        let day7Plan = PlannedDay(context: self.managedObjectContext!)
        day7Plan.planStartDate = dateDay1
        day7Plan.date = dateDay7
        day7Plan.planEndDate = dateDay7
        day7Plan.category = category7.text
        //Get Meal
        day7Plan.meal = self.getMealforPlannedDay(_category: day7Plan.category!, _plannedDate: day7Plan.date!)
        print("Selected Meal: \(day7Plan.meal!.mealName!)")
        weekPlan.append(day7Plan)
        
        //Day6
        let day6Plan = PlannedDay(context: self.managedObjectContext!)
        day6Plan.planStartDate = dateDay1
        day6Plan.date = dateDay6
        day6Plan.planEndDate = dateDay7
        day6Plan.category = category6.text
        //Get Meal
        day6Plan.meal = self.getMealforPlannedDay(_category: day6Plan.category!, _plannedDate: day6Plan.date!)
        print("Selected Meal: \(day6Plan.meal!.mealName!)")
        weekPlan.append(day6Plan)

        //Day5
        let day5Plan = PlannedDay(context: self.managedObjectContext!)
        day5Plan.planStartDate = dateDay1
        day5Plan.date = dateDay5
        day5Plan.planEndDate = dateDay7
        //Get Meal
        day5Plan.meal = self.getMealforPlannedDay(_category: day5Plan.category!, _plannedDate: day5Plan.date!)
        //if meal is null???
        print("Selected Meal: \(day5Plan.meal!.mealName!)")
        day5Plan.category = category5.text
        
        weekPlan.append(day5Plan)

        //Day4
        let day4Plan = PlannedDay(context: self.managedObjectContext!)
        day4Plan.planStartDate = dateDay1
        day4Plan.date = dateDay4
        day4Plan.planEndDate = dateDay7
        //Get Meal
        day4Plan.meal = self.getMealforPlannedDay(_category: day4Plan.category!, _plannedDate: day4Plan.date!)
        print("Selected Meal: \(day4Plan.meal!.mealName!)")
        day4Plan.category = category4.text
        weekPlan.append(day4Plan)

        //Day3
        let day3Plan = PlannedDay(context: self.managedObjectContext!)
        day3Plan.planStartDate = dateDay1
        day3Plan.date = dateDay3
        day3Plan.planEndDate = dateDay7
        //Get Meal
        day3Plan.meal = self.getMealforPlannedDay(_category: day3Plan.category!, _plannedDate: day3Plan.date!)
        print("Selected Meal: \(day3Plan.meal!.mealName!)")
        day3Plan.category = category3.text
        weekPlan.append(day3Plan)

        //Day2
        let day2Plan = PlannedDay(context: self.managedObjectContext!)
        day2Plan.planStartDate = dateDay1
        day2Plan.date = dateDay2
        day2Plan.planEndDate = dateDay7
        //Get Meal
        day2Plan.meal = self.getMealforPlannedDay(_category: day2Plan.category!, _plannedDate: day2Plan.date!)
        print("Selected Meal: \(day2Plan.meal!.mealName!)")
        day2Plan.category = category2.text
        weekPlan.append(day2Plan)

        //Day1
        let day1Plan = PlannedDay(context: self.managedObjectContext!)
        day1Plan.planStartDate = dateDay1
        day1Plan.date = dateDay1
        day1Plan.planEndDate = dateDay7
        //Get Meal
        day1Plan.meal = self.getMealforPlannedDay(_category: day1Plan.category!, _plannedDate: day1Plan.date!)
        print("Selected Meal: \(day1Plan.meal!.mealName!)")
        day1Plan.category = category1.text
        weekPlan.append(day1Plan)

       //print(weekPlan)
        
    }
    
    func getMealforPlannedDay(_category: String, _plannedDate: Date) -> Meal {
        var _meal = Meal.init()
        let fetchRequest: NSFetchRequest<Meal> = Meal.fetchRequest()
        
        //Fetch Meals using Category
        fetchRequest.predicate = NSPredicate(format: "ANY tags.name == %@ AND estimatedNextDate != nil", _category)
        
        //Sort by estimated next date
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Meal.estimatedNextDate), ascending:true)]
        
        //Perform Fetch Request
        self.managedObjectContext?.performAndWait {
            do {
                //Execute Fetch Request
                let meals = try fetchRequest.execute()
                
                //Print meals for testing
//                for meal in meals {
//                    print("Name \(meal.value(forKey: "mealName") ?? "no name") -- Estimated Next Date \(meal.value(forKey: "estimatedNextDate") ?? "no est") -- Frequency \(meal.value(forKey: "frequency") ?? "no frequency")")
//
//                    for category in meal.tags?.allObjects as! [Tag] {
//                        print(category.name!)
//                    }
//                }
                
                //check to see if meal is in current plan
                _meal = meals[0]
                _meal.nextDate = _plannedDate
                _meal.estimatedNextDate = nil
                //when you mark complete prevdate becomes nextdate, nextdate becomes null, estimated gets calculated
                //}
                //Category \(record.value(forKey: "tag") ?? "no tag")) --
                //Update Meals
                //self.meals
                //self.tableView.reloadData()
            } catch {
                let fetchError = error as NSError
                print("Unable to Execute Fetch Request")
                print("\(fetchError), \(fetchError.localizedDescription)")
            }
        }
        
        return _meal
    }
    
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
        
        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    /////////////////////////////
    //Text Field Functions
    ////////////////////////////
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField)
        //update each of the day labels
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
    }
    
    @objc func cancelTextPicker() {
        //category1.text = nil
        self.view.endEditing(true)
    }
    
    @objc func doneTextPicker() {
        self.view.endEditing(true)
    }
}
