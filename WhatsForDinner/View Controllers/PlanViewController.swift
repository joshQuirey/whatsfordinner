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
    //private var coreDataManager = CoreDataManager(modelName: "MealModel")
    @IBOutlet weak var tableView: UITableView!
//    let SectionHeaderHeight: CGFloat = 60


    
    /////////////////////////////
    //Segues
    /////////////////////////////
    private enum Segue {
            static let ViewMeals = "ViewMeals"
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //guard let identifier = segue.identifier else { return }
        
        //switch identifier {
        //case Segue.ViewMeals:
        //    guard let destination = segue.destination as? MealsViewController else {
            //    return
            //}
            
          //  destination.managedObjectContext = coreDataManager.managedObjectContext
        //default:
          //  break
        //}
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

