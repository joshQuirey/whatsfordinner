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
    
    
    /////////////////////////////
    //View Life Cycle
    /////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        

        //let meal = Meal(context: coreDataManager.managedObjectContext)
        //meal.category
        
        //do {
        //    try coreDataManager.managedObjectContext.save()
        //} catch {
        //    print("Unable to Save Managed Object Context")
        //    print("\(error), \(error.localizedDescription)")
        //}
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
    
}

extension PlanViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return SectionHeaderHeight
//    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Today"
        case 1:
            return "Tomorrow"
        default:
            return "Day \(section+1)"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView.frame.height - 210) / 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "planCell", for: indexPath)
        
        cell.textLabel?.text = "Section \(indexPath.section)"
        cell.detailTextLabel?.text = "Row \(indexPath.row)"
        
        return cell
    }
    
}

