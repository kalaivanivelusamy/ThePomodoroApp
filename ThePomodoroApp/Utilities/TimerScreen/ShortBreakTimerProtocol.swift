//
//  ShortBreakTimerProtocol.swift
//  ThePomodoroApp
//
//  Created by V, Kalaivani V. (623-Extern) on 01/05/20.
//  Copyright © 2020 V, Kalaivani V. (623-Extern). All rights reserved.
//

import Foundation

protocol ShortBreakTimerProtocol:class {
    
    func updateDescForShortBreak()
    func updateTimeInMinutesForShortBreak(with time: TimeInterval)
}
