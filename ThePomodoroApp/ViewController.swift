//
//  ViewController.swift
//  ThePomodoroApp
//
//  Created by V, Kalaivani V. (623-Extern) on 27/04/20.
//  Copyright © 2020 V, Kalaivani V. (623-Extern). All rights reserved.
//

import UIKit


class TimerViewController: UIViewController {

    
    let stopBtn = UIButton()
    var safeArea : UILayoutGuide!
    
    //timer view
    let timerView = UIView()
    let timeLeftShapeLayer = CAShapeLayer()
    let bgShapeLayer = CAShapeLayer()
    var timeLeft: TimeInterval = 25
    var endTime: Date?
    var timeLabel =  UILabel()
    var timer = Timer()
    let smallConfig = UIImage.SymbolConfiguration(scale: .small)

    // here you create your basic animation object to animate the strokeEnd
    let strokeIt = CABasicAnimation(keyPath: "strokeEnd")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
  
    }

    //MARK: - Private
    
    private func setUpView(){
        view.backgroundColor = .lightGray

        safeArea = view.layoutMarginsGuide
        setUpTimerContainerView()
        setUpStopButton()
        drawBgShape()
        drawTimeLeftShape()
        addTimeLabel()
        setUpTimer()
        timeLeftShapeLayer.strokeEnd = 0
    }
    
    private func setUpTimerContainerView(){
        
        view.addSubview(timerView)
        
        timerView.translatesAutoresizingMaskIntoConstraints = false
       // timerView.backgroundColor = .red
        
        let centerX = timerView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        let centerY = timerView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
        let height = timerView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.25)
        let width = timerView.widthAnchor.constraint(equalTo: timerView.heightAnchor)

        NSLayoutConstraint.activate([centerY,centerX,height,width])
    }
    
     private func setUpStopButton(){
            
            view.addSubview(stopBtn)
            stopBtn.translatesAutoresizingMaskIntoConstraints = false
            
            let bottom = stopBtn.topAnchor.constraint(equalTo: timerView.bottomAnchor, constant: 50)
            let centerX = stopBtn.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
            let width = stopBtn.widthAnchor.constraint(equalToConstant: 40)
            let height = stopBtn.heightAnchor.constraint(equalToConstant:40)
            
            NSLayoutConstraint.activate([bottom,centerX,width,height])
            stopBtn.setTitleColor(.black, for: .normal)
           stopBtn.setBackgroundImage(UIImage(systemName: "play.fill",withConfiguration: smallConfig), for: .normal)
            stopBtn.tintColor = .darkGray
            stopBtn.addTarget(self, action: #selector(StartStopBtnPressed), for: .touchUpInside)
            stopBtn.tag = ButtonState.Start.rawValue
            stopBtn.layer.cornerRadius = 10
        }
    
    private func drawBgShape() {
        bgShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX, y: view.frame.midY), radius:
            100, startAngle: degreeToRadians(-90), endAngle: degreeToRadians(270), clockwise: true).cgPath
        bgShapeLayer.strokeColor = UIColor.white.cgColor
        bgShapeLayer.fillColor = UIColor.clear.cgColor
        bgShapeLayer.lineWidth = 15
        view.layer.addSublayer(bgShapeLayer)
    }
    
    private func drawTimeLeftShape() {
        timeLeftShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX , y: view.frame.midY), radius:
            100, startAngle: degreeToRadians(-90), endAngle: degreeToRadians(270), clockwise: true).cgPath
        timeLeftShapeLayer.strokeColor = UIColor.darkGray.cgColor
        timeLeftShapeLayer.fillColor = UIColor.clear.cgColor
        timeLeftShapeLayer.lineWidth = 15
        view.layer.addSublayer(timeLeftShapeLayer)
    }
    
    private func addTimeLabel() {

           timerView.addSubview(timeLabel)
           timeLabel.translatesAutoresizingMaskIntoConstraints = false

           let centerX = timeLabel.centerXAnchor.constraint(equalTo: timerView.centerXAnchor)
           let centerY = timeLabel.centerYAnchor.constraint(equalTo: timerView.centerYAnchor)
           NSLayoutConstraint.activate([centerY,centerX])

            timeLabel.textAlignment = .center
            timeLabel.text = " 00: \(self.timeLeft.description)"
            timeLabel.textColor = .white
            timeLabel.font = .boldSystemFont(ofSize: 28)
       }
   
    
    //MARK: - Logic
    
    private func setUpTimer(){
       
        timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) {timer in
                 
                 if self.timeLeft <= 0{
                     timer.invalidate()
                 }
                 else if self.timeLeft < 10 {
                     self.timeLabel.text = "00:0\((Int(self.timeLeft)).description)"
                 }
                 else{
                 self.timeLabel.text = "00:\((Int(self.timeLeft)).description)"
                     print("Time left: \(self.timeLeft)")
                 }
                 self.timeLeft -= 1
             }
    }
    
   private func startTimer(){
        timer.fire()
    }
    
   private func stopTimer(){
        timer.invalidate()
    }
    
    private func startFillTime(){
        
        // here you define the fromValue, toValue and duration of your animation
        
        strokeIt.fromValue = timeLeftShapeLayer.strokeEnd
        strokeIt.toValue = 1
        strokeIt.duration = self.timeLeft * 60
        timeLeftShapeLayer.speed = 1.0  // altering speed for pause/continue the animation

        // add the animation to your timeLeftShapeLayer
        timeLeftShapeLayer.add(strokeIt, forKey: nil)
    }
    
    private func stopFillTime(){
        
        let currentStrokeEnd = timeLeftShapeLayer.presentation()?.strokeEnd;
        timeLeftShapeLayer.strokeEnd = currentStrokeEnd!
        //making speed 0 is equivalent to pause the animation
        timeLeftShapeLayer.speed = 0.0
        
        //removes animation but saves the last point where it is filled
        timeLeftShapeLayer.removeAllAnimations()

    }
  
    
    
    
    private func degreeToRadians(_ number: Double) -> CGFloat{
        return CGFloat(number * 3.14 / 180)
    }
    
  
    @objc func StartStopBtnPressed(){
        
        let btnTag = ButtonState(rawValue:stopBtn.tag)
       
        switch btnTag {
       
        case .Stop:
            stopBtn.setBackgroundImage(UIImage(systemName: "play.fill",withConfiguration: smallConfig), for: .normal)
            stopBtn.tag = ButtonState.Start.rawValue
            stopTimer()
            stopFillTime()
        
        case .Start:
            stopBtn.setBackgroundImage(UIImage(systemName: "stop.fill",withConfiguration: smallConfig), for: .normal)
            stopBtn.tag = ButtonState.Stop.rawValue
            startTimer()
            startFillTime()
        default:
            break
            
        }
    }
}

enum ButtonState: Int{
    case Stop
    case Start
}


