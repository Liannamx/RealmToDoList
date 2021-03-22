//
//  Task.swift
//  RealmToDoList
//
//  Created by Olina Maksimova on 22.03.21.
//  сами задачи

import RealmSwift
import Foundation

class Task: Object {
    @objc dynamic var name = ""
    @objc dynamic var note = ""
    @objc dynamic var date = Date() // текущая дата
    @objc dynamic var isComplete = false
}

