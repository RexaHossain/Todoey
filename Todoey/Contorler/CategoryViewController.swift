//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mohammad Rezaul karim on 24/4/19.
//  Copyright © 2019 Mohammad Rezaul karim. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

        
    }
    // TableView DataSource Methos
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryIdentifier", for: indexPath)
        
        let item = categoryArray[indexPath.row]
        cell.textLabel?.text = item.name
        
        return cell
    }
    
    //Mark:- Data Manipultaion Methods
    
    func saveCategory (){
        do{
          try  contex.save()
        }
        catch{
            print("Save Categories Error, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories(with request:NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            categoryArray = try contex.fetch(request)
        }
        catch{
            print("Load Categories Eorro,\(error)")
        }
        tableView.reloadData()
    }
    
    
    //Mark:- TableViwe Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Categories", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destiantionVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destiantionVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    
    //Mark:- Add New Categories

    
    @IBAction func BarButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category(context: self.contex)
            newCategory.name = textField.text!
           self.categoryArray.append(newCategory)
            
            self.saveCategory()
        }
        
        alert.addTextField { (alertTextFiled) in
            
            alertTextFiled.placeholder = "Create New Category"
            textField = alertTextFiled
            
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
        
    }
    
}
