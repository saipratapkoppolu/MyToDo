//
//  ViewController.swift
//  MyToDo
//
//  Created by KoppoluSaiPratap on 07/01/18.
//  Copyright © 2018 KoppoluSaiPratap. All rights reserved.
//

import UIKit

class MyToDoViewController: UITableViewController {
    
    var itemList = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("MyToDoItems.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }
    
    //MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemList[indexPath.row]
        cell.textLabel?.text = item.itemName
        
        cell.accessoryType = item.state ? .checkmark : .none
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        itemList[indexPath.row].state = !itemList[indexPath.row].state
        saveChanges()
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item()
            newItem.itemName = textField.text!
            self.itemList.append(newItem)
            
            self.saveChanges()
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
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.itemList)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error: \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                self.itemList = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
}

