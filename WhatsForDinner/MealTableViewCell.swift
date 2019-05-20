//
//  MealTableViewCell.swift
//  WhatsForDinner
//
//  Created by Josh Quirey on 4/16/19.
//  Copyright © 2019 jquirey. All rights reserved.
//

import UIKit
import CoreData

class MealTableViewCell: UITableViewCell {

    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var mealFrequency: UILabel!
    @IBOutlet weak var mealCategories: UITextField!
    @IBOutlet weak var mealImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame = newFrame
            frame.origin.y += 8
            frame.size.height -= 2 * 5
            super.frame = frame
        }
    }
}

class PlanTableViewCell: UITableViewCell {
    
    @IBOutlet weak var planDate: UILabel!
    @IBOutlet weak var planMonth: UILabel!
    @IBOutlet weak var planDay: UILabel!
    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var prep: UILabel!
    @IBOutlet weak var cook: UILabel!
    @IBOutlet weak var serve: UILabel!

    @IBOutlet weak var mainCellView: UIView!
    var buttonView: UIView!
    
    @IBAction func expandButton(_ sender: Any) {
        buttonView = UIView()
        mainCellView.addSubview(buttonView)
        buttonView.frame = CGRect(x: 0, y: 0, width: mainCellView.frame.width, height: mainCellView.frame.height)
        buttonView.backgroundColor = .clear
        
        let stack: UIStackView = UIStackView()
        buttonView.addSubview(stack)
        stack.frame = CGRect(x: 0, y: 0, width: buttonView.frame.width, height: buttonView.frame.height)
        stack.alignment = UIStackViewAlignment.fill
        stack.distribution = UIStackViewDistribution.fillEqually
        stack.backgroundColor = .red

        //Replace Button
        let replaceButton: UIButton = UIButton()
        replaceButton.setTitle("Replace", for: .normal)
        replaceButton.addTarget(self, action: #selector(replace), for: .touchUpInside)
        stack.addArrangedSubview(replaceButton)
        
        let blur = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blur)
        blurEffectView.alpha = 0.8
        blurEffectView.frame = self.bounds
        blurEffectView.frame = self.bounds
        blurEffectView.isUserInteractionEnabled = false
        replaceButton.insertSubview(blurEffectView, at: 0)
        
        //Shuffle Button
        let shuffleButton: UIButton = UIButton()
        shuffleButton.setTitle("Shuffle", for: .normal)
        shuffleButton.addTarget(self, action: #selector(shuffle), for: .touchUpInside)
        stack.addArrangedSubview(shuffleButton)
    
        //Cancel Button
        let cancelButton: cellButton = cellButton()
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        stack.addArrangedSubview(cancelButton)
    }
    
    @objc func replace (sender: UIButton!) {
        print(Plan.plannedDays!)
        print(planDay)
        for plan in Plan.plannedDays! {
            if (plan.meal?.mealName == mealName.text) {
                //get index
                let x = Plan.plannedDays?.index(of: plan)
                print(x)
            }
        }
        
        //print(Plan.plannedDays![0].meal?.frequency)
        
    }
    
    @objc func shuffle (sender: UIButton!) {
        for plan in Plan.plannedDays! {
            if (plan.meal?.mealName == mealName.text) {
                //get index
                //let x = Plan.plannedDays?.index(of: plan)
                //print(x)
                
                //check if category is roll the dice or not
                var next = getNextMealforCategory(_plannedCategory: plan.category!, _plannedDate: plan.date!, _plannedMeal: &plan.meal!)
               
                //Get Next Meal
                if (plan.meal?.mealName == next?.mealName) {
                    next = self.getNextMeal(_plannedDate: plan.date!, _plannedMeal: &plan.meal!)
                }
                
                //delete previous meal
                //guard let _meal = _plannedDay.meal else { fatalError("Unexpected Index Path")}
                plan.meal!.estimatedNextDate = plan.meal!.previousDate
                plan.meal!.nextDate = nil
                plan.meal!.previousDate = nil
                
                //set next meal
                plan.meal = next
                plan.meal!.previousDate = plan.meal!.estimatedNextDate
                plan.meal!.estimatedNextDate = nil
                plan.meal!.nextDate = plan.date
                
                plan.meal?.removeFromPlannedDays(plan)
                next?.addToPlannedDays(plan)
                buttonView.removeFromSuperview()
            }
        }
    }
    
    @objc func cancel (sender: UIButton!) {
        buttonView.removeFromSuperview()
    }
    
    
    func getNextMealforCategory(_plannedCategory: String, _plannedDate: Date, _plannedMeal: inout Meal) -> Meal? {
        let fetchRequest: NSFetchRequest<Meal> = Meal.fetchRequest()
        
        //Fetch Meals using Category
        fetchRequest.predicate = NSPredicate(format: "ANY tags.name == %@ AND estimatedNextDate != nil", _plannedCategory)
        
        //Sort by estimated next date
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Meal.estimatedNextDate), ascending:true)]
        
        let managedObjectContext = _plannedMeal.managedObjectContext
        //Perform Fetch Request
        managedObjectContext?.performAndWait {
            do {
                //Execute Fetch Request
                let meals = try fetchRequest.execute()
                //Search for Meal
                if (meals.count > 0) {
                    _plannedMeal = meals[0]
                }
            } catch {
                let fetchError = error as NSError
                print("Unable to Execute Fetch Request")
                print("\(fetchError), \(fetchError.localizedDescription)")
            }
        }
        
        return _plannedMeal
    }
    
    func getNextMeal(_plannedDate: Date, _plannedMeal: inout Meal) -> Meal {
        let fetchRequest: NSFetchRequest<Meal> = Meal.fetchRequest()
        
        //Fetch Meals using Category
        fetchRequest.predicate = NSPredicate(format: "ANY estimatedNextDate != nil")
        
        //Sort by estimated next date
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Meal.estimatedNextDate), ascending:true)]
        
        let managedObjectContext = _plannedMeal.managedObjectContext
        //Perform Fetch Request
        managedObjectContext?.performAndWait {
            do {
                //Execute Fetch Request
                let meals = try fetchRequest.execute()
                //Search for Meal
                _plannedMeal = meals[0]
                
            } catch {
                let fetchError = error as NSError
                print("Unable to Execute Fetch Request")
                print("\(fetchError), \(fetchError.localizedDescription)")
            }
        }
        
        return _plannedMeal
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class cellButton: UIButton {
    var subView: UIView?
}
