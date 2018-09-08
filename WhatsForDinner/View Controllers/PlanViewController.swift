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
