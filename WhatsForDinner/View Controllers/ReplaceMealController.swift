//
//  ReplacePlannedMealController.swift
//  WhatsForDinner
//
//  Created by Josh Quirey on 5/22/19.
//  Copyright © 2019 jquirey. All rights reserved.
//

import UIKit
import CoreData

class ReplaceMealController: UITableViewController {
    
    //@IBOutlet weak var mealName: UILabel!
    var managedObjectContext: NSManagedObjectContext?
    private var nextMealsforCategory: [Meal]?
    private var nextMeals: [Meal]?
    var currentPlannedDay: PlannedDay?
    
    enum MealSections: Int {
        case NextCategory = 0, Next
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //title = "Meals"
        fetchNextMealsforCategory()
        fetchNextMeals()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
//    @IBAction func cancel(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
//    }
    
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
    }
    
    private func fetchNextMeals() {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Meal> = Meal.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.predicate = NSPredicate(format: "ANY tags.name != %@ AND estimatedNextDate != nil")
        
        //fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Meal.mealName), ascending: true)]
        
        // Perform Fetch Request
        managedObjectContext!.performAndWait {
            do {
                // Execute Fetch Request
                let meals = try fetchRequest.execute()
                //                print("Tickets Count Total: \(tickets.count)")
                
                // Update Tickets
                self.nextMeals = meals
                
                //Reload Table View
                //tableView.reloadData()
            } catch {
                let fetchError = error as NSError
                print("Unable to Execute Fetch Request")
                print("\(fetchError), \(fetchError.localizedDescription)")
            }
        }
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
           //if (nextMealsforCategory!.count > 0) {
                return nextMealsforCategory!.count
            //}
            //return 0
        } else {
            //if (nextMeals!.count > 0) {
                return nextMeals!.count
            //}
           // return 0
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "category"
        } else {
            return "next"
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "replaceMealCell", for: indexPath)
        
        if indexPath.section == MealSections.NextCategory.rawValue {
            guard let _meal = nextMealsforCategory?[indexPath.row] else { fatalError("Unexpected Index Path")}
            cell.textLabel?.text = _meal.mealName
            
        } else {
            guard let _meal = nextMeals?[indexPath.row] else { fatalError("Unexpected Index Path")}
            cell.textLabel?.text = _meal.mealName
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(meal!)
        //guard let managedObjectContext = meal?.managedObjectContext else { return }

        //tag = Tag(context: managedObjectContext)
       // tag?.name = categoryData[indexPath.row]

        //meal?.addToTags(tag!)
        self.dismiss(animated: true, completion: nil)
    }
}
