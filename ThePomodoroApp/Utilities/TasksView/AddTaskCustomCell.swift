//
//  AddTaskCustomCell.swift
//  ThePomodoroApp
//
//  Created by V, Kalaivani V. (623-Extern) on 04/05/20.
//  Copyright © 2020 V, Kalaivani V. (623-Extern). All rights reserved.
//

import UIKit

final class AddTaskCustomCell: UITableViewCell{
    
     let taskView = BriefTaskView()
   // private let taskView = UITextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Public methods
    func set(taskName: String){
        taskView.setTaskDetails(details: taskName)
    }
    
    //MARK: - Private methods
    private func setUpView(){
        //backgroundColor = .gray
        selectionStyle = .none
        
        addSubview(taskView)
        taskView.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = taskView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 5)
        let top = taskView.topAnchor.constraint(equalTo: topAnchor,constant: 5)
        let bottom = taskView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -5)
        let trailing = taskView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -5)
        NSLayoutConstraint.activate([leading,top,bottom,trailing])
        
       // setUpTasksView()
    }
    
}
