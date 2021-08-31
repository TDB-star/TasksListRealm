//
//  StorageManager.swift
//  TasksListRealm
//
//  Created by Tatiana Dmitrieva on 30/08/2021.
//

import RealmSwift

class StorageManager {
    
   static let shared = StorageManager()
    
    let realm = try!Realm()
    
    private init() {}
    
    private func write(_ completion: () -> Void) {
        
        do {
            try realm.write {
                completion()
            }
        } catch let error {
            print(error)
        }
    }
    
    func save(task: Task) {
        write {
            realm.add(task)
        }
    }
    
    func delete(task: Task) {
        write {
            realm.delete(task)
        }
    }
}
