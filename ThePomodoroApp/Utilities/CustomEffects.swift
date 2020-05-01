//
//  CustomEffects.swift
//  ThePomodoroApp
////

import UIKit

extension UILabel{
    
    func startBlink(){
        UIView.animate(withDuration: 0.8,
        delay:0.0,
        options:[.curveEaseInOut, .autoreverse, .repeat],
        animations: { self.alpha = 0 },
        completion: nil)
    }
    
    func stopBlink(){
        layer.removeAllAnimations()
        alpha = 1
    }
}
