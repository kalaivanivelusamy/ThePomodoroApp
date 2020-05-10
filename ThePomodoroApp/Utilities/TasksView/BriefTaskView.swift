//
//  BriefTaskView.swift
//  ThePomodoroApp
//
//  Created by V, Kalaivani V. (623-Extern) on 03/05/20.
//  Copyright © 2020 V, Kalaivani V. (623-Extern). All rights reserved.
//

import UIKit

final class BriefTaskView: UIView{
    
    private let containerView = UIView()
    private let taskDesc = UITextView()
    private let arrowImgView = UIImageView()
    weak var delegate: TaskBriefTapped?
    let tapGesture = UITapGestureRecognizer()

    override init(frame: CGRect) {
        super.init(frame:.zero)
        setUpTaskView()
        setUpTextView()
        setUpArrow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public methods
    
    func setTaskDetails(details: String, arrow: Bool = true){
        taskDesc.text = details
        arrowImgView.isHidden = arrow
       // taskDesc.removeGestureRecognizer(tapGesture)
    }
    
    func removeTapAction(){
        self.taskDesc.removeGestureRecognizer(tapGesture)
        self.taskDesc.isUserInteractionEnabled = false
    }
    
    private func setUpTaskView(){
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = containerView.leadingAnchor.constraint(equalTo: leadingAnchor)
        let trailing = containerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        let width = containerView.widthAnchor.constraint(equalTo: widthAnchor)
        let height = containerView.heightAnchor.constraint(equalTo: heightAnchor)

        
        NSLayoutConstraint.activate([leading,trailing,width,height])
        containerView.backgroundColor = .MediumDarkGray
        containerView.layer.cornerRadius = 10.0
        containerView.layer.borderWidth = 2.0
        //containerView.layer.borderColor = UIColor.darkGray.cgColor

    }
    
    private func setUpTextView(){
        
        containerView.addSubview(taskDesc)
        taskDesc.translatesAutoresizingMaskIntoConstraints = false
        let leading = taskDesc.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 10)
        let trailing = taskDesc.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -10)
        let top = taskDesc.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 10)
        let bottom = taskDesc.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: 10)
        
        NSLayoutConstraint.activate([leading,trailing,top,bottom])

        taskDesc.textColor = .white
        taskDesc.font = .systemFont(ofSize: 24)
        taskDesc.text = "get soil & potassium"
        taskDesc.textAlignment = .center
        taskDesc.isEditable = false
        taskDesc.isUserInteractionEnabled = true
           tapGesture.addTarget(self, action: #selector(tapTaskBrief(_:)))
           taskDesc.addGestureRecognizer(tapGesture)
           taskDesc.isUserInteractionEnabled = true
        taskDesc.backgroundColor = .clear
        taskDesc.textAlignment = .left
        //taskDesc.backgroundColor = .lightGray
        
    }
    
    private func setUpArrow(){
        containerView.addSubview(arrowImgView)
        arrowImgView.translatesAutoresizingMaskIntoConstraints = false
        
       // let centerX = arrowImgView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        let centerY = arrowImgView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        let trailing = arrowImgView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -20)
        let width = arrowImgView.widthAnchor.constraint(equalToConstant: 40)
        let height = arrowImgView.heightAnchor.constraint(equalToConstant: 40)

        NSLayoutConstraint.activate([trailing,centerY,width,height])
        arrowImgView.image = UIImage(systemName: "arrow.right")
        arrowImgView.tintColor = .black

    }
    
    @objc func tapTaskBrief(_ sender: UITapGestureRecognizer){
        
        print("Task is tapped")
        self.delegate?.tappedTask()
        
    }
    
}

protocol TaskBriefTapped: class{
    func tappedTask()
}
