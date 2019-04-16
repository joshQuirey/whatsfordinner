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
    private var selectedObjectID = NSManagedObjectID()
    
    private var meals: [Meal]? {
        didSet {
            //updateView()
        }
    }
    
    private var hasMeals: Bool {
        guard let meals = meals else { return false }
        return meals.count > 0
    }
    
//    private lazy var fetchedResultsController: NSFetchedResultsController<Meal> = {
//        let fetchRequest: NSFetchRequest<Meal> = Meal.fetchRequest()
//
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Meal.mealName), ascending: true)]
//
//        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.coreDataManager.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
//
//        fetchedResultsController.delegate = self
//
//        return fetchedResultsController
//    }()
    

    
    /////////////////////////////
    //Segues
    /////////////////////////////
    private enum Segue {
        static let AddMeal = "AddMeal"
        static let ViewMeal = "ViewMeal"
    }
    
    
    /////////////////////////////
    //View Life Cycle
    /////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Meals"
        fetchMeals()
        updateView()
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
        
        notificationCenter.addObserver(self,
                                       selector: #selector(saveMeals(_:)),
                                       name: Notification.Name.UIApplicationDidEnterBackground,
                                       object: nil)
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
            
            destination.managedObjectContext = coreDataManager.managedObjectContext
            destination.meal = Meal(context: coreDataManager.managedObjectContext)
//            destination.ticket?.status = ticketStatus.DispatchQueue.rawValue
//            destination.ticket?.startDate = ISO8601DateFormatter.init().string(from: Date())
//            destination.ticket?.sroNumber = "UNPLANNED"
//            destination.ticket?.customerID = "UNPLANNED"
//            destination.ticket?.dispatchDate = String().minimumDateValue
//            destination.ticket?.completeDate = String().minimumDateValue
//            destination.ticket?.submittedDate = String().minimumDateValue
//            destination.ticket?.updateDate = String().minimumDateValue
//            destination.ticket?.manualFlag = true
//            destination.manualFlag = true
            print(destination.meal)
        case Segue.ViewMeal:
            guard let destination = segue.destination as? RecipeViewController else {
                return
            }
            print("destination")
            destination.managedObjectContext = coreDataManager.managedObjectContext
            print("got context")
            let _indexpath = tableView.indexPathForSelectedRow
            let _meal = meals![(_indexpath?.row)!]
            print(_meal)
            destination.meal = _meal
            //destination.meal = fetchRecordsForEntity("Meal", inManagedObjectContext: coreDataManager.managedObjectContext)
            //destination.meal = (coreDataManager.managedObjectContext.object(with: selectedObjectID) as? Meal)!
            print("got object id")
        default:
            break
        }
        
        //look at cocoacasts fetchedResultsController introduction when creating view of meal segue
    }
    
    /////////////////////////////
    //Core Data Functions
    /////////////////////////////
    @objc private func managedObjectContextObjectsDidChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        var mealsDidChange = false
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> {
            print("Context Inserts Exist")
            for insert in inserts {
                if let meal = insert as? Meal {
                    meals?.append(meal)
                    mealsDidChange = true
                }
            }
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> {
            print("Context Updates Exist")
            print(meals)
            for update in updates {
                if update is Meal {
                    mealsDidChange = true
                }
            }
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject> {
            print("Context Deletes Exist")
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
            //Update Section Ticket Lists
            
            //Sort
            //meals?.sorted { $0 > $1 }
            
            //Update Table View
            tableView.reloadData()
            
            //Update View
            updateView()
            mealsDidChange = false
        }
    }
//    @objc private func syncTickets(_ notification: Notification) {
//        syncTickets()
//    }

    @objc private func saveMeals(_ notification: Notification) {
        do {
            try coreDataManager.managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }

    private func fetchMeals() {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Meal> = Meal.fetchRequest()
        
        // Configure Fetch Request
        //let predicate: NSPredicate = NSPredicate(format: "deletedFlag == 0")
        //fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Meal.mealName), ascending: true)]
        
        // Perform Fetch Request
        coreDataManager.managedObjectContext.performAndWait {
            do {
                // Execute Fetch Request
                let meals = try fetchRequest.execute()
                //                print("Tickets Count Total: \(tickets.count)")
                
                // Update Tickets
                self.meals = meals
                
                //Reload Table View
                tableView.reloadData()
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
}

extension MealsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        guard let sections = fetchedResultsController.sections else { return 0 }
//        return sections.count
//
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let section = fetchedResultsController.sections?[section] else { return 0 }
//        return section.numberOfObjects
        
        return (meals?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue Reusable Cell
        //guard let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath) else {
        //    fatalError("Unexpected Index Path")
        //}
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath) as! MealTableViewCell
        
        // Configure Cell
        configure(cell, at: indexPath)
        
        return cell
    }
    
    private func configure(_ cell: MealTableViewCell, at indexPath: IndexPath) {
        // Fetch Meal
        guard let _meal = meals?[indexPath.row] else { fatalError("Unexpected Index Path")}
        
        // Configure Cell
        cell.mealName?.text = _meal.mealName
        cell.mealDescription?.text = _meal.mealDesc
        if (_meal.mealImage != nil) {
            cell.mealImage?.image = UIImage(data: _meal.mealImage!)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        // Fetch Note
        guard let _meal = meals?[indexPath.row] else { fatalError("Unexpected Index Path")}
        
        // Delete Note
        _meal.managedObjectContext?.delete(_meal)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        print("will select row")
        guard let _meal = meals?[(indexPath.row)] else { fatalError("Unexpected Index Path")}
        print(_meal)
        selectedObjectID = _meal.objectID
        
        return indexPath
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
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
                configure(cell as! MealTableViewCell, at: indexPath)
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




