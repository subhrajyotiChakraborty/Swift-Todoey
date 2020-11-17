

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController{
    
    var itemArray: Results<TodoItem>?
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
            loadTodoItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        //        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.text = item.name
            cell.accessoryType = item.isChecked ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = itemArray?[indexPath.row] {
            do {
                try realm.write {
                    item.isChecked = !item.isChecked
                }
            } catch {
                print("Error saving isChecked, \(error.localizedDescription)")
            }
            
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //            context.delete(itemArray[indexPath.row])
    //            itemArray.remove(at: indexPath.row)
    //            tableView.deleteRows(at: [indexPath], with: .fade)
    //            saveChanges()
    //        }
    //    }
    
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
        if let currentCategory = selectedCategory {
            do {
                try realm.write {
                    let newTodoItem = TodoItem()
                    newTodoItem.name = itemName
                    newTodoItem.dateCreated = Date()
                    currentCategory.todoItems.append(newTodoItem)
                }
            } catch {
                print("error saving context \(error.localizedDescription)")
            }
        }
        
        tableView.reloadData()
    }
    
    func loadTodoItems() {
        
        itemArray = selectedCategory?.todoItems.sorted(byKeyPath: "name", ascending: true)
        
        tableView.reloadData()
    }
}

//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemArray = itemArray?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
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


