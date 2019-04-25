//
//  Plan.swift
//  WhatsForDinner
//
//  Created by Josh Quirey on 4/24/19.
//  Copyright © 2019 jquirey. All rights reserved.
//

import Foundation
import CoreData

class Plan {
    var plannedDays = [PlanCriteria]?
    var meal: Meal
    
    init() {
        plannedDays = PlanCriteria()
        meal = new Meal()
    }
}

class PlanCriteria {
    var PlannedDate: Date
    var Category: String
    
    init(){
        
    }
    
    init(planned: Date, category: String) {
        PlannedDate = planned
        Category = category
    }
}
