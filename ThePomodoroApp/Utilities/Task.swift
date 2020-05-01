//
//  Task.swift
//  ThePomodoroApp
//
//  Created by V, Kalaivani V. (623-Extern) on 01/05/20.
//  Copyright © 2020 V, Kalaivani V. (623-Extern). All rights reserved.
//

import Foundation

final class Task{
    
    var title = "Task"
    var duration = Constants.taskDuration
    var state: TaskState = .NotStarted
    lazy var timer = Timer()
    weak var delegate: TaskTimerProtocol?
    var timeLeft: TimeInterval = Constants.taskDuration

    func setUpTimer(){
        
        print("Task time started \(self.timeLeft)")
       
        state = .Started
        
        timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) {timer in
            
            self.timeLeft -= 1
            if self.timeLeft == Constants.zeroTime{
                self.state = .Finished
                self.resetTime()
                
            }

            self.delegate?.updateTimeInMinutes(with: self.timeLeft)
        }

    }
    
//    func invalidateTaskTimer(){
//        timer.invalidate()
//    }
    
    func resetTime(){
        timer.invalidate()
       // self.timeLeft = Constants.taskDuration
    }
    
}
enum TaskState{
    case Paused
    case Finished
    case NotStarted
    case Started
}



