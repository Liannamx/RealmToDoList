//
//  StorgeManager.swift
//  RealmToDoList
//
//  Created by Olina Maksimova on 22.03.21.
//  отвечает за запись данных в базу данных

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    // MARK: - Tasks Lists Methods
    
    static func saveTasksList(_ tasksList: TasksList) {
        try! realm.write {
            realm.add(tasksList)
        }
    }
    
    // MARK: - Tasks Methods
    
    static func saveTask(_ tasksList: TasksList, task: Task) {
        try! realm.write {
            tasksList.tasks.append(task)
        }
    }
}

