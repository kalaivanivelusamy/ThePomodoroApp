//
//  TaskRepository.swift
//  ThePomodoroApp
//
//  Created by V, Kalaivani V. (623-Extern) on 05/05/20.
//  Copyright © 2020 V, Kalaivani V. (623-Extern). All rights reserved.
//

import SQLite

final class TaskRepository{
    
    private let db:Connection
    
    static let table = Table(TaskModel.tableName)
    
    static let id = Expression<Int64>("id")
    static let title = Expression<String>("title")
    let tasksTbl = Table("\(TaskModel.tableName)")

    init(db: Connection) throws  {
        self.db = db
        try setUp()
    }
    
    
    //MARK: - Public
    
    //creates a task
     func createTask(title: String) throws -> TaskModel{
        let insert = Self.table.insert(Self.title <- title)
        let rowId = try db.run(insert)
        
        return TaskModel.init(id: rowId,title: title)
    }
    
    //edits task
    func updateTask(title: String, id: Int64) throws -> TaskModel{
        let task = Self.table.filter(Self.id == id)
        if (try db.run(task.update(Self.title <- title)) > 0){
            print("updated rows")
            return TaskModel(id: id, title: title)
        }
        
        return TaskModel(title: title)

    }
    
    //lists task
    func listTasks()  -> [TaskModel] {
       var list = [TaskModel]()
        
        do{
            let _ = try db.prepare(tasksTbl).map{ tasks in
                //return TaskModel(id: tasks[Self.id], title: tasks[Self.title])
               return list.append(TaskModel(id: tasks[Self.id], title: tasks[Self.title]))
            }
        }
        catch{
            print("Could not get list of \(TaskRepository.self) from database")
            return []
        }
        return list
    }
    
    //delete task
    
    func deleteTask(taskId: Int64) throws {
        let task = tasksTbl.filter(Self.id == taskId)
        do {
            if try db.run(task.delete()) > 0 {
                print("deleted task")
            } else {
                print("task not found")
            }
        } catch {
            print("delete failed: \(error)")
        }

        
    }
    
    
    //MARK: - Private
    
    private func setUp() throws{
        
        try db.run(Self.table.create(ifNotExists: true){ table in
        table.column(Self.id,primaryKey: true)
        table.column(Self.title)
        })
        
        print("created table (if it did not exist) \(TaskModel.tableName)")

    }
    
    

}
