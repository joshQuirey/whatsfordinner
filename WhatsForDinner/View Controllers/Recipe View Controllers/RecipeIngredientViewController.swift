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
    @IBOutlet weak var _ingredient: UITextField!
    
    var meal: Meal?
    var ingredient: Ingredient?

    private var ingredients: [Ingredient]? {
        didSet {
            //updateView()
        }
    }
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        print(meal)
        updateView()
    }
    
    func updateView() {
        if meal?.ingredients == nil {
            ingredientTableView.isHidden = true
        } else if meal!.ingredients!.count > 0 {
            ingredientTableView.isHidden = false
            ingredients = meal?.ingredients?.allObjects as? [Ingredient]
            ingredientTableView.reloadData()
        } else {
            ingredientTableView.isHidden = true
        }
    }
//    override func viewWillAppear(_ animated: Bool) {
//        if (ticket != nil) {
//            activityTableView.tableFooterView = UIView(frame: .zero)
//
//            if ticket!.activities!.count > 0 {
//                activities = ticket?.activities?.allObjects as? [Activity]
//                activityTableView.reloadData()
//            } else {
//                activityTableView.isHidden = true
//            }
//        }
//    }
//
    
    override func viewDidAppear(_ animated: Bool) {
        ingredientTableView.reloadData()
    }
    
    /////////////////////////////
    //Actions
    /////////////////////////////
    @IBAction func addIngredient(_ sender: Any) {
        addNewIngredient()
        ingredientTableView.isHidden = false
        ingredients = meal?.ingredients?.allObjects as? [Ingredient]
        ingredientTableView.reloadData()
        _ingredient.text = nil
    }
    
    func addNewIngredient() {
        guard let managedObjectContext = meal?.managedObjectContext else { return }
        
        ingredient = Ingredient(context: managedObjectContext)
        ingredient!.item = _ingredient.text
        meal?.addToIngredients(ingredient!)
//        ingredients.append(ingredient.text!)
        //let lastRow = ingredients.count == 0 ? ingredients.1 : ingredients.count-1
//        let indexPath = IndexPath(row: 0, section: 0)
//        ingredientTableView.beginUpdates()
//        ingredientTableView.insertRows(at: [indexPath], with: .automatic)
//        ingredientTableView.endUpdates()
//
//        ingredient.text = ""
//        view.endEditing(true)
    }
    
    /////////////////////////////
    //Table Functions
    /////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ingredients != nil {
            return ingredients!.count;
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Dequeue Reusable Cell
        let cell = ingredientTableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        //activities?.sort(by: { $0.stepNumber < $1.stepNumber })
        let selectedIngredient = ingredients![indexPath.row]
//        if ingredients!.count == 0{
            cell.textLabel?.text = selectedIngredient.item
//        }
//        else{
//            let myInt =  UInt(selectedActivity.stepNumber)
//            let i = Int(myInt)
//
//            cell.textLabel?.text = "\(String(i)) - \(selectedActivity.condition ?? "") - Item: \(selectedActivity.item ?? "")"
//            cell.detailTextLabel?.text = selectedActivity.descriptionInfo
//            cell.accessoryType = .disclosureIndicator
//        }
        return cell
        
        
        
//        let currentIngredient = ingredients[indexPath.item]
//        let currentCell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
//
//        currentCell.textLabel?.text = currentIngredient
//        return currentCell
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
