//
//  MealsViewController.swift
//  WhatsForDinner
//
//  Created by Josh Quirey on 8/6/18.
//  Copyright © 2018 jquirey. All rights reserved.
//

import UIKit
import CoreData

class MealsViewController: UIViewController {
    /////////////////////////////
    //Properties
    /////////////////////////////
    private var coreDataManager = CoreDataManager(modelName: "MealModel")
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyTableLabel: UILabel!
    
    //private var meals: [Meal]? {
    //    didSet {
    //        updateView()
    //    }
    //}
    
    private var hasMeals: Bool {
        //guard let meals = meals else { return false }
        //return meals.count > 0
        
        guard let fetchedObjects = fetchedResultsController.fetchedObjects else { return false }
        return fetchedObjects.count > 0
    }
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Meal> = {
        let fetchRequest: NSFetchRequest<Meal> = Meal.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Meal.mealName), ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.coreDataManager.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
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
        fetchMeals()
        //setupNotificationHandling()
        updateView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //private func setupNotificationHandling() {
    //    let notificationCenter = NotificationCenter.default
    //    notificationCenter.addObserver(self,
    //                                   selector: #selector(managedObjectContextObjectsDidChange(_:)),
    //                                   name: Notification.Name.NSManagedObjectContextObjectsDidChange,
    //                                   object: coreDataManager.managedObjectContext)
   // }

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
        
        //look at cocoacasts fetchedResultsController introduction when creating view of meal segue
    }
    
    
    /////////////////////////////
    //Core Data Functions
    /////////////////////////////
    //@objc private func managedObjectContextObjectsDidChange(_ notification: Notification) {
    //    guard let userInfo = notification.userInfo else { return }
        
        // Helpers
    //    var mealsDidChange = false
        
     //   if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> {
    //        for insert in inserts {
    //            if let meal = insert as? Meal {
    //                meals?.append(meal)
    //                mealsDidChange = true
    //            }
     //       }
     //   }
        
     //   if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> {
     //       for update in updates {
    //            if let _ = update as? Meal {
     //               mealsDidChange = true
     //           }
     //       }
     //   }
        
     //   if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject> {
      //      for delete in deletes {
       //         if let meal = delete as? Meal {
        //            if let index = meals?.index(of: meal) {
         //               meals?.remove(at: index)
          //              mealsDidChange = true
           //         }
            //    }
        //    }
      //  }
        
        //if mealsDidChange {
            // Sort Meals
            //meals?.sorted { $0 > $1 }
            
            // Update Table View
          //  tableView.reloadData()
            
            // Update View
          //  updateView()
       // }
    //}

    private func fetchMeals() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Unable to Perform Fetch Request")
            print("\(error), \(error.localizedDescription)")
        }
    }
    
    /////////////////////////////
    //Table Functions
    /////////////////////////////
}

extension MealsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else { return 0 }
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue Reusable Cell
        //guard let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath) else {
        //    fatalError("Unexpected Index Path")
        //}
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        
        
        // Configure Cell
        configure(cell, at: indexPath)
        
        return cell
    }
    
    private func configure(_ cell: UITableViewCell, at indexPath: IndexPath) {
        // Fetch Note
        let meal = fetchedResultsController.object(at: indexPath)
        
        // Configure Cell
        cell.textLabel?.text = meal.mealName
        cell.detailTextLabel?.text = meal.mealDesc
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        // Fetch Note
        let meal = fetchedResultsController.object(at: indexPath)
        
        // Delete Note
        meal.managedObjectContext?.delete(meal)
    }
    
}

extension MealsViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        updateView()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [ indexPath ], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [ indexPath ], with: .fade)
            }
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) {
                configure(cell, at: indexPath)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [ indexPath ], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        }
    }
}




