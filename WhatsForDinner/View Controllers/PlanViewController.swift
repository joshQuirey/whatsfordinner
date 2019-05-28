//
//  PlanViewController.swift
//  WhatsForDinner
//
//  Created by Josh Quirey on 8/7/18.
//  Copyright © 2018 jquirey. All rights reserved.
//

import UIKit
import CoreData


struct MyVariables {
    static var test = "strings"
}

class PlanViewController: UIViewController {
    
    /////////////////////////////
    //Properties
    /////////////////////////////
    //private var coreDataManager = CoreDataManager(modelName: "MealModel")
    //var coreDataManager = CoreDataManager?.self
        var managedObjectContext: NSManagedObjectContext?
    private var currentIndex: Int?
    
    @IBOutlet weak var tableView: UITableView!
    
    var plannedDays: [PlannedDay]? {
        didSet {
            //Plan.plannedDays = plannedDays
            //updateView()
        }
    }
    
    private var hasPlans: Bool {
        guard let plannedDays = plannedDays else { return false }
        return plannedDays.count > 0
    }
    
    /////////////////////////////
    //Segues
    /////////////////////////////
    private enum Segue {
        static let CreatePlan = "CreatePlan"
        static let ViewPlannedMeal = "ViewPlannedMeal"
        static let ReplacePlannedMeal = "ReplacePlannedMeal"
    }
    
    private func updateView() {
        tableView.isHidden = !hasPlans
        //emptyTableLabel.isHidden = hasMeals
    }
    
    /////////////////////////////
    //View Life Cycle
    /////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBar = tabBarController as! BaseTabBarController
        managedObjectContext = tabBar.coreDataManager.managedObjectContext
        //fetchPlans()
        
        //updateView()
        setupNotificationHandling()
        //let meal = Meal(context: coreDataManager.managedObjectContext)
        //meal.category
        
        //do {
        //    try coreDataManager.managedObjectContext.save()
        //} catch {
        //    print("Unable to Save Managed Object Context")
        //    print("\(error), \(error.localizedDescription)")
        //}
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        do {
            try self.managedObjectContext!.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    private func setupNotificationHandling() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(managedObjectContextObjectsDidChange(_:)),
                                       name: Notification.Name.NSManagedObjectContextObjectsDidChange,
                                       object: self.managedObjectContext)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(savePlans(_:)),
                                       name: Notification.Name.UIApplicationDidEnterBackground,
                                       object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchPlans()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case Segue.CreatePlan:
            guard let destination = segue.destination as? CreatePlanViewController else {
                return
            }
//            let formatter = DateFormatter()
//            formatter.dateFormat = "EEEE, MMMM d, yyyy"
            
            destination.managedObjectContext = self.managedObjectContext
            
            //Determine Plan Starting Date
            var startDate = Date()
            if (plannedDays!.count > 0) {
                startDate = (plannedDays?.last?.date)!
            }
            
            destination.startingDatePicker.date = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
            
        case Segue.ViewPlannedMeal:
            guard let destination = segue.destination as? RecipeViewController else {
                return
            }
            
            destination.managedObjectContext = self.managedObjectContext
            let _indexpath = tableView.indexPathForSelectedRow
            let _meal = plannedDays![(_indexpath!.section)].meal
            destination.meal = _meal
        
        case Segue.ReplacePlannedMeal:
            guard let destination = segue.destination as? ReplaceMealController else {
                return
            }
            
            destination.managedObjectContext = self.managedObjectContext
            //let _indexpath = tableView.inde
            destination.currentPlannedDay = plannedDays![(self.currentIndex!)]
//            destination.meal = _meal
        default:
            break
        }
    }
    
    
    /////////////////////////////
    //Core Data Functions
    /////////////////////////////
    @objc private func managedObjectContextObjectsDidChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        var planDidChange = false
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> {
            print("Context Inserts Exist")
            for insert in inserts {
                if let plannedDay = insert as? PlannedDay {
                    print(plannedDay)
                    plannedDays?.append(plannedDay)
                    planDidChange = true
                }
                
                if let plannedMeal = insert as? Meal {
                    print(plannedMeal)
                    self.managedObjectContext!.delete(plannedMeal)
                }
            }
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> {
            print("Context Updates Exist")
            //print(meals)
            for update in updates {
                if update is PlannedDay {
                    planDidChange = true
                }
                
                if update is Meal {
                    planDidChange = true
                }
            }
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject> {
            print("Context Deletes Exist")
            for delete in deletes {
                if let plannedDay = delete as? PlannedDay {
                    if let index = plannedDays?.index(of: plannedDay) {
                        plannedDays?.remove(at: index)
                        planDidChange = true
                    }
                }
            }
        }
        
        if planDidChange {
            //Update Section Ticket Lists
            
            //Sort
//            for plan in plannedDays! {
//                print("\(plan.date) - Meal - \(plan.meal!.mealName)")
//            }
            
            plannedDays = plannedDays?.sorted(by: { $0.date!.compare($1.date!) == .orderedAscending })
            
            //Update Table View
            tableView.reloadData()
            
            //Update View
            //updateView()
            planDidChange = false
        }
    }
    
    @objc private func savePlans(_ notification: Notification) {
        do {
            try self.managedObjectContext!.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    private func fetchPlans() {
        // Create Fetch Request
        plannedDays = nil
        let fetchRequest: NSFetchRequest<PlannedDay> = PlannedDay.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.predicate = NSPredicate(format: "isCompleted == nil")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(PlannedDay.date), ascending: true)]
        
        // Perform Fetch Request
        self.managedObjectContext!.performAndWait {
            do {
                // Execute Fetch Request
                plannedDays = try fetchRequest.execute()
                
                // Update Tickets
                //self.plannedDays = plannedDays
                //Plan.plannedDays = plannedDays
                
                //Reload Table View
                if (plannedDays!.count > 0) {
                    tableView.reloadData()
                }
            } catch {
                let fetchError = error as NSError
                print("Unable to Execute Fetch Request")
                print("\(fetchError), \(fetchError.localizedDescription)")
            }
        }
    }
}

extension PlanViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (plannedDays?.count)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 10))

        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "planCell", for: indexPath) as! PlanTableViewCell
        
        // Configure Cell
        if (plannedDays!.count > 0) {
            configure(cell, at: indexPath)
        }
        
        cell.layer.borderWidth = 0
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        return cell
    }
    
    private func configure(_ cell: PlanTableViewCell, at indexPath: IndexPath) {
        // Fetch Meal
        guard let _plannedDay = plannedDays?[indexPath.section] else { fatalError("Unexpected Index Path")}
        
            // Configure Cell
            let date = plannedDays![indexPath.section].date
            let formatter = DateFormatter()
            formatter.dateFormat = "d"
            cell.planDate.text = formatter.string(from: date!)
        
            formatter.dateFormat = "MMM"
            cell.planMonth.text = formatter.string(from: date!)
        
            formatter.dateFormat = "EEE"
            cell.planDay.text = formatter.string(from: date!)
        
            if (_plannedDay.meal!.mealImage != nil) {
                cell.mealImage?.image = UIImage(data: _plannedDay.meal!.mealImage!)
            }
        
//            formatter.dateFormat = "EEE MMM d"
            cell.mealName?.text = _plannedDay.meal!.mealName //"\(formatter.string(from: _plannedDay.meal!.nextDate!))  \()"
        
            cell.mealCategories?.text = ""
            for _tag in (_plannedDay.meal!.tags?.allObjects)! {
                let tag = _tag as! Tag
                cell.mealCategories?.text?.append("\(tag.name!) ")
            }
        
            if (_plannedDay.meal!.prepTime! != nil && _plannedDay.meal!.prepTime! != "") {
                cell.prep?.text? = "Plan: \(_plannedDay.meal!.prepTime!)"
            } else {
                cell.prep?.text? = " "
            }
        
            if (_plannedDay.meal!.cookTime != nil && _plannedDay.meal!.cookTime! != "") {
                cell.cook?.text? = "Cook: \(_plannedDay.meal!.cookTime!)"
            } else {
                cell.cook?.text? = " "
        }
            //cell.serve?.text? = "Serves-\(_plannedDay.meal!.serves!)"
        }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        // Fetch Day
        guard let _plannedDay = plannedDays?[indexPath.section] else { fatalError("Unexpected Index Path") }
        //print(_plannedDay)
        //print(_plannedDay.meal?.mealName)
        // Delete Day
        guard let _meal = _plannedDay.meal else { fatalError("Unexpected Index Path")}
        _meal.estimatedNextDate = _meal.previousDate
        _meal.nextDate = nil
        _meal.previousDate = nil
        //Need to roll back the planned date for each of the meals coming up after the meal deleted
        self.managedObjectContext!.delete(_plannedDay)
        
        //Update the dates for remaining planned days to be a day earlier
        print(indexPath.section)
        var i = indexPath.section + 1
        print(i)
        print(plannedDays!.count)
        while (i < plannedDays!.count) {
            plannedDays?[i].date = Calendar.current.date(byAdding: .day, value: -1, to: (plannedDays?[i].date)!)
//            print("Planned Date \(plannedDays?[i].date)")
            
//            print("Planned End Date \(plannedDays?[i].planEndDate)")
            plannedDays?[i].planEndDate = Calendar.current.date(byAdding: .day, value: -1, to: (plannedDays?[i].planEndDate)!)
//            print("Planned End Date \(plannedDays?[i].planEndDate)")
            
            guard let _nextMeal = plannedDays?[i].meal else { fatalError("Unexpected Index Path") }
//            print("Next Date \(_nextMeal.nextDate)")
            _nextMeal.nextDate = Calendar.current.date(byAdding: .day, value: -1, to: _nextMeal.nextDate!)
//            print("Next Date \(_nextMeal.nextDate)")
            
            i += 1
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        print(indexPath.section)
  
//COMPLETE
        let completeAction = UIContextualAction(style: .normal, title:  "Complete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("OK, marked as Completed")
            
            // Fetch Day
            guard let _plannedDay = self.plannedDays?[indexPath.section] else { fatalError("Unexpected Index Path")}
            guard let _meal = _plannedDay.meal else { fatalError("Unexpected Index Path")}
    
            _meal.estimatedNextDate = Calendar.current.date(byAdding: .day, value: Int(_meal.frequency), to: _meal.nextDate!)

            _meal.nextDate = nil
            _meal.previousDate = nil
            _plannedDay.isCompleted = true

            self.managedObjectContext!.delete(_plannedDay)
            
            success(true)
        })
        completeAction.image = UIImage(named: "tick")
        completeAction.backgroundColor = .purple
    
//REPLACE
        let replaceAction = UIContextualAction(style: .normal, title:  "Replace", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("OK, marked as Replace")
            //Implement
            self.currentIndex = indexPath.section
            self.performSegue(withIdentifier: "ReplacePlannedMeal", sender: tableView)
            
            success(true)
        })
        replaceAction.image = UIImage(named: "tick")
        replaceAction.backgroundColor = .blue

//SHUFFLE
        let shuffleAction = UIContextualAction(style: .normal, title:  "Shuffle", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("OK, marked as Shuffle")
            //Implement
            // Fetch Day
            guard let _plannedDay = self.plannedDays?[indexPath.section] else { fatalError("Unexpected Index Path")}
            //Fetch Meal
            guard let _meal = _plannedDay.meal else { fatalError("Unexpected Index Path")}
            
            //Get next meal for current planned category
            var next = Meal(context: self.managedObjectContext!)
            next = self.getNextMealforCategory(_category: _plannedDay.category!, _date: _plannedDay.date!, _nextMeal: &next)!
            
            //If No Meal returned, just get the next meal regardless of category
            if (next.mealName == nil) {
                next = self.getNextMeal(_date: _plannedDay.date!, _nextMeal: &next)
            }
            
            //print(next.mealName)
            //If No Meal could be found then make no change
            if (_meal.mealName != next.mealName) {
                //delete previous meal
                _meal.estimatedNextDate = _meal.previousDate
                _meal.nextDate = nil
                _meal.previousDate = nil
                _meal.removeFromPlannedDays(_plannedDay)
                
                //add next meal
                next.previousDate = next.estimatedNextDate
                next.estimatedNextDate = nil
                next.nextDate = _plannedDay.date
                next.addToPlannedDays(_plannedDay)
            }
            
            success(true)
        })
        shuffleAction.image = UIImage(named: "tick")
        shuffleAction.backgroundColor = .green

        return UISwipeActionsConfiguration(actions: [completeAction,replaceAction,shuffleAction])
    }
    
    
    func getNextMealforCategory(_category: String, _date: Date, _nextMeal: inout Meal) -> Meal? {
        let fetchRequest: NSFetchRequest<Meal> = Meal.fetchRequest()
        
        //Fetch Meals using Category
        fetchRequest.predicate = NSPredicate(format: "ANY tags.name == %@ AND estimatedNextDate != nil", _category)
        
        //Sort by estimated next date
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Meal.estimatedNextDate), ascending:true)]
        
        //Perform Fetch Request
        self.managedObjectContext!.performAndWait {
            do {
                //Execute Fetch Request
                let meals = try fetchRequest.execute()
                //Search for Meal
                if (meals.count > 0) {
                    _nextMeal = meals[0]
                }
            } catch {
                let fetchError = error as NSError
                print("Unable to Execute Fetch Request of Get Next Meal for Category")
                print("\(fetchError), \(fetchError.localizedDescription)")
            }
        }
        
        return _nextMeal
    }
    
    func getNextMeal(_date: Date, _nextMeal: inout Meal) -> Meal {
        let fetchRequest: NSFetchRequest<Meal> = Meal.fetchRequest()
        
        //Fetch Meals using Category
        fetchRequest.predicate = NSPredicate(format: "estimatedNextDate != nil")
        
        //Sort by estimated next date
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Meal.estimatedNextDate), ascending:true)]
        
        //Perform Fetch Request
        self.managedObjectContext!.performAndWait {
            do {
                //Execute Fetch Request
                let meals = try fetchRequest.execute()
                //Search for Meal
                if (meals.count > 0) {
                    _nextMeal = meals[0]
                }
            } catch {
                let fetchError = error as NSError
                print("Unable to Execute Fetch Request of Get Next Meal")
                print("\(fetchError), \(fetchError.localizedDescription)")
            }
        }
        
        return _nextMeal
    }
}





//@objc func replace (sender: UIButton!) {
//    print(Plan.plannedDays!)
//    print(planDay)
//    for plan in Plan.plannedDays! {
//        if (plan.meal?.mealName == mealName.text) {
//            //get index
//            let x = Plan.plannedDays?.index(of: plan)
//            print(x)
//        }
//    }
//}





//Update the dates for remaining planned days to be a day earlier
//                print(indexPath.section)
//                var i = indexPath.section + 1
//                print(i)
//                print(plannedDays!.count)
//                while (i < plannedDays!.count) {
//                    //            print("Planned Date \(plannedDays?[i].date)")
//                    plannedDays?[i].date = Calendar.current.date(byAdding: .day, value: -1, to: (plannedDays?[i].date)!)
//                    //            print("Planned Date \(plannedDays?[i].date)")
//
//                    //            print("Planned End Date \(plannedDays?[i].planEndDate)")
//                    plannedDays?[i].planEndDate = Calendar.current.date(byAdding: .day, value: -1, to: (plannedDays?[i].planEndDate)!)
//                    //            print("Planned End Date \(plannedDays?[i].planEndDate)")
//
//                    guard let _nextMeal = plannedDays?[i].meal else { fatalError("Unexpected Index Path") }
//                    //            print("Next Date \(_nextMeal.nextDate)")
//                    _nextMeal.nextDate = Calendar.current.date(byAdding: .day, value: -1, to: _nextMeal.nextDate!)
//                    //            print("Next Date \(_nextMeal.nextDate)")
//
//                    i += 1
//                }
