//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Subhrajyoti Chakraborty on 05/11/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].categoryName ?? "No Categories Added Yet"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTodoItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "Add New Category", message: nil, preferredStyle: .alert)
        
        ac.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
        }
        
        let submitAction = UIAlertAction(title: "Add Category", style: .default) { [weak self, weak ac] _ in
            guard let textInput = ac?.textFields?[0].text else { return }
            self?.submit(categoryName: textInput)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(categoryName: String) {
        let newCategory = Category()
        newCategory.categoryName = categoryName
        
        save(category: newCategory)
    }
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Unable to save category \(error.localizedDescription)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    // Delete data by Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryItem = categoryArray?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(categoryItem)
                }
            } catch {
                print("Unable to delete category, \(error.localizedDescription)")
            }
        }
    }
}

