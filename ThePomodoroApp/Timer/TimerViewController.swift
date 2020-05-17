//
//  ViewController.swift
//  ThePomodoroApp
//
//  Created by V, Kalaivani V. (623-Extern) on 27/04/20.
//  Copyright © 2020 V, Kalaivani V. (623-Extern). All rights reserved.
//

import UIKit


class TimerViewController: UIViewController {

    
    var safeArea : UILayoutGuide!
    let playpauseBtn = UIButton()
    var tasksCompleted: Float = 0
    
    
    //task brief view
    
    let taskBriefView = BriefTaskView()

    //timer view
    let timerView = UIView()
    let timeLeftShapeLayer = CAShapeLayer()
    let bgShapeLayer = CAShapeLayer()
    
    var timeLeft: TimeInterval = Constants.taskDuration
    var endTime: Date?
    var timeLabel =  UILabel()
    var timeDescLbl = UILabel()
    var taskDescLbl = UILabel()
    
    
    lazy var timer = Timer()
    
    //shortBreak
    var shortBreakTimer = Timer()
    //task status
    
    var taskNum:Int = 0
    
    let smallConfig = UIImage.SymbolConfiguration(scale: .small)
    let progressBar = UIProgressView()
    // here you create your basic animation object to animate the strokeEnd
    let strokeIt = CABasicAnimation(keyPath: "strokeEnd")
    
    //TODO: - Modularize
    
    var taskModule = Task()
    var shortBreakModule = ShortBreakTask()
    var longBreakModule = LongBreakTask()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
      }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.isHidden = true
        taskModule.title = Task.currentTask?.title
        //taskDescLbl.text = Task.currentTask?.title
        taskBriefView.setTaskDetails(details: taskModule.title ?? "", arrow: false)
    }
    

    //MARK: - Private
    
    private func setUpView(){
        view.backgroundColor = .black

        safeArea = view.layoutMarginsGuide
        
        setUpTimerContainerView()
        setUpTaskBriefView()
        setUpStopButton()

        drawBgShape()
        drawTimeLeftShape()
        addTaskDescLbl()
        addTimeLabel()
        addTimeDescLbl()
       // setUpTimer()
        timeLeftShapeLayer.strokeEnd = 0
        setUpProgressBar()
        //setUpShortBreakTimer()
        
        //TODO: - Modularize
        taskModule.delegate = self
        shortBreakModule.delegate = self
        longBreakModule.delegate = self
        
        
        print(DatabaseManager.default.debugDescription)
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
    
    private func setUpTaskBriefView(){
        view.addSubview(taskBriefView)
        
        taskBriefView.translatesAutoresizingMaskIntoConstraints = false
        
        //let bottom = taskBriefView.bottomAnchor.constraint(equalTo: timerView.topAnchor, constant: -120)
        let leading = taskBriefView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20)
        let trailing = taskBriefView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20)
        let top = taskBriefView.topAnchor.constraint(equalTo: view.topAnchor,constant: 80)
        let height = taskBriefView.heightAnchor.constraint(equalToConstant: 180)
        
        NSLayoutConstraint.activate([height,leading,trailing,top])
        taskBriefView.layer.cornerRadius = 10.0
       // taskBriefView.delegate = self
        
    }
    
     private func setUpStopButton(){
            
            view.addSubview(playpauseBtn)
            playpauseBtn.translatesAutoresizingMaskIntoConstraints = false
            
            let bottom = playpauseBtn.topAnchor.constraint(equalTo: timerView.bottomAnchor, constant: 100)
            let centerX = playpauseBtn.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
            let width = playpauseBtn.widthAnchor.constraint(equalToConstant: 50)
            let height = playpauseBtn.heightAnchor.constraint(equalToConstant:50)
            
            NSLayoutConstraint.activate([bottom,centerX,width,height])
            playpauseBtn.setTitleColor(.black, for: .normal)
            playpauseBtn.backgroundColor = UIColor.orange
            playpauseBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
            playpauseBtn.layer.masksToBounds = true
            playpauseBtn.layer.cornerRadius = 25
         //  playpauseBtn.setBackgroundImage(UIImage(systemName: "play.fill",withConfiguration: smallConfig), for: .normal)
            playpauseBtn.tintColor = .black
            playpauseBtn.addTarget(self, action: #selector(StartStopBtnPressed), for: .touchUpInside)
            playpauseBtn.tag = ButtonState.Play.rawValue
            //playpauseBtn.layer.cornerRadius = 10
        }
    
    private func drawBgShape() {
        bgShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX, y: view.frame.midY), radius:
            100, startAngle: degreeToRadians(-90), endAngle: degreeToRadians(270), clockwise: true).cgPath
        bgShapeLayer.strokeColor = UIColor.orange.cgColor
        bgShapeLayer.fillColor = UIColor.clear.cgColor
        bgShapeLayer.lineWidth = 15
        view.layer.addSublayer(bgShapeLayer)
    }
    
    private func drawTimeLeftShape() {
        timeLeftShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX , y: view.frame.midY), radius:
            100, startAngle: degreeToRadians(-90), endAngle: degreeToRadians(270), clockwise: true).cgPath
        timeLeftShapeLayer.strokeColor = UIColor.red.cgColor
        timeLeftShapeLayer.fillColor = UIColor.clear.cgColor
        timeLeftShapeLayer.lineWidth = 15
        view.layer.addSublayer(timeLeftShapeLayer)
    }
    
    private func addTaskDescLbl(){
        
        timerView.addSubview(taskDescLbl)
        taskDescLbl.translatesAutoresizingMaskIntoConstraints = false

        let centerX = taskDescLbl.centerXAnchor.constraint(equalTo: timerView.centerXAnchor)
        let centerY = taskDescLbl.centerYAnchor.constraint(equalTo: timerView.centerYAnchor,constant: -70)
        NSLayoutConstraint.activate([centerY,centerX])

         taskDescLbl.textAlignment = .center
        
        taskDescLbl.text = "Task"

         taskDescLbl.textColor = .white
         taskDescLbl.font = .boldSystemFont(ofSize: 28)
        
    }
    
    private func addTimeLabel() {

           timerView.addSubview(timeLabel)
           timeLabel.translatesAutoresizingMaskIntoConstraints = false

           let top = timeLabel.topAnchor.constraint(equalTo: taskDescLbl.bottomAnchor, constant: 5)
           let centerX = timeLabel.centerXAnchor.constraint(equalTo: taskDescLbl.centerXAnchor)
           NSLayoutConstraint.activate([top,centerX])

            timeLabel.textAlignment = .center
            timeLabel.text = " 00: \(self.timeLeft.description)"
            timeLabel.textColor = .white
            timeLabel.font = .boldSystemFont(ofSize: 28)
       }
    
    private func addTimeDescLbl(){
        
        timerView.addSubview(timeDescLbl)
        timeDescLbl.translatesAutoresizingMaskIntoConstraints = false
        
        let top = timeDescLbl.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 5)
        let centerX = timeDescLbl.centerXAnchor.constraint(equalTo: timeLabel.centerXAnchor)
        NSLayoutConstraint.activate([top,centerX])
        
        timeDescLbl.adjustsFontSizeToFitWidth = true
        
        timeDescLbl.text = "minutes"
        timeDescLbl.textColor = .white
        
    }
    
        private func setUpProgressBar(){
       
            view.addSubview(progressBar)
            progressBar.translatesAutoresizingMaskIntoConstraints = false
        
            let top = progressBar.topAnchor.constraint(equalTo: playpauseBtn.bottomAnchor, constant: 20)
            let leading = progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
            let trailing = progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            let height = progressBar.heightAnchor.constraint(equalToConstant: 20)
            
            NSLayoutConstraint.activate([top,leading,trailing,height])
            progressBar.tintColor = .dimmedPinkRed
            progressBar.transform = CGAffineTransform(scaleX: 1, y: 0.5)

        }
   
    
    //MARK: - Logic
   
    
    @objc func tapTaskBrief(_ sender: UITapGestureRecognizer){
        
        print("Task is tapped")
        
    }
    
    private func stopBlinkEffect(){
        self.taskDescLbl.stopBlink()
        self.timeLabel.stopBlink()
    }
    
    private func setBlinkEffect(){
        self.taskDescLbl.startBlink()
        self.timeLabel.startBlink()
    }
    
   
    
    private func showPomodoroCoins(){
        
        let vc = PomodoroCoinsViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc,animated: true)
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
        
        stopBlinkEffect()
        let btnTag = ButtonState(rawValue:playpauseBtn.tag)
       
        switch btnTag {
       
        case .Pause:
            
            if taskModule.state == .Started {
                taskModule.state = .Paused
                self.timeLeft = taskModule.timeLeft
                taskModule.resetTime()
            }
            else if shortBreakModule.state == .Started{
                shortBreakModule.state = .Paused
                self.timeLeft = shortBreakModule.timeLeft
                shortBreakModule.resetTime()
            }
            
            else if longBreakModule.state == .Started{
                longBreakModule.state = .Paused
                self.timeLeft = longBreakModule.timeLeft
                longBreakModule.resetTime()
            }
            
            setPlayButton()
            stopFillTime()

            
        
        case .Play:
            
            if taskModule.state == .NotStarted || taskModule.state == .Paused{
                taskModule.setUpTimer()
                taskModule.delegate?.updateDesc()
                self.timeLeft = taskModule.timeLeft
            }
            
           else if shortBreakModule.state == .Paused || shortBreakModule.state == .NotStarted{
                shortBreakModule.setUpTimer()
                shortBreakModule.state = .Started
                shortBreakModule.delegate?.updateDescForShortBreak()
                self.timeLeft = shortBreakModule.timeLeft
            }
            
            else if longBreakModule.state == .Paused || longBreakModule.state == .NotStarted{
                longBreakModule.setUpTimer()
                longBreakModule.delegate?.updateDescForLongBreak()
                self.timeLeft = longBreakModule.timeLeft

            }
            
            setPauseBtn()
            startFillTime()

        default:
            break
            
        }
    }
    
    private func setPlayButton(){
        playpauseBtn.setImage(UIImage(systemName: "play.fill",withConfiguration: smallConfig), for: .normal)
        playpauseBtn.tag = ButtonState.Play.rawValue
    }
    
    private func setPauseBtn(){
        playpauseBtn.setImage(UIImage(systemName: "pause.fill",withConfiguration: smallConfig), for: .normal)
        playpauseBtn.tag = ButtonState.Pause.rawValue
    }
    
}

enum ButtonState: Int{
    case Pause
    case Play
}



extension TimerViewController: TaskTimerProtocol{
    
    func updateDesc() {
        
        self.timeLabel.text = taskModule.timeLeft.description

        switch taskModule.state {
            
        case .Finished:
            self.taskDescLbl.text = self.tasksCompleted == 4 ? longBreakModule.title : shortBreakModule.title
            
        default:
            self.taskDescLbl.text = taskModule.title
        }
    }
    
    func updateTimeInMinutes(with TimeLeft: TimeInterval) {
        print("Task time left \(TimeLeft)")
        
            taskModule.timeLeft = TimeLeft
            self.timeLeft = TimeLeft
        
            if TimeLeft == Constants.zeroTime{
                    taskModule.state = .Finished
                    self.setBlinkEffect()
                    self.tasksCompleted += 1.0
                    self.progressBar.progress = self.tasksCompleted/Constants.numOfTasks
                    self.timeLabel.text = "00:00"
                    self.timeLeftShapeLayer.strokeEnd = 0
                    updateDesc()
                    setPlayButton()
                
                if self.tasksCompleted == 4{
                    longBreakModule.timeLeft = Constants.longBreakDuration
                    longBreakModule.state = .NotStarted
                    longBreakModule.setUpTimer()
                }
                
                else{
                    resetShortBreak()
                }
            }
                
            else if self.timeLeft < 10 {
                self.timeLabel.text = "00:0\((Int(TimeLeft)).description)"
            }
        
    }
    
    func resetShortBreak(){
        shortBreakModule.state = .NotStarted
        shortBreakModule.timeLeft = Constants.shortBreakDuration
    }
    
}

extension TimerViewController: ShortBreakTimerProtocol{
    
    func updateDescForShortBreak() {
        self.timeLabel.text = shortBreakModule.timeLeft.description
        
        switch shortBreakModule.state {
            
        case .Finished:
            self.taskDescLbl.text = taskModule.title
            
        default:
            self.taskDescLbl.text = shortBreakModule.title
        }

    }
    
    func updateTimeInMinutesForShortBreak(with TimeLeft: TimeInterval) {
        print("Short break time left \(TimeLeft)")
        
        shortBreakModule.timeLeft = TimeLeft
        
        if TimeLeft == Constants.zeroTime{
               
                shortBreakModule.state = .Finished
                self.setBlinkEffect()
                self.timeLabel.text = "00:00"
                self.timeLeftShapeLayer.strokeEnd = 0
                resetTask()
                setPlayButton()
            
        }
            
        else if self.timeLeft < 10 {
            self.timeLabel.text = "00:0\((Int(TimeLeft)).description)"
        }


    }
    
    func resetTask(){
        taskModule.state = .NotStarted
        taskModule.timeLeft = Constants.taskDuration
    }
}

extension TimerViewController: LongBreakTimerProtocol{
    
    func updateDescForLongBreak(){
        self.timeLabel.text = longBreakModule.timeLeft.description
        
        switch longBreakModule.state {
            
        case .Finished:
            self.taskDescLbl.text = longBreakModule.title
            
        default:
            self.taskDescLbl.text = longBreakModule.title
        }

        
    }
    func updateTimeInMinutesForLongBreak(with TimeLeft: TimeInterval){
        
        print("Long break time left \(TimeLeft)")
        
        longBreakModule.timeLeft = TimeLeft
        
        if TimeLeft == Constants.zeroTime{
                longBreakModule.state = .Finished
                self.setBlinkEffect()
                resetPomodoro()
                self.timeLabel.text = "00:00"
                self.timeLeftShapeLayer.strokeEnd = 0
                setPlayButton()
        }
            
        else if self.timeLeft < 10 {
            self.timeLabel.text = "00:0\((Int(TimeLeft)).description)"
        }
        
    }
    
    //TODO: - After Long break start another pomodoro
    func resetPomodoro(){
        print("Time for New Pomodoro")
        self.taskDescLbl.text = "Time for New Pomodoro"
        longBreakModule.state = .NotStarted
    }

    
}

//extension TimerViewController: TaskBriefTapped{
//
//    func tappedTask() {
//        self.navigationController?.pushViewController(TasksViewController(), animated: true)
//    }
//}



