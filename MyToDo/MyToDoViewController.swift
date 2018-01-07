//
//  ViewController.swift
//  MyToDo
//
//  Created by KoppoluSaiPratap on 07/01/18.
//  Copyright © 2018 KoppoluSaiPratap. All rights reserved.
//

import UIKit

class MyToDoViewController: UITableViewController {
    
    var itemList = ["Eat","Sleep","Repeat"]
    var userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = userDefaults.array(forKey: "ToDoItemList") as? [String] {
            itemList = items
        }
    }
    
    //MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemList[indexPath.row]
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            self.itemList.append(textField.text!)
            self.userDefaults.setValue(self.itemList, forKey: "ToDoItemList")
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

