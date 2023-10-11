//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    
    let realm = try! Realm()
    
    var toDoItems : Results<ItemEntity>?
    
    var selectedCategory : ToDoListCategory?{
        didSet{
            loadItems()
        }
    }
    
    //    let dataFilePath = FileManager.default.urls(for: .documentDirectory , in: .userDomainMask)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    
    // MARK: - adding item to the table view
    @IBAction func addButtonClicked(_ sender: UIBarButtonItem ) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "add new todoey item", message: "", preferredStyle: .alert)
        
        let action =  UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            do{
                if let currentCategory = self.selectedCategory{
                    try self.realm.write{
                        let newItem = ItemEntity()
                        
                        newItem.title = textField.text!
                        
                        newItem.dateCreated = Date()
                        
                        currentCategory.itemss.append(newItem)
                    }
                }
            }catch{
                print("error saving new items, \(error )")
            }
            
            self.tableView.reloadData()
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "add new items"
        }
        
//        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
//                UIAlertAction in
//                NSLog("Cancel Pressed")
//            }
//
//        alert.addAction(cancelAction)
//        present(alert, animated: true, completion: nil)
        

        
        
    } //add button clicked closure
    
    
    
    // MARK: - tableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = toDoItems?[indexPath.row]{
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
            
        }else{
            
            cell.textLabel?.text = "No Items added"
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do{
                try realm.write {
                    item.done = !item.done
                    //                    realm.delete(item)
                }
            }catch{
                print("error saving done status \(error)")
            }
        }
        
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    } 
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] action, view, completionHandler in
            if let item = self?.toDoItems?[indexPath.row] {
                try! self?.realm.write {
                    self?.realm.delete(item)
                }
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    
    // MARK: - functions
    func loadItems(){
        
        toDoItems = selectedCategory?.itemss.sorted(byKeyPath: "dateCreated" , ascending: true)
        
    }
}


extension ToDoListViewController: UISearchBarDelegate{
    //
    //    // MARK: search for the item
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title" , ascending: true)

        
        tableView.reloadData()
    }
    //
    //    // MARK: click the cross for getting back to home screen
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

