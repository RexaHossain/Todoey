//
//  ViewController.swift
//  Todoey
//
//  Created by Mohammad Rezaul karim on 24/3/19.
//  Copyright © 2019 Mohammad Rezaul karim. All rights reserved.
//


import UIKit


class ToDoListViewController: UITableViewController {
    
    
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        let newItem = Item()
        newItem.title = "Item One"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Item two"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Item three"
        itemArray.append(newItem3)
        
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
            itemArray = items
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    // TableView Datasource Methods
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        
        cell.textLabel?.text = item.title
        
        
        // Ternary Operator
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        
        return cell
    }
    
    //Mark-   TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        var textFiled = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = textFiled.text!
            
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            self.tableView.reloadData()
        }
        
       alert.addTextField { (alertTextField) in
        
            alertTextField.placeholder = "Create New Item"
        
        textFiled = alertTextField
        
        }
        
        alert.addAction(action)
        
        present(alert,animated: true,completion: nil)
        
    }
    

}


