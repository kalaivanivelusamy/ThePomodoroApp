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
        let navigationController = UINavigationController(rootViewController: TabBarVC())
        window?.rootViewController = navigationController
       // navigationController.isNavigationBarHidden = true
        window?.makeKeyAndVisible()
        return true
    }

}

