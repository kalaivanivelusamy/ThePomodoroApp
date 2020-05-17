//
//  WeekdaysView.swift
//  TheCalendarApp
//


import UIKit

final class WeekdaysView: UIView{
    
    var stackView = UIStackView()
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.backgroundColor = .clear
        
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews(){
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
          stackView.distribution = .fillEqually
        
        let daysArr = ["Su", "Mo", "Tu","We","Th","Fr","Sa"]
        
        for i in 0..<7{
            
            let lbl = UILabel()
            lbl.text = daysArr[i]
            lbl.textAlignment = .center
            lbl.textColor = .black
            stackView.addArrangedSubview(lbl)
        }
       
        
    }
}
