//
//  ViewController.swift
//  Todoey
//
//  Created by Brian Silverio on 4/12/18.
//  Copyright © 2018 Brian Silverio. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
  
    
    var itemArray = [Item]()
    var titles  = [String]()
    var status  = [Bool]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        
        print (dataFilePath)
        
//        let newItem = Item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Buy Eggos"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item( )
//        newItem3.title = "Destroy Demogorgon"
//        itemArray.append(newItem3)

        loadItems()
        
        
//        if let items = defaults.array(forKey: "TodoListArrayx") as? [Item] {
//            itemArray = items
//        }

//        restoreDefaults()

        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
//        print("cellForRowAt IndexPath \(indexPath.row)")
        
        cell.textLabel?.text = itemArray[indexPath.row].title

        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
//        if itemArray[indexPath.row].done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            print("itemArray.count = \(itemArray.count)")
            return itemArray.count
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
        

        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
//
//        print(tableView.cellForRow(at: indexPath)!)

        saveItems()

        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    
//    @obj func tableViewTapped() {
//
//    }
//
//    func configureTableView() {
//
//    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
    
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // Watch this space for buttion actions
//            print(textField.text!)
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            let encoder = PropertyListEncoder()
            
            do {
                let data = try encoder.encode(self.itemArray)
                try data.write(to: self.dataFilePath!)
                
            } catch {
                print ("Error endoding item array, \(error)")
            }
            
            
//            self.defaults.set(self.itemArray, forKey: "TodoListArrayx")
            self.storeDefaults()
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
//            print(alertTextField)
        }
        alert.addAction(action)
        saveItems()
        present(alert, animated: true, completion: nil)
    }

    func saveItems(){
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to:  dataFilePath!)
            
        } catch {
            print ("Error endoding item array, \(error)")
        }
        
        
    }
    
    func  loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
            itemArray = try decoder.decode([Item].self, from: data)
            } catch{
                print("Error decoding item array \(error)")
            }
        }
    }
    
    
    func storeDefaults(){
        titles = []
        status = []
        for count in itemArray{
            titles.append(count.title)
//            print("count.title = \(count.title)")
//            print("count.done = \(count.done)")
            status.append(count.done)
        }
//        print (status)
//        print (titles)
        defaults.set(titles, forKey: "TodoListArrayTitles")
        defaults.set(status, forKey: "TodoListArrayStatus")
        titles = []
        status = []
    }
    
    func restoreDefaults(){
        titles = []
        status = []
        if let items = defaults.array(forKey: "TodoListArrayTitles") as? [String] {
            titles = items
        }
        if let items = defaults.array(forKey: "TodoListArrayStatus") as? [Bool] {
            status = items
        }
//        print ("titles = \(titles)")
//        print ("status = \(status)")
        var x = 0

        while x < status.count {
            let tempItem = Item()
            tempItem.done = status[x]
            tempItem.title = titles[x]
//            print ("tempItem.title = \(titles[x]) \(tempItem.title), tempItem.done = \(status[x]) \(tempItem.done) x = \(x)")
            itemArray.append(tempItem)
            x = x+1
        }
//        for count in itemArray {
//            print ("itemArray title = \(count.title), itemArray Status = \(count.done)")
//        }
        titles = []
        status = []
    }
    
}





