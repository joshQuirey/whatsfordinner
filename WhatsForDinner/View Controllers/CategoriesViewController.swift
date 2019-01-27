//
//  CategoriesViewController.swift
//  WhatsForDinner
//
//  Created by Josh Quirey on 9/11/18.
//  Copyright © 2018 jquirey. All rights reserved.
//

import UIKit
import CoreData

class CategoriesViewController: UIViewController  {
    
    @IBOutlet weak var tableView: UITableView!
    
    var meal: Meal?
    var tag: Tag?
    var selectedTags = NSSet()
    //var managedObjectContext: NSManagedObjectContext?
    
    let categoryData = [String](arrayLiteral: "Asian Cuisine 🥡", "Breakfast for Dinner 🥓", "Barbecue 🐷", "Casserole 🥘", "Comfort Food 🛌", "Chicken 🐓", "Mexican  🌮", "Pasta 🍝", "Pizza 🍕", "Pork 🐖", "On The Grill 🥩", "Other", "Salad 🥗", "Sandwich 🥪", "Seafood 🍤", "Slow Cooker ⏲", "Soups Up 🍜", "Vegetarian 🥕")
    
    
    @IBAction func Cancel(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Save(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(meal!)
        
        
        
    }
    
//    @IBAction func addCategory(_ sender: Any) {
//        print("selected")
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentCategory = categoryData[indexPath.item]
        let currentCell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        currentCell.textLabel?.text = currentCategory
        
        
        //if meal.tags equals currentCategory
//        if currentCategory.contains("Pizza") {
//            currentCell.isSelected = true
//            currentCell.backgroundColor = UIColor.red
//        }
        
        return currentCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let currentCategory = categoryData[indexPath.item]
//        let currentCell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        for tag in (meal?.tags)! {
            let _tag = tag as! Tag
            //            print("Tag \(_tag.name!)")
            //            print("Category \(currentCategory)")
            if _tag.name! == currentCategory {
//                cell.isSelected = true
                cell.setSelected(true, animated: false)
                
//                cell.backgroundColor = UIColor.lightGray
            }
        }
    }
    
    ///TODO: Cannot deselect a category
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(meal!)
        guard let managedObjectContext = meal?.managedObjectContext else { return }

        tag = Tag(context: managedObjectContext)
        tag?.name = categoryData[indexPath.row]
        
        meal?.addToTags(tag!)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let managedObjectContext = meal?.managedObjectContext else { return }
        
        tag = Tag(context: managedObjectContext)
        tag?.name = categoryData[indexPath.row]
        
        for tag in (meal?.tags)! {
            let _tag = tag as! Tag
            if (_tag.name == categoryData[indexPath.row]) {
                meal?.removeFromTags(_tag)
            }
        }
        
        print(meal!)
    }
}
