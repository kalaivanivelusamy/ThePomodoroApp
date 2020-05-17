//
//  TabBarVC.swift
//  ThePomodoroApp
//
//

import UIKit
import Foundation

final class TabBarVC: UITabBarController{
    
    lazy private var timerTab: PomodoroVC = {
        let timerTab = PomodoroVC()

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
        tabBar.barTintColor = .black
        tabBar.tintColor = UIColor.CustomOrange
        
       // setUpNavigationController()
    }
    
    private func setUpViewControllersOfTabs(){
        let controllers = [timerTab,tasksTab,settingsTab]
        self.viewControllers = controllers.map{
            NavigationController(rootViewController: $0)
        }
    }
    
    private func setUpNavigationController(){
        
        navigationItem.title = "Pomodoro"
        navigationController?.navigationBar.tintColor = UIColor.dimmedPinkRed

        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]

        navigationController?.navigationBar.barTintColor = .dimmedPinkRed
        navigationController?.navigationBar.isTranslucent = false
    }
    
    
    
}
