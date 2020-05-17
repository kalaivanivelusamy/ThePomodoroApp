//
//  NavigationController.swift
//  ThePomodoroApp
//
//  Created by V, Kalaivani V. (623-Extern) on 03/05/20.
//  Copyright © 2020 V, Kalaivani V. (623-Extern). All rights reserved.
//

import UIKit
final class NavigationController: UINavigationController{
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        navigationBar.prefersLargeTitles = true

        //navigationBar.tintColor = .black
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
