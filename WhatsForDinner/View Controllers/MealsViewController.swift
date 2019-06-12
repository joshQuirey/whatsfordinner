//
//  MealsViewController.swift
//  WhatsForDinner
//
//  Created by Josh Quirey on 8/6/18.
//  Copyright © 2018 jquirey. All rights reserved.
//

import UIKit
import CoreData

class MealsViewController: UIViewController, UISearchDisplayDelegate, UISearchBarDelegate {
    ////////////////////////////
    //Outlets
    ///////////////////////////
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyTableLabel: UILabel!
    
    
    /////////////////////////////
    //Properties
    /////////////////////////////
    var managedObjectContext: NSManagedObjectContext?
    
    private var selectedObjectID = NSManagedObjectID()
    
    private var allMeals: [Meal]? {
        didSet {
            updateView()
        }
    }
    
    var meals: [Meal]?
    
    private var hasMeals: Bool {
        guard let allMeals = meals else { return false }
        return allMeals.count > 0
    }

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
        let tabBar = tabBarController as! BaseTabBarController
        managedObjectContext = tabBar.coreDataManager.managedObjectContext

        fetchMeals()
        updateView()
        setupNotificationHandling()

        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        self.navigationItem.hidesSearchBarWhenScrolling = true
        
        tableView.tableFooterView = UIView()
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        tableView.keyboardDismissMode = .onDrag
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
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
                                       object: self.managedObjectContext)
        
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
        guard let identifier = segue.identifier else {
            return }
        
        switch identifier {
        case Segue.AddMeal:
            guard let destination = segue.destination as? RecipeViewController else {
                return
            }
            
            destination.managedObjectContext = self.managedObjectContext

        case Segue.ViewMeal:
            guard let destination = segue.destination as? RecipeViewController else {
                return
            }
            
            destination.managedObjectContext = self.managedObjectContext
            let _indexpath = tableView.indexPathForSelectedRow
            let _meal = meals![(_indexpath?.row)!]
            destination.meal = _meal
            
        default:
            break
        }
    }
    
    /////////////////////////////
    //Core Data Functions
    /////////////////////////////
    @objc private func managedObjectContextObjectsDidChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        var mealsDidChange = false
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> {
            print("Context Inserts Exist Meals")
            for insert in inserts {
                if let meal = insert as? Meal {
                    meals?.append(meal)
                    self.allMeals = meals
                    mealsDidChange = true
                }
            }
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> {
            print("Context Updates Exist Meals")
            
            for update in updates {
                if update is Meal {
                    mealsDidChange = true
                }
            }
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject> {
            print("Context Deletes Exist Meals")
            for delete in deletes {
                if let meal = delete as? Meal {
                    if let index = meals?.index(of: meal) {
                        meals?.remove(at: index)
                        self.allMeals = meals
                        mealsDidChange = true
                    }
                }
            }
        }
        
        if mealsDidChange {
            //meals?.sorted { $0 > $1 }
            tableView.reloadData()
            updateView()
            mealsDidChange = false
        }
    }

    @objc private func saveMeals(_ notification: Notification) {
        do {
            print("save meals")
            try self.managedObjectContext!.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }

    private func fetchMeals() {
        let fetchRequest: NSFetchRequest<Meal> = Meal.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Meal.mealName), ascending: true)]
        
        self.managedObjectContext!.performAndWait {
            do {
                let meals = try fetchRequest.execute()
                self.meals = meals
                self.allMeals = self.meals
                
                tableView.reloadData()
            } catch {
                let fetchError = error as NSError
                print("Unable to Execute Fetch Request")
                print("\(fetchError), \(fetchError.localizedDescription)")
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            meals = allMeals
            tableView.reloadData()
            return
        }
        
        meals = allMeals!.filter({ Meal -> Bool in
            return (Meal.mealName?.lowercased().contains(searchText.lowercased()))!
        })
        
        tableView.reloadData()
    }
}

/////////////////////////////
//Table Functions
/////////////////////////////
extension MealsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath) as! MealTableViewCell
        
        configure(cell, at: indexPath)
        
        cell.layer.borderWidth = 0
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        return cell
    }
    
    private func configure(_ cell: MealTableViewCell, at indexPath: IndexPath) {
        // Fetch Meal
        guard let _meal = meals?[indexPath.row] else { fatalError("Unexpected Index Path")}
        
        // Configure Cell
        cell.mealName?.text = _meal.mealName
        
        var frequency = ""
        switch _meal.frequency {
        case 7:
            frequency = "Weekly"
        case 14:
            frequency = "Every Other Week"
        case 30:
            frequency = "Monthly"
        case 60:
            frequency = "Every Other Month"
        case 90:
            frequency = "Every Few Months"
        default:
            frequency = "No Preference"
        }
        
        cell.mealFrequency?.text = frequency
        cell.mealCategories?.text = ""
        for _tag in (_meal.tags?.allObjects)! {
            let tag = _tag as! Tag
            cell.mealCategories?.text?.append("\(tag.name!) ")
        }
        
        if (_meal.mealImage != nil) {
            let image: UIImage = UIImage(data: _meal.mealImage!)!
            cell.mealImage?.image = image
            cell.mealImage.layer.cornerRadius = 8 // cell.mealImage.frame.height/2
            cell.mealImage.clipsToBounds = true
        } else {
            cell.mealImage.isHidden = true
        }
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("OK, marked as delete")
            
            DispatchQueue.main.async {
                self.showDeleteWarning(for: indexPath)
            }
            
            success(true)
        })
        
        deleteAction.image = UIImage(named: "delete")
        deleteAction.backgroundColor = UIColor(red: 122/255, green: 00/255, blue: 38/255, alpha: 1.0)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func showDeleteWarning(for indexPath: IndexPath) {
        guard let _meal = self.meals?[indexPath.row] else { fatalError("Unexpected Index Path")}
        
        let alert = UIAlertController(title: "Delete \(_meal.mealName!)", message: "Select Option Below", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction)in
            DispatchQueue.main.async {
                guard let _meal = self.meals?[indexPath.row] else { fatalError("Unexpected Index Path")}
                _meal.managedObjectContext?.delete(_meal)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default , handler:{ (UIAlertAction)in
            self.tableView.reloadData()
        }))
    
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let _meal = meals?[(indexPath.row)] else { fatalError("Unexpected Index Path")}
        selectedObjectID = _meal.objectID
        
        return indexPath
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
