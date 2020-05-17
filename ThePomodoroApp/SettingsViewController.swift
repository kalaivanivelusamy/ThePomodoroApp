//
//  SettingsViewController.swift
//  ThePomodoroApp
//
//  Created by V, Kalaivani V. (623-Extern) on 28/04/20.
//  Copyright © 2020 V, Kalaivani V. (623-Extern). All rights reserved.
//

import UIKit
final class SettingsViewController: UIViewController{
    
    var safeArea : UILayoutGuide!

    private let taskDurationBar = UIProgressView()
    private let taskDurationLbl = UILabel()
    private let saveBtn = UIButton()
    private let cancelBtn = UIButton()

    private let taskDurationSV = CustomStackView(title: "Task Duration", minValue: 10 , maxValue: 30)
    private let shortBreakDurationSV = CustomStackView(title: "Short break",minValue: 15,maxValue: 30)
    private let longBreakDurationSV = CustomStackView(title: "Long break", minValue: 30,maxValue: 30)
    private let numberOfTasksSV = CustomStackView(title: "Task Numbers", minValue: 5,maxValue: 30)

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpDurationStackView()
        setUpShortBreakDuration()
        setUpLongBreakDuration()
        setUpNumOfTasks()
//       setUpTaskDurationLbl()
//        setUpTaskDuration()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setUpView(){
        safeArea = view.layoutMarginsGuide
        view.backgroundColor = .black
    }
    
    private func setUpDurationStackView(){
        
        view.addSubview(taskDurationSV)
        taskDurationSV.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = taskDurationSV.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant: 20)
        let top = taskDurationSV.topAnchor.constraint(equalTo: safeArea.topAnchor,constant: 100)
        let trailing = taskDurationSV.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,constant: -20)
        let height = taskDurationSV.heightAnchor.constraint(equalToConstant: 30)

        NSLayoutConstraint.activate([leading,top,trailing,height])
        
    }
    
    private func setUpShortBreakDuration(){
        
        view.addSubview(shortBreakDurationSV)
        shortBreakDurationSV.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = shortBreakDurationSV.leadingAnchor.constraint(equalTo: taskDurationSV.leadingAnchor)
        let top = shortBreakDurationSV.topAnchor.constraint(equalTo: taskDurationSV.bottomAnchor,constant: 100)
        let trailing = shortBreakDurationSV.trailingAnchor.constraint(equalTo: taskDurationSV.trailingAnchor)
        let height = shortBreakDurationSV.heightAnchor.constraint(equalTo: taskDurationSV.heightAnchor)

        NSLayoutConstraint.activate([leading,top,trailing,height])

        
    }
    
    private func setUpLongBreakDuration(){
        
        view.addSubview(longBreakDurationSV)
        longBreakDurationSV.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = longBreakDurationSV.leadingAnchor.constraint(equalTo: taskDurationSV.leadingAnchor)
        let top = longBreakDurationSV.topAnchor.constraint(equalTo: shortBreakDurationSV.bottomAnchor,constant: 100)
        let trailing = longBreakDurationSV.trailingAnchor.constraint(equalTo: taskDurationSV.trailingAnchor)
        let height = longBreakDurationSV.heightAnchor.constraint(equalTo: taskDurationSV.heightAnchor)

        NSLayoutConstraint.activate([leading,top,trailing,height])

    }
    
    private func setUpNumOfTasks(){
        
        view.addSubview(numberOfTasksSV)
        
        numberOfTasksSV.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = numberOfTasksSV.leadingAnchor.constraint(equalTo: taskDurationSV.leadingAnchor)
        let top = numberOfTasksSV.topAnchor.constraint(equalTo: longBreakDurationSV.bottomAnchor,constant: 100)
        let trailing = numberOfTasksSV.trailingAnchor.constraint(equalTo: taskDurationSV.trailingAnchor)
        let height = numberOfTasksSV.heightAnchor.constraint(equalTo: taskDurationSV.heightAnchor)

        NSLayoutConstraint.activate([leading,top,trailing,height])

        
    }
}
