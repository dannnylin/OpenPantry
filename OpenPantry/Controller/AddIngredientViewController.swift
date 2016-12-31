//
//  AddIngredientViewController.swift
//  OpenPantry
//
//  Created by Danny on 8/20/16.
//  Copyright © 2016 Danny. All rights reserved.
//

import UIKit

class AddIngredientViewController: UIViewController {
    
    var ingredients = [String]() {
        didSet {
            if ingredients.count > 0 {
                tableView.separatorStyle = .SingleLine
                searchEligible = true
            } else {
                searchEligible = false
            }
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var ingredientTextField: UITextField!
    
    var parentSearchViewController: SearchViewController!
    
    var searchEligible: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
        setupStyling()
        
        ingredients = OpenPantryUserDefaults.getLastAddedIngredients()
        
        tableView.registerNib(UINib(nibName: "AddIngredientCell", bundle: nil), forCellReuseIdentifier: "Add-Ingredient-Cell")
        tableView.tableFooterView = UIView()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        ingredientTextField.becomeFirstResponder()
    }
    
    func dismissKeyboard() {
        ingredientTextField.resignFirstResponder()
    }
    
    private func setupStyling() {
        tableView.backgroundColor = UIColor.paperGray()
        tableView.allowsSelection = false
        addButton.backgroundColor = UIColor.indigoBlue()
        addButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        addButton.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        searchButton.backgroundColor = UIColor.bloodRed()
        searchButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        searchButton.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        ingredientTextField.textColor = UIColor.darkGrayColor()
        ingredientTextField.font = UIFont.systemFontOfSize(17)
        
        if ingredients.isEmpty {
            tableView.separatorStyle = .None
        } else {
            tableView.separatorStyle = .SingleLine
        }
    }
    
    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func performSearch(sender: UIButton) {
        if searchEligible {
            OpenPantryUserDefaults.clearLastAddedIngredients()
            var searchQuery = ""
            var currentIngredientIndex = 0
            while currentIngredientIndex < ingredients.count - 1 {
                searchQuery += "\(ingredients[currentIngredientIndex]),"
                currentIngredientIndex += 1
            }
            searchQuery += "\(ingredients[ingredients.count-1])"
            ingredients.removeAll()
            dismiss()
            parentSearchViewController.performIngredientSearch(searchQuery)
        } else {
            let alert = UIAlertController(title: "Failed to search", message: "You must have one or more ingredients added in order to find recipes.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    private func setupNavigationItem() {
        navigationItem.title = "INGREDIENTS"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(dismiss))
    }
    
    class func create() -> AddIngredientViewController {
        let storyboard = UIStoryboard(name: "AddIngredientView", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("AddIngredientViewController") as! AddIngredientViewController
        
        return controller
    }
    
    @IBAction func addIngredient(sender: UIButton) {
        addIfPossible()
    }
    
    private func addIfPossible() {
        guard var ingredient = ingredientTextField.text else {
            fatalError("Can't get text from textfield")
        }
        
        let customCharacterSet = NSMutableCharacterSet()
        customCharacterSet.formUnionWithCharacterSet(NSCharacterSet.letterCharacterSet().invertedSet)
        customCharacterSet.addCharactersInString("-")
        ingredient = ingredient.stringByTrimmingCharactersInSet(customCharacterSet)
        ingredient = ingredient.stringByReplacingOccurrencesOfString("-", withString: " ")
        
        if ingredient.isEmpty {
            print("Empty string, cant do anything...")
            let alert = UIAlertController(title: "Failed to add", message: "That ingredient was unable to be added. Please try again.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        } else {
            ingredients.append(ingredient)
            OpenPantryUserDefaults.setLastAddedIngredients(ingredients)
            tableView.scrollToLastCell()
            ingredientTextField.text = ""
        }
    }
}

extension AddIngredientViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let ingredient = ingredients[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier("Add-Ingredient-Cell") as? AddIngredientCell else {
            fatalError("No identifier found")
        }
        
        cell.ingredientLabel.text = ingredient.capitalizedString
        cell.delegate = self
        cell.index = indexPath.row
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55.0
    }
}

extension AddIngredientViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        addIfPossible()
        return false
    }
}

extension AddIngredientViewController: AddIngredientDelegate {
    func deleteIngredient(index: Int) {
        ingredients.removeAtIndex(index)
        OpenPantryUserDefaults.setLastAddedIngredients(ingredients)
    }
}
