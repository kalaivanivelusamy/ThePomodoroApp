//
//  LongBreakTask.swift
//  ThePomodoroApp
//
//  Created by V, Kalaivani V. (623-Extern) on 01/05/20.
//  Copyright © 2020 V, Kalaivani V. (623-Extern). All rights reserved.
//

import Foundation

final class LongBreakTask{

        var title = Constants.LONG_BREAK
        var duration = Constants.longBreakDuration
        var state: LongBreakState = .NotStarted
        lazy var longBreakTimer = Timer()
        weak var delegate: LongBreakTimerProtocol?
        var timeLeft: TimeInterval = Constants.longBreakDuration
    
    func setUpTimer(){
        
        print("Long break time started \(self.timeLeft)")
       
        state = .Started
        
        longBreakTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) {timer in
            
            self.timeLeft -= 1
            if self.timeLeft == Constants.zeroTime{
                self.state = .Finished
                self.resetTime()
            }
            self.delegate?.updateTimeInMinutesForLongBreak(with: self.timeLeft)
        }

    }
    
    func resetTime(){
        longBreakTimer.invalidate()
    }

}

enum LongBreakState{
    case Paused
    case Finished
    case NotStarted
    case Started
}

