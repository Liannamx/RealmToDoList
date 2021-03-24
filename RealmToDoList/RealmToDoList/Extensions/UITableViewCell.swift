//
//  UITableViewCell.swift
//  RealmToDoList
//
//  Created by Olina Maksimova on 24.03.21.
//

import UIKit

extension UITableViewCell {
    func configure(with tasksList: TasksList) {
            let currentTasks = tasksList.tasks.filter("isComplete = false")
            let completedTasks = tasksList.tasks.filter("isComplete = true")

            textLabel?.text = tasksList.name

            if !currentTasks.isEmpty {
                detailTextLabel?.text = "\(currentTasks.count)"
                detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
                detailTextLabel?.textColor = #colorLiteral(red: 0.5459541678, green: 0.540940702, blue: 0.5453407168, alpha: 1)
            } else if !completedTasks.isEmpty {
                detailTextLabel?.text = "✓"
                detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 24)
                detailTextLabel?.textColor =  #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            } else {
                detailTextLabel?.text = "0"
            }
        }
}
