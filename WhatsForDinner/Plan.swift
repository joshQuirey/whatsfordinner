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
    var startDate: Date
    var plannedDate: Date
    var endDate: Date
    var category: String
    var meal: Meal
    var isCompleted: Bool
    

    init(_start: Date, _planned: Date, _end: Date, _category: String) {
        startDate = _start
        plannedDate = _planned
        endDate = _start.addingTimeInterval(1)
        category = _category
        meal = Meal()
        isCompleted = false
    }
}

//7 day array of date and category
//I will have to contorl the number in the logic
//each day
