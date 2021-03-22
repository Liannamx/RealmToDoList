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

    override func viewDidLoad() {
        super.viewDidLoad()

        title = currentTasksList.name
        filteringTasks()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @IBAction func editButtonPressed(_ sender: Any) {
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
}

extension TasksViewController {

    private func alertForAddAndUpdateList() {
        
        let title = "New Task"
        let doneButton = "Save"

        let alert = UIAlertController(title: title, message: "Please insert task value", preferredStyle: .alert)
        var taskTextField: UITextField!
        var noteTextField: UITextField!

        let saveAction = UIAlertAction(title: doneButton, style: .default) { _ in
            guard let newTask = taskTextField.text , !newTask.isEmpty else { return }
            
                let task = Task()
                task.name = newTask
                
                if let note = noteTextField.text, !note.isEmpty {
                    task.note = note
                }
                
                StorageManager.saveTask(self.currentTasksList, task: task)
                self.filteringTasks()
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
