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
        
        var planDidChange = false
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> {
            print("Context Inserts Exist")
            for insert in inserts {
                if let plannedDay = insert as? PlannedDay {
                    plannedDays?.append(plannedDay)
                    planDidChange = true
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
            //meals?.sorted { $0 > $1 }
            
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
        return 1 // (plannedDays?.count)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (plannedDays?.count)!
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return SectionHeaderHeight
//    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if ((plannedDays?.count)! > 0) {
            let date = plannedDays![section].date
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, MMMM d, yyyy"

            return "" //formatter.string(from: date!)
        } else {
            return "No Planned Days"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView.frame.height - 210) / 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "planCell", for: indexPath) as! PlanTableViewCell
        
//        cell.textLabel?.text = "Section \(indexPath.section)"
//        cell.detailTextLabel?.text = "Row \(indexPath.row)"
        
        // Configure Cell
        if (plannedDays!.count > 0) {
            print(plannedDays!.count)
            configure(cell, at: indexPath)
        }
        
        return cell
    }
    
    private func configure(_ cell: PlanTableViewCell, at indexPath: IndexPath) {
        // Fetch Meal
        guard let _plannedDay = plannedDays?[indexPath.row] else { fatalError("Unexpected Index Path")}
        
            // Configure Cell
            cell.mealName?.text = _plannedDay.meal!.mealName
            //cell.mealFrequency?.text = ""
            //cell.mealCategories?.text = _plannedDay.meal!.mealDesc
            if (_plannedDay.meal!.mealImage != nil) {
                cell.mealImage?.image = UIImage(data: _plannedDay.meal!.mealImage!)
            }
        }
}

