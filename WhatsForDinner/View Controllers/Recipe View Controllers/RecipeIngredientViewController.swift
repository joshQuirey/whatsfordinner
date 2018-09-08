//
//  RecipeIngredientViewController.swift
//  WhatsForDinner
//
//  Created by Josh Quirey on 8/25/18.
//  Copyright © 2018 jquirey. All rights reserved.
//

import UIKit

class RecipeIngredientViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    /////////////////////////////
    //Properties
    /////////////////////////////
    @IBOutlet weak var ingredientTableView: UITableView!
    @IBOutlet weak var ingredient: UITextField!
    var ingredients: [String] = ["test1","test2","test3"]
    
    /////////////////////////////
    //View Life Cycle
    /////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientTableView.tableFooterView = UIView(frame: CGRect.zero)
        // Do any additional setup after loading the view.
        ingredientTableView.delegate = self
        ingredientTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ingredientTableView.reloadData()
    }
    
    /////////////////////////////
    //Actions
    /////////////////////////////
    @IBAction func addIngredient(_ sender: Any) {
        addNewIngredient()
    }
    
    func addNewIngredient() {
        ingredients.append(ingredient.text!)
        //let lastRow = ingredients.count == 0 ? ingredients.1 : ingredients.count-1
        let indexPath = IndexPath(row: 0, section: 0)
        ingredientTableView.beginUpdates()
        ingredientTableView.insertRows(at: [indexPath], with: .automatic)
        ingredientTableView.endUpdates()
        
        ingredient.text = ""
        view.endEditing(true)
    }
    
    /////////////////////////////
    //Table Functions
    /////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentIngredient = ingredients[indexPath.item]
        let currentCell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        
        currentCell.textLabel?.text = currentIngredient
        return currentCell
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
