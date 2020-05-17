//
//  AlertManager.swift
//  ThePomodoroApp
//
//  Created by V, Kalaivani V. (623-Extern) on 09/05/20.
//  Copyright © 2020 V, Kalaivani V. (623-Extern). All rights reserved.
//

import UIKit

struct AlertManager{
   
    static func acknowledgmentMessage(on vc: UIViewController, message: String){
        
        let okAction = UIAlertAction(title: "Ok", style: .default)
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(okAction)
        vc.present(alertController,animated: true)
    }
    
    
    static func confirmMessage(on vc:UIViewController, message:String,confirmHandler: @escaping () -> Void){
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        let okAction = UIAlertAction(title: "Yes", style: .default) {_ in confirmHandler() }

        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(okAction)
         alertController.addAction(cancelAction)
        vc.present(alertController,animated: true)
    }
}
