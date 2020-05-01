//
//  ShortBreakTask.swift
//  ThePomodoroApp
//
//  Created by V, Kalaivani V. (623-Extern) on 01/05/20.
//  Copyright © 2020 V, Kalaivani V. (623-Extern). All rights reserved.
//

import Foundation

final class ShortBreakTask{
    
    var title = Constants.SHORT_BREAK
    var duration = Constants.shortBreakDuration
    var state: ShortBreakState = .NotStarted
    lazy var shortBreaktimer = Timer()
    weak var delegate: ShortBreakTimerProtocol?
    var timeLeft: TimeInterval = Constants.shortBreakDuration
    
    func setUpTimer(){
            
            print("Short break time started \(self.timeLeft)")
           
            state = .Started
            
            shortBreaktimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) {timer in
                
                self.timeLeft -= 1
                if self.timeLeft == Constants.zeroTime{
                    self.state = .Finished
                    self.resetTime()
                }
                self.delegate?.updateTimeInMinutesForShortBreak(with: self.timeLeft)
            }

        }
        
        
        func resetTime(){
            shortBreaktimer.invalidate()
        }

}
enum ShortBreakState{
    case Paused
    case Finished
    case NotStarted
    case Started
}


