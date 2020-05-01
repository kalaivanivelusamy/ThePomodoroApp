//
//  PomodoroCoinsViewController.swift
//  ThePomodoroApp
//
//  Created by V, Kalaivani V. (623-Extern) on 29/04/20.
//  Copyright © 2020 V, Kalaivani V. (623-Extern). All rights reserved.
//

import UIKit

final class PomodoroCoinsViewController: UIViewController{
    
    var safeArea : UILayoutGuide!

    let closeBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpView()
    }
    
    //MARK: - Private methods
    
    private func setUpView(){
        safeArea = view.layoutMarginsGuide

        view.backgroundColor = .dimmedPinkRed
        view.isOpaque = false
        
        setUpCloseButton()
    }
    
    private func setUpCloseButton(){
        view.addSubview(closeBtn)
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        
        let top = closeBtn.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0)
        let width = closeBtn.widthAnchor.constraint(equalToConstant: 50)
        let height = closeBtn.heightAnchor.constraint(equalToConstant: 50)
        let trailing = closeBtn.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 20)
        
        NSLayoutConstraint.activate([top,width,height,trailing])
        closeBtn.setBackgroundImage(UIImage(systemName: "xmark.circle"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeBtnPressed), for: .touchUpInside)
        
    }
    
    //MARK: - Action methods
    
   @objc func closeBtnPressed(){
    
    dismiss(animated: true)
        
    }
}
