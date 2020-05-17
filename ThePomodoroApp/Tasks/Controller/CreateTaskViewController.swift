//
//  CreateTaskViewController.swift
//  ThePomodoroApp
//
//  Created by V, Kalaivani V. (623-Extern) on 08/05/20.
//  Copyright © 2020 V, Kalaivani V. (623-Extern). All rights reserved.
//

import UIKit

final class CreateTaskViewController: UIViewController{
    
    var safeArea : UILayoutGuide!
    let taskFieldContainer = UIView()
    
    let taskTF = UITextField()
    let underline = UIImageView()
    
    let btnStackView = UIStackView()
    let saveBtn = UIButton()
    let dateBtn = UIButton()
    
    var taskRepository: TaskRepository?
    var task:TaskModel?
    var mode: Mode
    
    static var selectedDate: String?
    
    enum Mode{
        case Create
        case Edit(TaskModel)
    }
    
    init(mode: Mode){
        self.mode = mode
        
        switch mode {
        case .Create: ()
        case .Edit(let taskModel):
            task = taskModel
        }
        super.init(nibName: nil, bundle: nil)
        CreateTaskViewController.selectedDate = self.getTodayDate()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dateBtn.setTitle(CreateTaskViewController.selectedDate, for: .normal)
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

    }
    
    private func setUpView(){
        
        safeArea = view.layoutMarginsGuide
        
        view.backgroundColor = .black
        navigationItem.title = "Add Task"
        
        setUpTaskFieldContainer()
        setUpBtnStackView()
        do{
        try setUpDb()
        }
        catch{
           print("Errors is \( DatabaseManager.DatabaseError.CouldNotFindPathToCreateDatabaseFileIn)")
        }
    }
    
    private func setUpDb() throws {
        
        guard let databaseManager = DatabaseManager.default else{
            throw DatabaseManager.DatabaseError.CouldNotFindPathToCreateDatabaseFileIn
               }

    self.taskRepository = databaseManager.taskRepository
        
    }
    
    private func setUpTaskFieldContainer(){
        view.addSubview(taskFieldContainer)
        taskFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = taskFieldContainer.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10)
        let top = taskFieldContainer.topAnchor.constraint(equalTo: safeArea.topAnchor,constant: 30)
        let height = taskFieldContainer.heightAnchor.constraint(equalToConstant: 50)
        let trailing = taskFieldContainer.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10)
        
        NSLayoutConstraint.activate([leading,top,trailing,height])

        
        setUpTaskTextField()
    }
    
    private func setUpTaskTextField(){
        
        taskFieldContainer.addSubview(taskTF)
        taskTF.translatesAutoresizingMaskIntoConstraints = false

        let leading = taskTF.leadingAnchor.constraint(equalTo: taskFieldContainer.leadingAnchor)
        let top = taskTF.topAnchor.constraint(equalTo: taskFieldContainer.topAnchor)
        let height = taskTF.heightAnchor.constraint(equalTo: taskFieldContainer.heightAnchor)
        let trailing = taskTF.trailingAnchor.constraint(equalTo: taskFieldContainer.trailingAnchor)
        
        NSLayoutConstraint.activate([leading,top,trailing,height])
        
        switch self.mode {
        case .Create:
            taskTF.placeholder = "Task name"
        case .Edit(let taskModel):
            taskTF.text = taskModel.title
        }
    
        taskTF.textColor = .white
        
        setUpTFUndeline()
    }
    
    private func setUpTFUndeline(){
        taskFieldContainer.addSubview(underline)
        underline.translatesAutoresizingMaskIntoConstraints = false
        
        let top = underline.topAnchor.constraint(equalTo: taskTF.bottomAnchor, constant: 3)
        let leading = underline.leadingAnchor.constraint(equalTo: taskTF.leadingAnchor)
        let trailing = underline.trailingAnchor.constraint(equalTo: taskTF.trailingAnchor)
        let height = underline.heightAnchor.constraint(equalToConstant: 1)
        
        NSLayoutConstraint.activate([top,leading,height,trailing])
        
        underline.backgroundColor = UIColor.darkGray
    }
    
    private func setUpBtnStackView(){
        
        view.addSubview(btnStackView)
        btnStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = btnStackView.topAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -50)
        let leading = btnStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10)
        let trailing = btnStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([top,leading,trailing])
        
        btnStackView.distribution = .fillProportionally
        
        setUpDateBtn()
        setUpSaveBtn()

    }
    
    
    private func setUpDateBtn(){
        btnStackView.addArrangedSubview(dateBtn)
        dateBtn.layer.cornerRadius = 10
        dateBtn.setImage(UIImage(systemName: "calendar.circle"), for: .normal)
        dateBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -40, bottom: 0, right: 10)
        dateBtn.tintColor = .white
        dateBtn.setTitle(CreateTaskViewController.selectedDate, for: .normal)
        dateBtn.setTitleColor(.white, for: .normal)
        dateBtn.backgroundColor = .darkGray
        dateBtn.addTarget(self, action: #selector(openCalendar), for: .touchUpInside)
    }
    
   
    
    private func setUpSaveBtn(){
        
        btnStackView.addArrangedSubview(saveBtn)
        saveBtn.setTitle("Save", for: .normal)
       // saveBtn.setBackgroundImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        saveBtn.tintColor = .orange
        saveBtn.sizeToFit()
        saveBtn.layer.cornerRadius = 20
        saveBtn.setTitleColor(.orange, for: .normal)
        saveBtn.addTarget(self, action: #selector(addTask), for: .touchUpInside)
    }
    
    //MARK:- action methods
    
    @objc func openCalendar(){
        self.navigationController?.pushViewController(CalendarViewController(), animated: true)
    }
    
    
    //MARK: - Logic
    
    func getTodayDate() -> String{
       let currentMonthIndex = Calendar.current.component(.month, from: Date())
       let currentYear = Calendar.current.component(.year, from: Date())
      let todaysDate = Calendar.current.component(.day, from: Date())
        return  "\(todaysDate).\(currentMonthIndex).\(currentYear)"

    }
    @objc func addTask(){
        validation(title: taskTF.text!)
        navigationController?.popViewController(animated: true)
    }
    
    func updateTask(){
        
        do{
            guard (try self.taskRepository?.updateTask(title: taskTF.text!, id: task!.id!,status: task?.status ?? TaskStatus.NotDone)) != nil else{
                return
            }
        }
        catch {
                print("Error")
            }
    }
    
    
    func isValid(text: String) -> Result <Void,TaskValidationError>{
        
        if text.isEmpty{
            return .failure(.titleIsEmpty)
        }
        else{
            return .success(())
        }
        
    }
    
    enum TaskValidationError: String,Error{
        case titleIsEmpty
        
        var description: String {
            return self.rawValue.description
        }
    }
    
    func validation(title: String){
        
           switch isValid(text:title) {
           case .success():
            switch self.mode {
            case .Create:
            addTasksInDb()
            case .Edit(_):
                updateTask()
            }
            case .failure(let error):
                print("Error")
                AlertManager.acknowledgmentMessage(on: self, message: error.description)
            }
       }
       
       func addTasksInDb(){
           
           do{
            guard (try self.taskRepository?.createTask(title: taskTF.text!,date: CreateTaskViewController.selectedDate!)) != nil else{
                   return
               }
           }
           catch {
           print("Error")
           }
       }
}
