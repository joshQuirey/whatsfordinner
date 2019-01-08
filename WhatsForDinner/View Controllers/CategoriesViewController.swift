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
    
    let categoryData = [String](arrayLiteral: "Asian Cuisine 🥡", "Breakfast for Dinner 🥓", "Barbecue 🐷", "Casserole 🥘", "Comfort Food 🛌", "Chicken 🐓", "Mexican  🌮", "Pasta 🍝", "Pizza 🍕", "Pork 🐖", "On The Grill 🥩", "Other", "Salad 🥗", "Sandwich 🥪", "Seafood 🍤", "Slow Cooker ⏲", "Soups Up 🍜", "Vegetarian 🥕")
    
    
    @IBAction func Cancel(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Save(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    var managedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func addCategory(_ sender: Any) {
        
    }
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
        return currentCell
    }
}
