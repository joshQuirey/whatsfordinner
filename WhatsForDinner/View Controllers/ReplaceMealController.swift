//
//  ReplacePlannedMealController.swift
//  WhatsForDinner
//
//  Created by Josh Quirey on 5/22/19.
//  Copyright © 2019 jquirey. All rights reserved.
//

import UIKit
import CoreData

class ReplaceMealController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //@IBOutlet weak var mealName: UILabel!
    var managedObjectContext: NSManagedObjectContext?
    private var nextMealsforCategory: [Meal]?
    private var nextMeals: [Meal]?
    var currentPlannedDay: PlannedDay?
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    enum MealSections: Int {
        case NextCategory = 0, Next
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //title = "Meals"
        fetchNextMealsforCategory()
        fetchNextMeals()
        tableView.reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    
    // MARK: - Table view data source
    private func fetchNextMealsforCategory() {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Meal> = Meal.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.predicate = NSPredicate(format: "ANY tags.name == %@ AND estimatedNextDate != nil", currentPlannedDay!.category!)
        
        //fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Meal.mealName), ascending: true)]
        
        // Perform Fetch Request
        managedObjectContext!.performAndWait {
            do {
                // Execute Fetch Request
                let meals = try fetchRequest.execute()
                //                print("Tickets Count Total: \(tickets.count)")
                
                // Update Tickets
                self.nextMealsforCategory = meals
                
                //Reload Table View
                //tableView.reloadData()
            } catch {
                let fetchError = error as NSError
                print("Unable to Execute Fetch Request")
                print("\(fetchError), \(fetchError.localizedDescription)")
            }
        }
        print(self.nextMealsforCategory)
    }
    
    private func fetchNextMeals() {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Meal> = Meal.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.predicate = NSPredicate(format: "ANY tags.name != %@ AND estimatedNextDate != nil", currentPlannedDay!.category!)
        
        //fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Meal.mealName), ascending: true)]
        
        // Perform Fetch Request
        managedObjectContext!.performAndWait {
            do {
                // Execute Fetch Request
                let meals = try fetchRequest.execute()
                //                print("Tickets Count Total: \(tickets.count)")
                
                // Update Tickets
                self.nextMealsforCategory?.append(contentsOf: meals)
                
                //Reload Table View
                //tableView.reloadData()
            } catch {
                let fetchError = error as NSError
                print("Unable to Execute Fetch Request")
                print("\(fetchError), \(fetchError.localizedDescription)")
            }
        }
        
        //print(self.nextMeals)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return nextMealsforCategory!.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if section == 0 {
        return 1
            //return nextMealsforCategory!.count
        //} else {
        //    return nextMeals!.count
        //}
    }

//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0 {
//            return "Next Available \(currentPlannedDay!.category!)"
//        } else {
//            return "Next Available"
//        }
//    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 10))
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "replaceCell", for: indexPath) as! ReplaceTableViewCell
        
        
//        if indexPath.section == MealSections.NextCategory.rawValue {
            guard let _meal = nextMealsforCategory?[indexPath.section] else { fatalError("Unexpected Index Path")}
            
            if (_meal.mealImage != nil) {
                cell.mealImage?.image = UIImage(data: _meal.mealImage!)
            }
            
            cell.mealName.text = _meal.mealName
        
            cell.mealCategories?.text = ""
            for _tag in (_meal.tags?.allObjects)! {
                let tag = _tag as! Tag
                cell.mealCategories?.text?.append("\(tag.name!) ")
            }
        
            if (_meal.prepTime! != nil && _meal.prepTime! != "") {
                cell.prep?.text? = "Plan: \(_meal.prepTime!)"
            } else {
                cell.prep?.text? = " "
            }
        
            if (_meal.cookTime != nil && _meal.cookTime! != "") {
                cell.cook?.text? = "Cook: \(_meal.cookTime!)"
            } else {
                cell.cook?.text? = " "
            }
        
        //cell.layer.borderWidth = 0
        //cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        //cell.layer.frame = CGRect(x: 8, y: 8, width: 100, height: 80)
        //cell.backgroundColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let _currentMeal = currentPlannedDay?.meal else { fatalError("Unexpected Index Path")}

//        if indexPath.section == MealSections.NextCategory.rawValue {
            guard let _replaceMeal = nextMealsforCategory?[indexPath.section] else { fatalError("Unexpected Index Path")}
            //delete previous meal
            _currentMeal.estimatedNextDate = _currentMeal.previousDate
            _currentMeal.nextDate = nil
            _currentMeal.previousDate = nil
            _currentMeal.removeFromPlannedDays(currentPlannedDay!)
            
            //add next meal
            _replaceMeal.previousDate = _replaceMeal.estimatedNextDate
            _replaceMeal.estimatedNextDate = nil
            _replaceMeal.nextDate = currentPlannedDay!.date
            _replaceMeal.addToPlannedDays(currentPlannedDay!)
//        } else {
//            guard let _replaceMeal = nextMeals?[indexPath.row] else { fatalError("Unexpected Index Path")}
//            //delete previous meal
//            _currentMeal.estimatedNextDate = _currentMeal.previousDate
//            _currentMeal.nextDate = nil
//            _currentMeal.previousDate = nil
//            _currentMeal.removeFromPlannedDays(currentPlannedDay!)
//
//            //add next meal
//            _replaceMeal.previousDate = _replaceMeal.estimatedNextDate
//            _replaceMeal.estimatedNextDate = nil
//            _replaceMeal.nextDate = currentPlannedDay!.date
//            _replaceMeal.addToPlannedDays(currentPlannedDay!)
//        }

        
        self.dismiss(animated: true, completion: nil)
    }
}
