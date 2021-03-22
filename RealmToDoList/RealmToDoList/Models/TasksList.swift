//
//  TasksList.swift
//  RealmToDoList
//
//  Created by Olina Maksimova on 22.03.21.
//  категории с задачами 

import RealmSwift
import Foundation

class TasksList: Object {
    @objc dynamic var name = ""
    @objc dynamic var date = Date() // текущая дата 
    let tasks = List<Task>()
}
