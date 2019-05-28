//
//  TabBarController.swift
//  WhatsForDinner
//
//  Created by Josh Quirey on 5/28/19.
//  Copyright © 2019 jquirey. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    public var coreDataManager = CoreDataManager(modelName: "MealModel")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
