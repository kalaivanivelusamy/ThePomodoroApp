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
    static let status = Expression<String>("status")
    static let date = Expression<String>("date")
    let tasksTbl = Table("\(TaskModel.tableName)")

    init(db: Connection) throws  {
        self.db = db
        try setUp()
    }
    
    static func dropTable(in db:Connection) throws{
       
        try db.execute("DROP table if exists \(TaskModel.tableName)")
            
        print("table dropped:\(TaskModel.tableName)")
    }
    
    //MARK: - Private
    
    private func setUp() throws{
        
        try db.run(Self.table.create(ifNotExists: true){ table in
        table.column(Self.id,primaryKey: true)
        table.column(Self.title)
        table.column(Self.status)
        table.column(Self.date)
            
        })
        
        print("created table (if it did not exist) \(TaskModel.tableName)")

    }
    
    //MARK: - Public
    
    //creates a task
    func createTask(title: String,date: String,sTatus: String = TaskStatus.NotDone.rawValue) throws -> TaskModel{
        let insert = Self.table.insert(Self.title <- title,Self.status <- sTatus,Self.date <- date)
        let rowId = try db.run(insert)
        
        return TaskModel.init(id: rowId,title: title,status: TaskStatus(rawValue: sTatus)!)
    }
    
    //edits task
    func updateTask(title: String, id: Int64,status:TaskStatus) throws -> TaskModel{
        let task = Self.table.filter(Self.id == id)
        if (try db.run(task.update(Self.title <- title,Self.status <- status.rawValue)) > 0){
            print("updated rows")
            return TaskModel(id: id, title: title,status: status)
        }
        
        return TaskModel(title: title,status: status)

    }
    
    //lists task
    func listTasks(filterByDate: String,byStatus: FilterBy)  -> [TaskModel] {
       var list = [TaskModel]()
        var query = tasksTbl
        
//        if !filterByDate.isEmpty{
//            query = tasksTbl.filter(Self.date .like(filterByDate))
//        }
//
//        else{
            
            switch byStatus {
                case .all:
                    query = tasksTbl.filter(Self.status .like("%%%Done")).filter(Self.date .like(Constants.TODAY))
                case .done:
                    query = tasksTbl.filter(Self.status .like(FilterBy.done.rawValue))
                case .today:
                    query = tasksTbl.filter(Self.date .like(Constants.TODAY)).filter(Self.status .like(TaskStatus.NotDone.rawValue))
                case .byDate:
                    query = tasksTbl.order(Self.date)
            }
       // }
        
        
        do{
            let _ = try db.prepare(query).map{ tasks in
                return list.append(TaskModel(id: tasks[Self.id], title: tasks[Self.title],status: TaskStatus(rawValue: tasks[Self.status]) ?? TaskStatus.NotDone,date: tasks[Self.date]))
            }
            return list

        }
        catch{
            print("Could not get list of \(TaskRepository.self) from database")
            return []
        }
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
    
    
    
    
    

}
