//
//  PomodoroVC.swift
//  ThePomodoroApp
//
//
//

import UIKit



final class PomodoroVC: UIViewController{
    
    var safeArea : UILayoutGuide!

    var playBtn = UIButton()
    var stopBtn = UIButton()
    
    var taskView = UIView()
    var nextTaskView = UIView()

    var taskLbl = UILabel()
    
    var timerLbl = UILabel()
    var totalTasksLbl = UILabel()
    
    var timer: Timer?
    var totalTime = 60
    
    var runningTask: TaskModel?
    
    var taskRepository: TaskRepository?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpBtns()
        setUpCurrentTasksView()
        setUpTimerView()
        setUpTaskNumberLabel()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do{
            try setUpDb()
            }
            catch{
               print("Errors is \( DatabaseManager.DatabaseError.CouldNotFindPathToCreateDatabaseFileIn)")
            }
        
        setTaskDetails()

        }
        
       private func setUpDb() throws {
                  
        guard let databaseManager = DatabaseManager.default else{
                throw DatabaseManager.DatabaseError.CouldNotFindPathToCreateDatabaseFileIn
            }
        self.taskRepository = databaseManager.taskRepository
                  
        }
          
    
    func setTaskDetails(){
        self.runningTask = TasksViewController.getCurrentTask()
        guard let task = self.runningTask else{
            return
        }
        taskLbl.text = task.title
        resetTaskTime()
        if (!TasksViewController.todayAllTasks.isEmpty){
        totalTasksLbl.text = "TODAY: \(TasksViewController.todayDoneTasks.count) / \(TasksViewController.todayAllTasks.count)"
        }
        
        if(TasksViewController.todayToDoTasks.count>1){
            setUpNextTaskView()
        }
        else{
            nextTaskView.removeFromSuperview()
        }

    }
    
    //MARK: - Private methods
    
    private func setUpView(){
        safeArea = view.layoutMarginsGuide
        view.backgroundColor = .black
    }
    
    
    private func setUpTimerView(){
        
        view.addSubview(timerLbl)
        timerLbl.translatesAutoresizingMaskIntoConstraints = false
        
        timerLbl.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10).isActive = true
        timerLbl.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        
        timerLbl.textColor = .CustomOrange
        timerLbl.font = UIFont.italicSystemFont(ofSize: 80)
        

    }
    
   private func setUpTaskNumberLabel(){
    
    view.addSubview(totalTasksLbl)
    totalTasksLbl.translatesAutoresizingMaskIntoConstraints = false
    
    totalTasksLbl.leadingAnchor.constraint(equalTo: timerLbl.leadingAnchor).isActive = true
    totalTasksLbl.trailingAnchor.constraint(equalTo: timerLbl.trailingAnchor, constant: -10).isActive = true
    totalTasksLbl.topAnchor.constraint(equalTo: timerLbl.bottomAnchor, constant: 10).isActive = true
    
    totalTasksLbl.textColor = .white
    totalTasksLbl.font = UIFont.boldSystemFont(ofSize: 20)

        
    }
    
    private func setUpCurrentTasksView(){
        view.addSubview(taskView)
        taskView.backgroundColor = .CustomDarkGray
        
        taskView.translatesAutoresizingMaskIntoConstraints = false
        
        taskView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10).isActive = true
        taskView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20).isActive = true
        taskView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor,constant: 50).isActive = true
        taskView.bottomAnchor.constraint(equalTo: playBtn.topAnchor, constant: -30).isActive = true
        //taskView.heightAnchor.constraint(equalTo: safeArea.heightAnchor,multiplier: 0.25).isActive = true
        
        taskView.layer.cornerRadius = 10
        
        setUpTaskLbl()
        setUpSeparator()
        
    }
    
    
    private func setUpTaskLbl(){
        taskView.addSubview(taskLbl)
        taskLbl.translatesAutoresizingMaskIntoConstraints = false
        
        taskLbl.leadingAnchor.constraint(equalTo: taskView.leadingAnchor, constant: 20).isActive = true
        taskLbl.trailingAnchor.constraint(equalTo: taskView.trailingAnchor, constant: -20).isActive = true
        taskLbl.topAnchor.constraint(equalTo: taskView.topAnchor, constant: 10).isActive = true
        taskLbl.heightAnchor.constraint(equalTo:taskView.heightAnchor,multiplier: 0.5).isActive = true
        
        taskLbl.textColor = .white
        taskLbl.text = "Sample task Sample task Sample task Sample task Sample task Sample task Sample task Sample task Sample task Sample task Sample task Sample task Sample task Sample task Sample task Sample task Sample task Sample task Sample task Sample task"
        
        taskLbl.numberOfLines = 0
        taskLbl.font = UIFont.boldSystemFont(ofSize: 25)
        
    }
    
    private func setUpSeparator(){
        let separatorLine = UIImageView()
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        taskView.addSubview(separatorLine)
        
        separatorLine.leadingAnchor.constraint(equalTo: taskView.leadingAnchor, constant: 20).isActive = true
        separatorLine.trailingAnchor.constraint(equalTo: taskView.trailingAnchor, constant: -20).isActive = true
        separatorLine.topAnchor.constraint(equalTo: taskView.bottomAnchor, constant: -50).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        separatorLine.backgroundColor = .CustomLightGray
        
    }
    
    private func setUpNextTaskView(){
        
        view.addSubview(nextTaskView)
        nextTaskView.backgroundColor = .CustomDarkGray
        
        nextTaskView.translatesAutoresizingMaskIntoConstraints = false
        
        nextTaskView.leadingAnchor.constraint(equalTo: taskView.trailingAnchor, constant: 10).isActive = true
        nextTaskView.widthAnchor.constraint(equalToConstant: 100 ).isActive = true
        nextTaskView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor,constant: 50).isActive = true
        nextTaskView.bottomAnchor.constraint(equalTo: playBtn.topAnchor, constant: -30).isActive = true
        //taskView.heightAnchor.constraint(equalTo: safeArea.heightAnchor,multiplier: 0.25).isActive = true
        
        nextTaskView.layer.cornerRadius = 10
        
        
    }
    
    private func setUpBtns(){
        
        view.addSubview(playBtn)
        view.addSubview(stopBtn)

        playBtn.translatesAutoresizingMaskIntoConstraints = false
        stopBtn.translatesAutoresizingMaskIntoConstraints = false

        //Play btn
        playBtn.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -50).isActive = true
        playBtn.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10).isActive = true
        playBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        playBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        playBtn.tintColor = .CustomOrange
        setPlayBtn()
        playBtn.addTarget(self, action: #selector(playTasks), for: .touchUpInside)
        
        //stop btn
        
        stopBtn.topAnchor.constraint(equalTo: playBtn.topAnchor).isActive = true
        stopBtn.trailingAnchor.constraint(equalTo: playBtn.leadingAnchor, constant: -10).isActive = true
        stopBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        stopBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        stopBtn.setBackgroundImage(UIImage(systemName: "xmark.circle"), for: .normal)
        stopBtn.addTarget(self, action: #selector(closeTasks), for: .touchUpInside)
        stopBtn.tintColor = .CustomOrange
        stopBtn.isHidden = true

    }
    
    //MARK: - Logic
    
    func resetTaskTime(){
        self.totalTime = 60
        self.totalTime *= Constants.taskTimeDuration
        self.timerLbl.text = self.timeFormatted(self.totalTime)

    }
    
    @objc func closeTasks(sender: UIButton){
        showTaskDoneMsg()
    }
       
    
    func showTaskDoneMsg(){
        AlertManager.confirmMessage(on: self, message: "Did you finish the task?"){
            self.dismiss(animated: true)
            self.resetTimer()
            self.setPlayBtn()
            self.runningTask?.status = TaskStatus.Done
            self.updateTaskStatus() // update the status in back end
            TasksViewController.todayDoneTasks.append(self.runningTask!)
            if (!TasksViewController.todayToDoTasks.isEmpty){
                TasksViewController.todayToDoTasks.remove(at: 0)
                self.setTaskDetails()
            }
            self.stopBtn.isHidden = true

        }
    }
        
    
    
    @objc func playTasks(sender: UIButton){
        let state = PlayButtonState.init(rawValue: sender.tag)
        
        switch state {
            
        case .Play:
            startTimer()
            setPauseBtn()
            stopBtn.isHidden = false
        case .Pause:
            setPlayBtn()
            pauseTimer()
        case .none:
            break
        }
    }
    
    func setPlayBtn(){
        playBtn.setBackgroundImage(UIImage(systemName: "play.circle"), for: .normal)
        playBtn.tag = PlayButtonState.Play.rawValue
    }
    
    func setPauseBtn(){
        playBtn.setBackgroundImage(UIImage(systemName: "pause.circle"), for: .normal)
        playBtn.tag = PlayButtonState.Pause.rawValue
    }
    
    
    func updateTaskStatus(){
        
        do{
            guard (try self.taskRepository?.updateTask(title: self.runningTask?.title ?? "No title", id: self.runningTask!.id!,status: self.runningTask?.status ?? TaskStatus.NotDone)) != nil else{
                return
            }
        }
        catch {
                print("updating tasks Error")
            }
    }
    
}



extension PomodoroVC{
    
     private func startTimer() {
        
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
    
    private func pauseTimer(){
        self.timer?.invalidate()
    }

    @objc func updateTimer() {
            print(self.totalTime)
            self.timerLbl.text = self.timeFormatted(self.totalTime) // will show timer
            if totalTime != 0 {
                totalTime -= 1  // decrease counter timer
            } else {
                    showTaskDoneMsg()
                if let timer = self.timer {
                    timer.invalidate()
                    self.timer = nil
                }
            }
        }
    
    func resetTimer(){
        resetTaskTime()
        self.timer?.invalidate()
    }
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}


enum PlayButtonState: Int{
    case Pause
    case Play
}
