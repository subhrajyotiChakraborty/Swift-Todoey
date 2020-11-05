//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Subhrajyoti Chakraborty on 05/11/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].categoryName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTodoItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
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
        let newCategory = Category(context: context)
        newCategory.categoryName = categoryName
        
        categoryArray.append(newCategory)
        
        saveCategory()
    }
    
    func saveCategory() {
        do {
            try context.save()
        } catch {
            print("Unable to save category \(error.localizedDescription)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Unable to load data \(error.localizedDescription)")
        }
        
        tableView.reloadData()
    }
}
