

import UIKit

class TodoListViewController: UITableViewController{
    
    var itemArray: [TodoItem] = []
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TodoItems.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        loadTodoItems()
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
            self?.submit(item: textInputItem)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(item: String) {
        itemArray.insert(TodoItem(name: item, isChecked: false), at: 0)
        saveChanges()
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func saveChanges() {
        let encoder = PropertyListEncoder()
        do {
           let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Unable to update data \(error)")
        }
    }
    
    func loadTodoItems() {
        guard let data = try? Data(contentsOf: dataFilePath!) else {
            return
        }
        let decoder = PropertyListDecoder()
        do {
            itemArray = try decoder.decode([TodoItem].self, from: data)
        } catch {
            print("Unable to decode \(error)")
        }
    }

}


