//
//  TaskModel.swift
//  ThePomodoroApp
//
//  Created by V, Kalaivani V. (623-Extern) on 05/05/20.
//  Copyright © 2020 V, Kalaivani V. (623-Extern). All rights reserved.
//

import Foundation

struct TaskModel{
    
    static let tableName = "Tasks"
    let title:String
    let id:Int64?
    
    init(id:Int64? = nil, title:String) {
        self.title = title
        self.id = id
    }
    
    func requireID() throws -> Int64{
        guard let id = id else{ throw workoutError.idWasNil}
        return id
    }
    
    enum workoutError:Error{
        case idWasNil
    }

}
