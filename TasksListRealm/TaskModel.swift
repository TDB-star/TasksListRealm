//
//  TaskModel.swift
//  TasksListRealm
//
//  Created by Tatiana Dmitrieva on 30/08/2021.
//

import RealmSwift

class Task: Object {

    @objc dynamic var name = ""
    @objc dynamic var date = Date()
    @objc dynamic var isCompleted = false
    
    let tasks = List<Task>()
    
}

