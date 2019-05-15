//
//  PlanViewController.swift
//  WhatsForDinner
//
//  Created by Josh Quirey on 8/7/18.
//  Copyright © 2018 jquirey. All rights reserved.
//

import UIKit
import CoreData

class PlanViewController: UIViewController {
    
    /////////////////////////////
    //Properties
    /////////////////////////////
    private var coreDataManager = CoreDataManager(modelName: "MealModel")
    
    @IBOutlet weak var tableView: UITableView!

    private var plannedDays: [PlannedDay]? {
        didSet {
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
        fetchPlans()
        
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
    
    private func setupNotificationHandling() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(managedObjectContextObjectsDidChange(_:)),
                                       name: Notification.Name.NSManagedObjectContextObjectsDidChange,
                                       object: coreDataManager.managedObjectContext)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(savePlans(_:)),
                                       name: Notification.Name.UIApplicationDidEnterBackground,
                                       object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("before")
        print(coreDataManager.managedObjectContext)
        print("after")
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
            
            destination.managedObjectContext = coreDataManager.managedObjectContext
            destination.startingDatePicker.date = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
            
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
                    coreDataManager.managedObjectContext.delete(plannedMeal)
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
            
//            for plan in plannedDays! {
//                print("\(plan.date) - Meal - \(plan.meal!.mealName)")
//            }
            
            //Update Table View
            tableView.reloadData()
            
            //Update View
            //updateView()
            planDidChange = false
        }
    }
    //    @objc private func syncTickets(_ notification: Notification) {
    //        syncTickets()
    //    }
    
    @objc private func savePlans(_ notification: Notification) {
        do {
            print("save Plans")
            try coreDataManager.managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    private func fetchPlans() {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<PlannedDay> = PlannedDay.fetchRequest()
        
        // Configure Fetch Request
       // fetchRequest.predicate = NSPredicate(format: "isCompleted == false")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(PlannedDay.date), ascending: true)]
        
        // Perform Fetch Request
        coreDataManager.managedObjectContext.performAndWait {
            do {
                print("1")
                // Execute Fetch Request
                let plannedDays = try fetchRequest.execute()
                //                print("Tickets Count Total: \(tickets.count)")
                print("2")
                // Update Tickets
                self.plannedDays = plannedDays
                print("3")
                //Reload Table View
                if (self.plannedDays!.count > 0) {
                    tableView.reloadData()
                }
                print("4")
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
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if ((plannedDays?.count)! > 0) {
//            return ""
////            if (section == 0) {
////                return "Today"
////            } else if (section == 1) {
////                return "Tomorrow"
////            } else {
////                let date = plannedDays![section].date
////                let formatter = DateFormatter()
////                formatter.dateFormat = "EEEE" //, MMMM d"
////
////                return formatter.string(from: date!)
////            }
//        } else {
//            return "No Planned Days"
//        }
//    }
    
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        view.tintColor = UIColor(displayP3Red: 244/255, green: 247/255, blue: 245/255, alpha: 1.0)
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //let myLabel = UILabel()
        //myLabel.frame = CGRect(x: 0, y: 0, width: 320, height: 10)
        //myLabel.font = UIFont(name: "SF Pro", size: 8)
        //myLabel.backgroundColor = UIColor.red
        //myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)

        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 10))

        //headerView.addSubview(myLabel)

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
        cell.mealName?.text = _plannedDay.meal!.mealName
        
        cell.prepTime?.text?.append(_plannedDay.meal!.prepTime!)  //.remove(at: (_plannedDay.meal?.prepTime?.index(of: " "))!))
            cell.cookTime?.text?.append(_plannedDay.meal!.cookTime!)
            cell.serves?.text?.append(_plannedDay.meal!.serves!)
        }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        // Fetch Day
        guard let _plannedDay = plannedDays?[indexPath.section] else { fatalError("Unexpected Index Path")}
        //print(_plannedDay)
        //print(_plannedDay.meal?.mealName)
        // Delete Day
        guard let _meal = _plannedDay.meal else { fatalError("Unexpected Index Path")}
        _meal.estimatedNextDate = _meal.previousDate
        _meal.nextDate = nil
        _meal.previousDate = nil
        //Need to roll back the planned date for each of the meals coming up after the meal deleted
        coreDataManager.managedObjectContext.delete(_plannedDay)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        print(indexPath.section)
        
        if (indexPath.section == 0) {
            let completeAction = UIContextualAction(style: .normal, title:  "Complete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                print("OK, marked as Completed")
                
                // Fetch Day
//                guard let _plannedDay = self.plannedDays?[indexPath.section] else { fatalError("Unexpected Index Path")}
//
//                // Delete Day
//                guard let _meal = _plannedDay.meal else { fatalError("Unexpected Index Path")}
//                //TODO
//                _meal.estimatedNextDate = Calendar.current.date(byAdding: .day, value: Int(_meal.frequency), to: _meal.nextDate!)
//                _meal.nextDate = nil
//                _meal.previousDate = Date()
//
//                //Need to roll back the planned date for each of the meals coming up after the meal deleted
//                self.coreDataManager.managedObjectContext.delete(_plannedDay)
//
                success(true)
            })
            completeAction.image = UIImage(named: "tick")
            completeAction.backgroundColor = .purple
            
            return UISwipeActionsConfiguration(actions: [completeAction])
        } else {
            let replaceAction = UIContextualAction(style: .normal, title:  "Replace", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                print("OK, marked as Replace")
                //Implement
                success(true)
            })
            replaceAction.image = UIImage(named: "tick")
            replaceAction.backgroundColor = .blue
            
            let shuffleAction = UIContextualAction(style: .normal, title:  "Shuffle", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                print("OK, marked as Shuffle")
                //Implement
                success(true)
            })
            shuffleAction.image = UIImage(named: "tick")
            shuffleAction.backgroundColor = .green
            
            return UISwipeActionsConfiguration(actions: [replaceAction,shuffleAction])
        }
    }
}

