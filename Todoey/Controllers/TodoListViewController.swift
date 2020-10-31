

import UIKit
import CoreData

class TodoListViewController: UITableViewController{
    
    var itemArray = [TodoItem]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
//        loadTodoItems()
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
        itemArray.append(newTodoItem)
        
        saveChanges()
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func saveChanges() {
        do {
            try context.save()
        } catch {
            print("error saving context \(error.localizedDescription)")
        }
    }
    
//    func loadTodoItems() {
//        guard let data = try? Data(contentsOf: dataFilePath!) else {
//            return
//        }
//        let decoder = PropertyListDecoder()
//        do {
//            itemArray = try decoder.decode([TodoItem].self, from: data)
//        } catch {
//            print("Unable to decode \(error)")
//        }
//    }

}


