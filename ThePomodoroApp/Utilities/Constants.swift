//
//  Constants.swift
//  ThePomodoroApp
//
//  Created by V, Kalaivani V. (623-Extern) on 29/04/20.
//  Copyright © 2020 V, Kalaivani V. (623-Extern). All rights reserved.
//
import Foundation

struct Constants {
    static var taskDuration: TimeInterval = 5.0
    static var shortBreakDuration: TimeInterval = 1
    static var longBreakDuration: TimeInterval = 15.0
    static var zeroTime: TimeInterval = 0.0
    static var numOfTasks: Float = 4
    static var SHORT_BREAK: String = "Short Break"
    static var LONG_BREAK: String = "Long Break"
    static var TODAY: String = getTodayDate()
    static var taskTimeDuration: Int = 5
    
   static func getTodayDate() -> String{
          let currentMonthIndex = Calendar.current.component(.month, from: Date())
          let currentYear = Calendar.current.component(.year, from: Date())
         let todaysDate = Calendar.current.component(.day, from: Date())
           return  "\(todaysDate).\(currentMonthIndex).\(currentYear)"

       }
}
