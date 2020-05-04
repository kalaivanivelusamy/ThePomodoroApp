//
//  AddTaskCustomCell.swift
//  ThePomodoroApp
//
//  Created by V, Kalaivani V. (623-Extern) on 04/05/20.
//  Copyright © 2020 V, Kalaivani V. (623-Extern). All rights reserved.
//

import UIKit

final class AddTaskCustomCell: UITableViewCell{
    
    private let containerView = BriefTaskView()
   // private let taskView = UITextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Public methods
    func set(taskName: String){
        containerView.setTaskDetails(details: taskName)
    }
    
    //MARK: - Private methods
    private func setUpView(){
        backgroundColor = .clear
        selectionStyle = .none
        
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = containerView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 15)
        let top = containerView.topAnchor.constraint(equalTo: topAnchor,constant: 15)
        let bottom = containerView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -15)
        let trailing = containerView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -15)
        NSLayoutConstraint.activate([leading,top,bottom,trailing])

       // setUpTasksView()
    }
    
}
