//
//  MyToDoCategoryViewController.swift
//  MyToDo
//
//  Created by IBM KSP on 1/8/18.
//  Copyright © 2018 KoppoluSaiPratap. All rights reserved.
//

import UIKit
import CoreData

class MyToDoCategoryViewController: UITableViewController {
    
    var categoryList = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }
    
    //MARK: - Add New Cateogories
    
    @IBAction func addButtonTapped(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.categoryName = textField.text!
            self.categoryList.append(newCategory)
            self.saveChanges()
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
        return categoryList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let category = categoryList[indexPath.row]
        cell.textLabel?.text = category.categoryName
        return cell
    }
    
    // MARK: - Table view delegate 
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! MyToDoViewController
        
        if let index = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryList[index.row]
        }
    }
    
    // MARK: - Data Manipulation Methods
    
    func saveChanges() {
        do {
            try context.save()
        } catch {
            print("Error: \(error)")
        }
        self.tableView.reloadData()
    }

    func loadData() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categoryList = try context.fetch(request)
        } catch {
            print("Error: \(error)")
        }
        self.tableView.reloadData()
    }
}
