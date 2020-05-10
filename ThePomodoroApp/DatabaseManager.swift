//
//  DatabaseManager.swift
//  ThePomodoroApp
//
//  Created by V, Kalaivani V. (623-Extern) on 05/05/20.
//  Copyright © 2020 V, Kalaivani V. (623-Extern). All rights reserved.
//

import SQLite
import Foundation

final class DatabaseManager{
    
    let db: Connection

    static let `default` = try? DatabaseManager()
    let taskRepository: TaskRepository

//    let users = Table("users")
//    let id = Expression<Int64>("id")
//    let name = Expression<String?>("name")

    init() throws {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else{
                throw DatabaseError.CouldNotFindPathToCreateDatabaseFileIn
        }
        print("Database path \(path)")
       db = try Connection("\(path)/db.sqlite3")
        
        taskRepository = try TaskRepository(db: db)
        
    }
    
}

extension DatabaseManager{
    
    enum DatabaseError: Error{
        case CouldNotFindPathToCreateDatabaseFileIn
    }
}
