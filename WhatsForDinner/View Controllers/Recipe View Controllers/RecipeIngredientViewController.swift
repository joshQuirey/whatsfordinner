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
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    var meal: Meal?
    var ingredient: Ingredient?

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    private var ingredients: [Ingredient]? {
        didSet {
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /////////////////////////////
    //View Life Cycle
    /////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        ingredientTableView.delegate = self
        ingredientTableView.dataSource = self
        
        setupNotificationHandling()
        ingredientTableView.keyboardDismissMode = .onDrag
        
        navBar.shadowImage = UIImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateView()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
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
    
    private func setupNotificationHandling() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillShow(_:)),
                                       name: .UIKeyboardWillShow,
                                       object: nil)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillHide(_:)),
                                       name: .UIKeyboardWillHide,
                                       object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        updateBottomConstraint(notification, isShowing: true)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        updateBottomConstraint(notification, isShowing: false)
    }
    
    func updateBottomConstraint(_ notification: Notification, isShowing: Bool) {
        let userInfo = notification.userInfo!
        let keyboardRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let curve = (userInfo[UIKeyboardAnimationCurveUserInfoKey]! as AnyObject).uint32Value
        
        let convertedFrame = view.convert(keyboardRect, from: nil)
        let heightOffset = view.bounds.size.height - convertedFrame.origin.y
        let options = UIViewAnimationOptions(rawValue: UInt(curve!) << 16 | UIViewAnimationOptions.beginFromCurrentState.rawValue)
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue
        
        var pureHeightOffset:CGFloat = heightOffset
        
        if isShowing {
            pureHeightOffset = pureHeightOffset + bottomConstraint.constant //+ view.safeAreaInsets.bottom
        } else {
            pureHeightOffset = 0
        }
        
        bottomConstraint.constant = pureHeightOffset
        print(pureHeightOffset)
        
        UIView.animate(withDuration: duration!, delay: 0, options: options, animations: {
            self.view.layoutIfNeeded()
        }, completion: { bool in })
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
