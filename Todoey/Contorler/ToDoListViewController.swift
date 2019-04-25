//
//  ViewController.swift
//  Todoey
//
//  Created by Mohammad Rezaul karim on 24/3/19.
//  Copyright © 2019 Mohammad Rezaul karim. All rights reserved.
//


import UIKit
import CoreData


class ToDoListViewController: UITableViewController {
    
    var contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet{
             loadItems()
        }
    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
       
//
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
        
//        contex.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        var textFiled = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.contex)
            newItem.title = textFiled.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
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
        
        do {
            try self.contex.save()
        }
        catch{
            print("Encoder Error , \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest(),predicate: NSPredicate? = nil){

        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@",   selectedCategory!.name!)
        
        if   let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
            
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates:  [categoryPredicate,predicate])
//        request.predicate = compoundPredicate
        
        do{
            itemArray = try contex.fetch(request)
        }
        catch{
            print("fetch request erorr, \(error)")
        }
        tableView.reloadData()
    }
    

}
// search bar functionality

extension ToDoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate  = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors  = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request,predicate: predicate)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}


