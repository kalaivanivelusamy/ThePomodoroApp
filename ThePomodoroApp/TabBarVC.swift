//
//  TabBarVC.swift
//  ThePomodoroApp
//
//  Created by V, Kalaivani V. (623-Extern) on 28/04/20.
//  Copyright © 2020 V, Kalaivani V. (623-Extern). All rights reserved.
//

import UIKit

final class TabBarVC: UITabBarController{
    
    lazy private var timerTab: TimerViewController = {
        let timerTab = TimerViewController()

        var image = UIImage(systemName: "timer")
        
        timerTab.tabBarItem = UITabBarItem(title: "Timer", image: UIImage(systemName: "timer"), selectedImage: nil)
        return timerTab
    }()
    
    lazy private var settingsTab: SettingsViewController = {
        
        let settingsTab = SettingsViewController()
        settingsTab.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), selectedImage: nil)
        return settingsTab
        
    }()
    
    
    lazy private var tasksTab: TasksViewController = {
        
        let tasksTab = TasksViewController()
        tasksTab.tabBarItem = UITabBarItem(title: "Tasks", image: UIImage(systemName: "list.bullet"), selectedImage: nil)
        return tasksTab
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewControllersOfTabs()
        tabBar.barTintColor = .lightGray
        tabBar.tintColor = .dimmedPinkRed
        
        setUpNavigationController()
    }
    
    private func setUpViewControllersOfTabs(){
        self.viewControllers = [timerTab,settingsTab,tasksTab]
    }
    
    private func setUpNavigationController(){
        
        navigationItem.title = "Pomodoro"
        navigationController?.navigationBar.tintColor = UIColor.dimmedPinkRed

        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]

        navigationController?.navigationBar.barTintColor = .dimmedPinkRed
        navigationController?.navigationBar.isTranslucent = false
    }
    
    
    
}
