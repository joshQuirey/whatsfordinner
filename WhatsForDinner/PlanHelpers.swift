//
//  Plan.swift
//  WhatsForDinner
//
//  Created by Josh Quirey on 4/24/19.
//  Copyright © 2019 jquirey. All rights reserved.
//

import Foundation
import CoreData

class PlanHelpers {

    func getNextMealforCategory(_category: String, _date: Date, _meal: inout Meal) -> Meal? {
        let managedObjectContext = _meal.managedObjectContext
        let fetchRequest: NSFetchRequest<Meal> = Meal.fetchRequest()
        
        //Fetch Meals using Category
        fetchRequest.predicate = NSPredicate(format: "ANY tags.name == %@ AND estimatedNextDate != nil", _category)
        
        //Sort by estimated next date
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Meal.estimatedNextDate), ascending:true)]
        
        //Perform Fetch Request
        managedObjectContext?.performAndWait {
            do {
                //Execute Fetch Request
                let meals = try fetchRequest.execute()
                //Search for Meal
                if (meals.count > 0) {
                    //Reset Previous Meal
//                    _meal.estimatedNextDate = _meal.previousDate
//                    _meal.nextDate = nil
//                    _meal.previousDate = nil
//
//                    //Setup Next Meal
//                    _meal = meals[0]
//                    _meal.previousDate = _meal.estimatedNextDate
//                    _meal.estimatedNextDate = nil
//                    _meal.nextDate = _date
                    _meal = meals[0]
                }
            } catch {
                let fetchError = error as NSError
                print("Unable to Execute Fetch Request")
                print("\(fetchError), \(fetchError.localizedDescription)")
            }
        }
        
        return _meal
    }
    
    func getNextMeal(_date: Date, _meal: inout Meal) -> Meal {
        let managedObjectContext = _meal.managedObjectContext
        let fetchRequest: NSFetchRequest<Meal> = Meal.fetchRequest()
        
        //Fetch Meals using Category
        fetchRequest.predicate = NSPredicate(format: "ANY estimatedNextDate != nil")
        
        //Sort by estimated next date
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Meal.estimatedNextDate), ascending:true)]
        
        //Perform Fetch Request
        managedObjectContext?.performAndWait {
            do {
                //Execute Fetch Request
                let meals = try fetchRequest.execute()
                //Search for Meal
                if (meals.count > 0) {
                    //Reset Previous Meal
                    _meal.estimatedNextDate = _meal.previousDate
                    _meal.nextDate = nil
                    _meal.previousDate = nil
                    
                    //Setup Next Meal
                    _meal = meals[0]
                    _meal.previousDate = _meal.estimatedNextDate
                    _meal.estimatedNextDate = nil
                    _meal.nextDate = _date
                }
            } catch {
                let fetchError = error as NSError
                print("Unable to Execute Fetch Request")
                print("\(fetchError), \(fetchError.localizedDescription)")
            }
        }
        
        return _meal
    }
    
//    func MealAlreadyPlanned(_meals: [Meal], _plannedDate: Date, _plannedMeal: inout Meal) -> Meal {
//        var mealExists: Bool = false
//
//        //check to see if meal is in current plan
//        for _meal in _meals {
//            mealExists = false
//
//            //check if meal is already in current plan
//            for day in weekPlan {
//                //if meal exists already
//                if (_meal.objectID == day?.meal?.objectID) {
//                    //go to next meal in meals
//                    mealExists = true
//                    break
//                }
//            }
//
//            if (!mealExists) {
//                _plannedMeal = _meal
//                _plannedMeal.previousDate = _plannedMeal.estimatedNextDate
//                _plannedMeal.estimatedNextDate = nil
//                _plannedMeal.nextDate = _plannedDate
//
//                break
//            }
//        }
//
//        return _plannedMeal
//    }


//7 day array of date and category
//I will have to contorl the number in the logic
//each day

    
    
}
