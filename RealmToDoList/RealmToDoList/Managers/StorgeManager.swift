//
//  StorgeManager.swift
//  RealmToDoList
//
//  Created by Olina Maksimova on 22.03.21.
//  отвечает за запись данных в базу данных

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    // MARK: - Realm Methods for all values
    
    static func deleteAll(){
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    // MARK: - Tasks Lists Methods
    
    static func saveTasksList(_ tasksList: TasksList) {
        try! realm.write {
            realm.add(tasksList)
        }
    }
    
    static func deleteList(_ tasksList: TasksList) {
        try! realm.write {
            let tasks = tasksList.tasks
            // последовательно удаляем tasks и tasksList
            realm.delete(tasks)
            realm.delete(tasksList)
        }
    }
    
    static func editList(_ tasksList: TasksList, newListName: String) {
            try! realm.write {
                tasksList.name = newListName
            }
        }

        static func makeAllDone(_ tasksList: TasksList) {
            try! realm.write {
                tasksList.tasks.setValue(true, forKey: "isComplete")
            }
        }
    
    // MARK: - Tasks Methods
    
    static func saveTask(_ tasksList: TasksList, task: Task) {
        try! realm.write {
            tasksList.tasks.append(task)
        }
    }
    static func editTask(_ task: Task, newTask: String, newNote: String) {
            try! realm.write {
                task.name = newTask
                task.note = newNote
            }
        }

        static func deleteTask(_ task: Task) {
            try! realm.write {
                realm.delete(task)
            }
        }

        static func makeDone(_ task: Task) {
            try! realm.write {
                task.isComplete.toggle()
            }
      }
}

