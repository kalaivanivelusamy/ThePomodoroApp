//
//  CustomStackView.swift
//  ThePomodoroApp
//
//  Created by V, Kalaivani V. (623-Extern) on 29/04/20.
//  Copyright © 2020 V, Kalaivani V. (623-Extern). All rights reserved.
//

import UIKit

final class CustomStackView: UIView{
    
    private let stackView = UIStackView()
    private let titleLbl = UILabel()
    private let progressBar = UISlider()
    private let titleStr: String
    private let minValue: Int
    private let maxValue: Int
    private let step:Float
    
    init(title:String,minValue:Int,maxValue:Int) {
        
        self.titleStr = title
        self.minValue = minValue
        self.maxValue = maxValue
        self.step = 5.0
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        setUpStackView()
        setupTitleLabel()
        setUpProgressBar()
    }
    
    private func setUpStackView(){
       
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.distribution = .fillEqually
        
        let leading = stackView.leadingAnchor.constraint(equalTo: leadingAnchor)
        let trailing = stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        let width = stackView.widthAnchor.constraint(equalTo: widthAnchor)
        let height = stackView.heightAnchor.constraint(equalTo: heightAnchor)
        
        NSLayoutConstraint.activate([leading,trailing,width,height])

    }
    
    private func setupTitleLabel(){
        
        stackView.addArrangedSubview(titleLbl)
        titleLbl.text = self.titleStr
        titleLbl.textColor = .white;
        titleLbl.font = .boldSystemFont(ofSize: 20)

        
    }
    
    
    private func setUpProgressBar(){
        stackView.addArrangedSubview(progressBar)
        progressBar.tintColor = .dimmedPinkRed
        progressBar.tintColor = .dimmedPinkRed
        progressBar.value = 0.5
        progressBar.minimumValue = Float(self.minValue)
        progressBar.maximumValue = Float(self.maxValue)
        progressBar.thumbTintColor = .dimmedPinkRed
        //progressBar.transform = CGAffineTransform(scaleX: 1, y: 2)
        progressBar.addTarget(self, action: #selector(valueChanged(slider:)), for: .valueChanged)

    }
    
    @objc func valueChanged(slider:UISlider){
        slider.value = round((slider.value/step)*step)
        print("Value changed \(slider.value)")
        
    }
    
}
