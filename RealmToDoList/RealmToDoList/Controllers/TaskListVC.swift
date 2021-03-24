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
    var notificationToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Clean Realm DB
        // StorageManager.deleteAll()

        // Realm notification
        tasksLists = realm.objects(TasksList.self).sorted(byKeyPath: "name")
        notificationToken = tasksLists.observe { (changes) in
            switch changes {
            case .initial: break
            case .update(_, let deletions, let insertions, let modifications):
                print("\nDeleted indices: ", deletions)
                print("Inserted indices: ", insertions)
                print("Modified modifications: ", modifications, "\n")
                self.tableView.reloadData()
            case .error(let error):
                    fatalError("\(error)")
            }
        }

        // "Edit" - если "isEditing" = "false", "Done" - если "isEditing" = "true"
        navigationItem.leftBarButtonItem = editButtonItem
    }
    /*
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()//обновляем данные, потому что добавляем таску
    }
    */

    @IBAction func editButtonPressed(_ sender: Any) {
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        alerForAddAndUpdateList()
    }
    
    @IBAction func sortingList(_ sender: UISegmentedControl) {
            if sender.selectedSegmentIndex == 0 {
                tasksLists = tasksLists.sorted(byKeyPath: "name")
            } else {
                tasksLists = tasksLists.sorted(byKeyPath: "date")
            }
            tableView.reloadData()
        }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasksLists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListCell", for: indexPath)

        let tasksList = tasksLists[indexPath.row]
        cell.configure(with: tasksList)
        return cell
    }
    // MARK: - Table view delegate

        override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? /* для свайпа  */ {

            let currentList = tasksLists[indexPath.row]

            let deleteContextItem = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
                StorageManager.deleteList(currentList)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }

            let editContextItem = UIContextualAction(style: .normal, title: "Edit") { (_, _, _) in
                self.alerForAddAndUpdateList(currentList, complition: {
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                })
            }

            let doneContextItem = UIContextualAction(style: .normal, title: "Done") { (_, _, _) in
                StorageManager.makeAllDone(currentList)
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }

            editContextItem.backgroundColor = .orange
            doneContextItem.backgroundColor =  #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)

            let swipeActions = UISwipeActionsConfiguration(actions: [deleteContextItem, editContextItem, doneContextItem])

            return swipeActions
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

    private func alerForAddAndUpdateList(_ listName: TasksList? = nil, complition: (() -> Void)? = nil)  /* замыкание, возращает ответ по кнопке save */ {

            let title = listName == nil ? "New List" : "Edit List"
            let message = "Please insert list name"
            let doneButtonName = listName == nil ? "Save" : "Update"

            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            var alertTextField: UITextField!

            let saveAction = UIAlertAction(title: doneButtonName, style: .default) { _ in
                guard let newList = alertTextField.text, !newList.isEmpty else { return }

                if let listName = listName {
                    StorageManager.editList(listName, newListName: newList)
                    if let complition = complition {
                        complition()
                    }
                } else {
                    let tasksList = TasksList()
                    tasksList.name = newList

                    StorageManager.saveTasksList(tasksList)
                    self.tableView.insertRows(at: [IndexPath(row: self.tasksLists.count - 1, section: 0)], with: .automatic) // count начинается с 1, поэтому -1
                }
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

