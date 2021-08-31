//
//  TasksViewController.swift
//  TasksListRealm
//
//  Created by Tatiana Dmitrieva on 30/08/2021.
//

import UIKit
import RealmSwift

class TasksViewController: UITableViewController {
    
    var tasks: Results<Task>!

    override func viewDidLoad() {
        super.viewDidLoad()

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItems = [addButton]
        
        tasks = StorageManager.shared.realm.objects(Task.self)
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tasks.isEmpty ? 0 : tasks.count // если база данных пуста возвращаем 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        let task = tasks[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.name
        cell.contentConfiguration = content

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

   
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        if editingStyle == .delete {
            StorageManager.shared.delete(task: task)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {

        }    
    }
    

    @objc func addButtonPressed() {
        showTaskAlert(with: "Add new task", "", "Save", "Cancel", "Enter task") { text in
            if !text.isEmpty {
                self.saveTask(withName: text)
            }
        }
    }
    
    private func saveTask(withName name: String) {
        let task = Task(value: [name])
        StorageManager.shared.save(task: task)
        let rowIndex = IndexPath(row: tasks.count - 1, section: 0)
        tableView.insertRows(at: [rowIndex], with: .automatic)
    }
   

}
extension TasksViewController {
    
        func showTaskAlert (
                        with title: String,
                        _ message: String,
                        _ actionButtonTitle: String,
                        _ cancelButtonTitle: String,
                        _ placeholder: String,
                        completion: @escaping(String) -> Void) {
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addTextField { textField in
                textField.placeholder = placeholder
            }
            let actionButton = UIAlertAction(title: actionButtonTitle, style: .default) { action in
                completion(alertController.textFields?.first?.text ?? "")
            }
            let cancelButton = UIAlertAction(title: cancelButtonTitle, style: .destructive)
            alertController.addAction(actionButton)
            alertController.addAction(cancelButton)
            present(alertController, animated: true)
        }
}
