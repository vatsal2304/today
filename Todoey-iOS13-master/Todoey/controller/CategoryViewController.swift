//
//  categoryViewController.swift
//  Todoey
//
//  Created by Funnmedia 2 on 22/08/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class categoryViewController: UITableViewController {
    
    let realm = try! Realm()

    var categories : Results<ToDoListCategory>?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.allowsMultipleSelectionDuringEditing = false
        
        loadCategories()
            
    }


    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        
        var TextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "add", style: .default) { (Action) in
            
            
            let newCategory = ToDoListCategory()

            newCategory.name = TextField.text!

            self.saveCategories(category: newCategory)
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            TextField = field
            TextField.placeholder = "add a new catogery"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - tableView datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet"
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] action, view, completionHandler in
            if let item = self?.categories?[indexPath.row] {
                try! self?.realm.write {
                    self?.realm.delete(item)
                }
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    

    // MARK: - tableview delegate methods
    
    
    
    //MARK: - functions
    func saveCategories(category : ToDoListCategory){
        
        do{
            try realm.write{
                realm.add(category)
            }
        }catch{
            print("error in saving is \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories(){
                
        categories = realm.objects(ToDoListCategory.self)
    }
    
    }
