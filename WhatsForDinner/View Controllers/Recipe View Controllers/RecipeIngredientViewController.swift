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
        updateView()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("ingredients - textfield did begin editing")
        
        parent!.view.frame.origin.y = -300
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("ingredients - textfield did end editing")
        
        parent!.view.frame.origin.y = 0
    }
    
    
//    private func setupNotificationHandling() {
//        let notificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(self,
//                                       selector: #selector(keyboardWillShow(notification:)),
//                                       name: Notification.Name.UIKeyboardWillShow,
//                                       object: nil)
//
//        notificationCenter.addObserver(self,
//                                       selector: #selector(keyboardWillHide(notification:)),
//                                       name: Notification.Name.UIKeyboardWillHide,
//                                       object: nil)
//
//        //        notificationCenter.addObserver(self,
//        //                                       selector: #selector(keyboardWillHide(notification:)),
//        //                                       name: Notification.Name.UIKeyboardWillChangeFrame,
//        //                                       object: nil)
//    }

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
        if (_ingredient.text != nil && _ingredient.text != "") {
            addNewIngredient()
            ingredientTableView.isHidden = false
            ingredients = meal?.ingredients?.allObjects as? [Ingredient]
            ingredientTableView.reloadData()
            _ingredient.text = nil
        }
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
        //Dequeue Reusable Cell
        let cell = ingredientTableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        //activities?.sort(by: { $0.stepNumber < $1.stepNumber })
        let selectedIngredient = ingredients![indexPath.row]
        cell.textLabel?.text = selectedIngredient.item

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let deletedIngredient = ingredients![indexPath.row]
        meal?.removeFromIngredients(deletedIngredient)
        ingredients?.remove(at: indexPath.row)
        ingredientTableView.reloadData()
        updateView()    
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
