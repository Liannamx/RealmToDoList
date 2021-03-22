//
//  TaskListVC.swift
//  RealmToDoList
//
//  Created by Olina Maksimova on 22.03.21.
//
import UIKit
import RealmSwift

class TasksListVC: UITableViewController {

    var tasksLists: Results<TasksList>! // переменная с типом  Results(из Realm выборка) в оторой объекты TaskList

    override func viewDidLoad() {
        super.viewDidLoad()
        tasksLists = realm.objects(TasksList.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()//обновляем данные, потому что добавляем таску
    }

    @IBAction func editButtonPressed(_ sender: Any) {
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        alerForAddAndUpdateList()
    }
    
    @IBAction func sortingList(_ sender: Any) {
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasksLists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListCell", for: indexPath)

        let tasksList = tasksLists[indexPath.row]
        cell.textLabel?.text = tasksList.name
        cell.detailTextLabel?.text = "\(tasksList.tasks.count)"

        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let tasksList = tasksLists[indexPath.row]
            let tasksVC = segue.destination as! TasksViewController
            tasksVC.currentTasksList = tasksList
        }
    }
}

extension TasksListVC {

    private func alerForAddAndUpdateList() {

        let title = "New List"
        let doneButton = "Save"

        let alert = UIAlertController(title: title, message: "Please insert new value", preferredStyle: .alert)
        
        var alertTextField: UITextField!

        let saveAction = UIAlertAction(title: doneButton, style: .default) { _ in
            guard let newList = alertTextField.text, !newList.isEmpty else { return } // проверяем, чтобы значение текста было не пустое и тогда создаем лист 

            let tasksList = TasksList()
            tasksList.name = newList

            StorageManager.saveTasksList(tasksList)
            self.tableView.insertRows(at: [IndexPath(
                                            row: self.tasksLists.count - 1, section: 0)], with: .automatic
            ) // count начинаются с 1, поэтому -1
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)

        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        alert.addTextField { textField in
            alertTextField = textField
            alertTextField.placeholder = "List Name"
        }

        present(alert, animated: true)
    }
}

