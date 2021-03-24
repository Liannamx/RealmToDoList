//
//  TasksViewController.swift
//  RealmToDoList
//
//  Created by Olina Maksimova on 22.03.21.
//

import UIKit
import RealmSwift

class TasksViewController: UITableViewController {

    var currentTasksList: TasksList!

    var currentTasks: Results<Task>!
    var completedTasks: Results<Task>!
    
    private var isEditingMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = currentTasksList.name
        filteringTasks()
    }

    @IBAction func editButtonPressed(_ sender: Any) {
        isEditingMode.toggle() // Переключает значение булевой переменной
        tableView.setEditing(isEditingMode, animated: true)
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        alertForAddAndUpdateList()
    }

    private func filteringTasks() {
        currentTasks = currentTasksList.tasks.filter("isComplete = false")
        completedTasks = currentTasksList.tasks.filter("isComplete = true")
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return section == 0 ? currentTasks.count : completedTasks.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "CURRENT TASKS" : "COMPLETED TASKS"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)

        var task: Task!
        task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]

        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = task.note

        return cell
    }


    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? /* для свайпа  */ {
        
        let task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]
        
        let deleteContextItem = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            StorageManager.deleteTask(task)
            self.filteringTasks()
        }
        
        let editContextItem = UIContextualAction(style: .destructive, title: "Edit") { (_, _, _) in
            self.alertForAddAndUpdateList()
        }

        let doneContextItem = UIContextualAction(style: .destructive, title: "Edit") { (_, _, _) in
            StorageManager.makeDone(task)
            self.filteringTasks()
        }
        
        editContextItem.backgroundColor = .orange
        doneContextItem.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteContextItem,editContextItem,doneContextItem])
        
        return swipeActions
    }
}

extension TasksViewController {

    private func alertForAddAndUpdateList(_ taskName: Task? = nil) {
        
        var title = "New Task"
        let messege = "Please insert task value"
        var doneButton = "Save"
        
        if taskName != nil {
            title = "Edit task"
            doneButton = "Update"
        }

        let alert = UIAlertController(title: title, message: messege, preferredStyle: .alert)
        var taskTextField: UITextField!
        var noteTextField: UITextField!

        let saveAction = UIAlertAction(title: doneButton, style: .default) { _ in
            guard let newTask = taskTextField.text , !newTask.isEmpty else { return }
            
            if let taskName = taskName {
                if let newNote = noteTextField.text, !newNote.isEmpty {
                    StorageManager.editTask(taskName, newTask: newTask, newNote: newNote)
                } else {
                    StorageManager.editTask(taskName, newTask: newTask, newNote: "")
                }
                self.filteringTasks()
            } else {
                let task = Task()
                task.name = newTask
                if let note = noteTextField.text, !note.isEmpty {
                    task.note = note
                }
                StorageManager.saveTask(self.currentTasksList, task: task)
                self.filteringTasks()
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)

        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        alert.addTextField { textField in
            taskTextField = textField
            taskTextField.placeholder = "New task"
        }

        alert.addTextField { textField in
            noteTextField = textField
            noteTextField.placeholder = "Note"
        }

        present(alert, animated: true)
    }
}
