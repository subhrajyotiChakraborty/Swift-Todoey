

import UIKit
import CoreData

class TodoListViewController: UITableViewController{
    
    var itemArray = [TodoItem]()
    
    var selectedCategory: Category? {
        didSet {
            loadTodoItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
//        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem?.tintColor = .white
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].name
        cell.accessoryType = itemArray[indexPath.row].isChecked ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if itemArray[indexPath.row].isChecked {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        itemArray[indexPath.row].isChecked.toggle()
        saveChanges()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(itemArray[indexPath.row])
            itemArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveChanges()
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    @objc func addTapped() {
        let ac = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        ac.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
        }
        
        let submitAction = UIAlertAction(title: "Add Item", style: .default) { [weak self, weak ac] _ in
            guard let textInputItem = ac?.textFields?[0].text else { return }
            self?.submit(itemName: textInputItem)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(itemName: String) {
        
        let newTodoItem = TodoItem(context: context)
        newTodoItem.name = itemName
        newTodoItem.isChecked = false
        newTodoItem.parentCategory = selectedCategory
        
        itemArray.append(newTodoItem)
        
        saveChanges()
    }
    
    func saveChanges() {
        do {
            try context.save()
        } catch {
            print("error saving context \(error.localizedDescription)")
        }
        
        tableView.reloadData()
    }
    
    func loadTodoItems(with request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.categoryName MATCHES %@", selectedCategory!.categoryName!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Unable to fetch data \(error.localizedDescription)")
        }
        
        tableView.reloadData()
    }
}

//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        loadTodoItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadTodoItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}


