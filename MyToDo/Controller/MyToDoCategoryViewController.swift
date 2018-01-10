//
//  MyToDoCategoryViewController.swift
//  MyToDo
//
//  Created by IBM KSP on 1/8/18.
//  Copyright © 2018 KoppoluSaiPratap. All rights reserved.
//

import UIKit
import RealmSwift

class MyToDoCategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoryList: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }
    
    //MARK: - Add New Cateogories
    
    @IBAction func addButtonTapped(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category()
            newCategory.categoryName = textField.text!
            self.saveChanges(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add New Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let category = categoryList?[indexPath.row]
        cell.textLabel?.text = category?.categoryName ?? "No category added yet!" 
        return cell
    }
    
    // MARK: - Table view delegate 
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! MyToDoViewController
        
        if let index = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryList?[index.row]
        }
    }
    
    // MARK: - Data Manipulation Methods
    
    func saveChanges(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error: \(error)")
        }
        self.tableView.reloadData()
    }

    func loadData() {
        categoryList = realm.objects(Category.self)
        self.tableView.reloadData()
    }
}
