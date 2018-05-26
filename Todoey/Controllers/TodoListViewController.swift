//
//  ViewController.swift
//  Todoey
//
//  Created by Brian Silverio on 4/12/18.
//  Copyright © 2018 Brian Silverio. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController{
    
  
    
    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    var titles  = [String]()
    var status  = [Bool]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        
//        print (dataFilePath)
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
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
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            print("itemArray.count = \(itemArray.count)")
            return itemArray.count
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        
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
    
//MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // Watch this space for buttion actions
            print(textField.text!)
            

            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
           
            
//            self.defaults.set(self.itemArray, forKey: "TodoListArrayx")
//            self.storeDefaults()
            self.tableView.reloadData()
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            print("alert text field = \(alertTextField)")
        }
        alert.addAction(action)
        saveItems()
        present(alert, animated: true, completion: nil)
    }

    func saveItems(){
        print("Saving Items")
        
        do {
            try context.save()

            
        } catch {
            print ("Error saving context \(error)")
        }
        
        
    }
    
    func  loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil ) {
//         let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            
        } else {
            request.predicate = categoryPredicate
        }
        
//        let compoundPredicate =  NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate!])
//
//        request.predicate = compoundPredicate
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print ("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }

    
    func storeDefaults(){
    
        titles = []
        status = []
        for count in itemArray{
            titles.append(count.title!)
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

//MARK: - Search Bar methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        print(searchBar.text!)

        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

    
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        loadItems(with: request,predicate: predicate)
    
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

            
        }
    }
    
    
    
}




