//
//   CategoryViewController.swift
//  Todoey
//
//  Created by Brian Silverio on 5/14/18.
//  Copyright © 2018 Brian Silverio. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//    var categories = [Category]()

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Categories.plist")
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

//        let newCategory = Category()
//        newCategory.name = "Bippety"
//        categoryArray.append(newCategory)
//
//        let newCategory2 = Category()
//        newCategory2.name = "Boppity"
//        categoryArray.append(newCategory2)
//
//        let newCategory3 = Category( )
//        newCategory3.name = "Boo"
//        categoryArray.append(newCategory3)
        
        loadCategories()
        
        
        
        
        
        
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
        
        
    }
    
    
    
    
    //MARK: - Data Manipulation Methods
    
    func saveCategories(){
        print ("Saving Categories")
        
        do {
            try context.save()
        } catch {
            print("Error saving categories \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategories(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
        tableView.reloadData()
    }
    
    
    //MARK: - Add New Categories


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
        print (textField.text!)
        
        let newCategory = Category(context: self.context)
        newCategory.name = textField.text!
        
        self.categoryArray.append(newCategory)
        self.tableView.reloadData()
        self.saveCategories()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
            print("Alert text field = \(alertTextField)")
        }
        alert.addAction(action)
        saveCategories()
        present(alert, animated: true, completion: nil)
    
    }

    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self )
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
            
        }
    }




}
