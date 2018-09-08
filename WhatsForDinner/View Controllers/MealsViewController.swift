//
//  MealsViewController.swift
//  WhatsForDinner
//
//  Created by Josh Quirey on 8/6/18.
//  Copyright © 2018 jquirey. All rights reserved.
//

import UIKit
import CoreData

class MealsViewController: UIViewController, UITableViewDataSource {
    /////////////////////////////
    //Properties
    /////////////////////////////
    private var coreDataManager = CoreDataManager(modelName: "MealModel")
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyTableLabel: UILabel!
    
    private var meals: [Meal]? {
        didSet {
            updateView()
        }
    }
    
    private var hasMeals: Bool {
        guard let meals = meals else { return false }
        return meals.count > 0
    }
    
    /////////////////////////////
    //Segues
    /////////////////////////////
    private enum Segue {
        static let AddMeal = "AddMeal"
    }
    
    
    /////////////////////////////
    //View Life Cycle
    /////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Meals"
        fetchNotes()
        setupNotificationHandling()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setupNotificationHandling() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(managedObjectContextObjectsDidChange(_:)),
                                       name: Notification.Name.NSManagedObjectContextObjectsDidChange,
                                       object: coreDataManager.managedObjectContext)
    }

    private func updateView() {
        tableView.isHidden = !hasMeals
        emptyTableLabel.isHidden = hasMeals
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print("tony")
        guard let identifier = segue.identifier else {
            //  print("help")
            return }
        //print("josh")
        switch identifier {
        case Segue.AddMeal:
            guard let destination = segue.destination as? RecipeViewController else {
                return
            }
            //print("destination")
            destination.managedObjectContext = coreDataManager.managedObjectContext
        default:
            break
        }
    }
    
    
    /////////////////////////////
    //Core Data Functions
    /////////////////////////////
    @objc private func managedObjectContextObjectsDidChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        // Helpers
        var mealsDidChange = false
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> {
            for insert in inserts {
                if let meal = insert as? Meal {
                    meals?.append(meal)
                    mealsDidChange = true
                }
            }
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> {
            for update in updates {
                if let _ = update as? Meal {
                    mealsDidChange = true
                }
            }
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject> {
            for delete in deletes {
                if let meal = delete as? Meal {
                    if let index = meals?.index(of: meal) {
                        meals?.remove(at: index)
                        mealsDidChange = true
                    }
                }
            }
        }
        
        if mealsDidChange {
            // Sort Meals
            //meals?.sorted { $0 > $1 }
            
            // Update Table View
            tableView.reloadData()
            
            // Update View
            updateView()
        }
    }

    private func fetchNotes() {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Meal> = Meal.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Meal.mealName), ascending: true)]
        
        // Perform Fetch Request
        coreDataManager.managedObjectContext.performAndWait {
            do {
                // Execute Fetch Request
                let meals = try fetchRequest.execute()
                
                // Update Notes
                self.meals = meals
                
                // Reload Table View
                self.tableView.reloadData()
                
            } catch {
                let fetchError = error as NSError
                print("Unable to Execute Fetch Request")
                print("\(fetchError), \(fetchError.localizedDescription)")
            }
        }
    }
    
    
    /////////////////////////////
    //Table Functions
    /////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let meals = meals else { return 0 }
        return meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch Meal
        guard let meal = meals?[indexPath.row] else {
            fatalError("Unexpected Index Path")
        }
        
        // Dequeue Reusable Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        
        // Configure Cell
        cell.textLabel?.text = meal.mealName
        cell.detailTextLabel?.text = meal.mealDesc
        //cell.titleLabel.text = note.title
        //cell.contentsLabel.text = note.contents
        //cell.updatedAtLabel.text = updatedAtDateFormatter.string(from: note.updatedAt)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return hasMeals ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }

        //Fetch Meal
        guard let meal = meals?[indexPath.row] else { fatalError("Unexpected Index Path") }
        // Delete Meals
        meal.managedObjectContext?.delete(meal)
        coreDataManager.managedObjectContext.delete(meal)

    }

}

