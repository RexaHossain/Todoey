//
//  ViewController.swift
//  Todoey
//
//  Created by Mohammad Rezaul karim on 24/3/19.
//  Copyright © 2019 Mohammad Rezaul karim. All rights reserved.
//


import UIKit


class ToDoListViewController: UITableViewController {
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    var itemArray = [Item]()
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadItems()
        
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            itemArray = items
//        }
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
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        var textFiled = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = textFiled.text!
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            
            
        }
        
       alert.addTextField { (alertTextField) in
        
            alertTextField.placeholder = "Create New Item"
        
        textFiled = alertTextField
        
        }
        
        alert.addAction(action)
        
        present(alert,animated: true,completion: nil)
        
    }
    
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch{
            print("Encoder Error , \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(){
        
        if let data = try?Data(contentsOf: dataFilePath!) {
        
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }
            catch{
                print("Dcoder Error \(error)")
            }
        }
        
    }
    

}


