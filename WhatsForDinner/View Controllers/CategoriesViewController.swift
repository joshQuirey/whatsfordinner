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
    
    let categoryData = [String](arrayLiteral: "🥡 Asian Cuisine", " 🥓 Breakfast for Dinner", "🐷 Barbecue", "🐄 Beef", "🥘 Casserole", "🛌 Comfort Food", "🐓 Chicken", "🌾 Grains", "🌮 Hispanic", "🍜 Noodles", "🍝 Pasta", "🍕 Pizza", "🐖 Pork", "🥩 On The Grill", "🍯 Other", "🥗 Salad", "🥪 Sandwich", "🍤 Seafood", "⏲ Slow Cooker", "🥣 Soups Up", "🥕 Vegetarian")

    
//        let categoryData = [String](arrayLiteral: "Asian Cuisine 🥡", "Breakfast for Dinner 🥓", "Barbecue 🐷", "Beef 🐄", "Casserole 🥘", "Comfort Food 🛌", "Chicken 🐓", "Hispanic  🌮", "Pasta 🍝", "Pizza 🍕", "Pork 🐖", "On The Grill 🥩", "Other", "Salad 🥗", "Sandwich 🥪", "Seafood 🍤", "Slow Cooker ⏲", "Soups Up 🍜", "Vegetarian 🥕")
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
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
        return currentCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let currentCategory = categoryData[indexPath.item]
        
        if (meal!.tags != nil) {
            for tag in (meal?.tags)! {
                let _tag = tag as! Tag
                
                if _tag.name! == currentCategory {
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .bottom)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    }
}
