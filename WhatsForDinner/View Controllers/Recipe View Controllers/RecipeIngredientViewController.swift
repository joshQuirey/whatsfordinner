//
//  RecipeIngredientViewController.swift
//  WhatsForDinner
//
//  Created by Josh Quirey on 8/25/18.
//  Copyright © 2018 jquirey. All rights reserved.
//

import UIKit

class RecipeIngredientViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    /////////////////////////////
    //Properties
    /////////////////////////////
    @IBOutlet weak var ingredientTableView: UITableView!
    @IBOutlet weak var _ingredient: UITextField!
    
    var meal: Meal?
    var ingredient: Ingredient?

    private var ingredients: [Ingredient]? {
        didSet {
        }
    }
    
    /////////////////////////////
    //View Life Cycle
    /////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        ingredientTableView.delegate = self
        ingredientTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateView()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("\(parent!.view.frame.origin.y) ingredient")
        parent!.view.frame.origin.y = -250
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("\(parent!.view.frame.origin.y) ingredient")
        parent!.view.frame.origin.y = 0
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
    
    override func viewDidAppear(_ animated: Bool) {
        ingredientTableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text != nil && textField.text != "") {
            addNewIngredient()
            ingredientTableView.isHidden = false
            ingredients = meal?.ingredients?.allObjects as? [Ingredient]
            ingredientTableView.reloadData()
            textField.text = nil
        }

        return true
    }
    
    func addNewIngredient() {
        guard let managedObjectContext = meal?.managedObjectContext else { return }
        
        ingredient = Ingredient(context: managedObjectContext)
        ingredient!.item = _ingredient.text
        meal?.addToIngredients(ingredient!)
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
        let cell = ingredientTableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        
        let selectedIngredient = ingredients![indexPath.row]
        cell.textLabel?.text = selectedIngredient.item

        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let deletedIngredient = self.ingredients![indexPath.row]
            self.meal?.removeFromIngredients(deletedIngredient)
            self.ingredients?.remove(at: indexPath.row)
            self.ingredientTableView.reloadData()
            self.updateView()
            success(true)
        })
        
        deleteAction.image = UIImage(named: "delete")
        deleteAction.backgroundColor = UIColor(red: 122/255, green: 00/255, blue: 38/255, alpha: 1.0)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
