//
//  TimerProtocol.swift
//  ThePomodoroApp
//
//  Created by V, Kalaivani V. (623-Extern) on 01/05/20.
//  Copyright © 2020 V, Kalaivani V. (623-Extern). All rights reserved.
//
import  Foundation
protocol TaskTimerProtocol:class {
//    func startTimer()
//    func stopTimer()
    
    func updateDesc()
    func updateTimeInMinutes(with time: TimeInterval)
}
