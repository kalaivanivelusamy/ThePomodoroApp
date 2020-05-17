//
//  AppDelegate.swift
//  ThePomodoroApp
//


import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        //let navigationController = NavigationController(rootViewController: TimerViewController())
//        window?.rootViewController = navigationController
//        navigationController.navigationBar.prefersLargeTitles = true
//        window?.makeKeyAndVisible()
       
        let tabBarVC = TabBarVC()
        window?.rootViewController = tabBarVC
       // navigationController.navigationBar.prefersLargeTitles = true
        window?.makeKeyAndVisible()

        
        return true
    }

}

