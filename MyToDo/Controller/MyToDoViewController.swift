//
//  ViewController.swift
//  MyToDo
//
//  Created by KoppoluSaiPratap on 07/01/18.
//  Copyright © 2018 KoppoluSaiPratap. All rights reserved.
//

import UIKit
import RealmSwift

class MyToDoViewController: UITableViewController {
    
    var itemList: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    //MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = itemList?[indexPath.row] {
            cell.textLabel?.text = item.itemName
            cell.accessoryType = item.state ? .checkmark : .none
        } else {
            cell.textLabel?.text = "Nop items added yet!"
        }
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = itemList?[indexPath.row] {
            do {
                try realm.write {
                    item.state = !item.state
                }
            } catch {
                print("Error: \(error)")
            }
        }
        self.tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.itemName = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error: \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveChanges() {
        
        do {
            try context.save()
        } catch {
            print("Error: \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems() {
        
        itemList = selectedCategory?.items.sorted(byKeyPath: "itemName", ascending: true)
        self.tableView.reloadData()
    }
    
}

// MARK: - Search bar delegate methods

extension MyToDoViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemList = itemList?.filter(NSPredicate(format: "itemName CONTAINS[cd] %@", searchBar.text!)).sorted(byKeyPath: "dateCreated", ascending: true)
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
}

