//
//  TaksViewController.swift
//  ThePomodoroApp


import UIKit



enum TaskStatus: String,CaseIterable{
    case NotDone
    case Done
    case All
    
    static var asArray: [TaskStatus] {return self.allCases}
}

final class TasksViewController: UIViewController{
    
    private let tblView = UITableView()
    var safeArea : UILayoutGuide!
    var taskDb = [TaskModel]()
    var alert_task: UIAlertController?
    var taskRepository: TaskRepository?
    
    static var taskListArr = [TaskModel]()
    static var todayToDoTasks = [TaskModel]()
    static var todayAllTasks = [TaskModel]()
    static var todayDoneTasks = [TaskModel]()
    static var tasksByDate = [TaskModel]()

    let addBtn = UIButton()
    var selectedRow = 0
    static var currentTaskIndex = 0
    var filterStackView = UIStackView()
    var todayBtn = UIButton()
    var allTasksBtn = UIButton()
    var doneTasksBtn = UIButton()
    var byDateTasksBtn = UIButton()
    
    var tasksFilteredBy = FilterBy.today
    var highlightImg = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do{
        try setUpDb()
        }
        catch{
           print("Errors is \( DatabaseManager.DatabaseError.CouldNotFindPathToCreateDatabaseFileIn)")
        }
        setUpView()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        view.backgroundColor = .black
        
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        listsTasks(filterByDate: Constants.getTodayDate(),byStatus: FilterBy.today)
        
    }
    
    
    //MARK: - Public methods
    
   static func getCurrentTask() -> TaskModel?{
    
    let index = TasksViewController.currentTaskIndex
    if !TasksViewController.todayToDoTasks.isEmpty{ return TasksViewController.todayToDoTasks[index] }
        else{ return nil}
    }
    
    //MARK: - Private methods
    
    private func setUpDb() throws {
       
        guard let databaseManager = DatabaseManager.default else{
            throw DatabaseManager.DatabaseError.CouldNotFindPathToCreateDatabaseFileIn
               }

            self.taskRepository = databaseManager.taskRepository

    }
    
    private func setUpView(){
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        navigationItem.title = "Tasks"
       
        setUpTaskFilterMenu()

        setUpTableView()
        setUpAddBtn()
    }
    
    func setUpTaskFilterMenu(){
        view.addSubview(filterStackView)
        filterStackView.translatesAutoresizingMaskIntoConstraints = false
        
        filterStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10).isActive = true
        filterStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        filterStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        
        filterStackView.distribution = .fillEqually
        
        setUpTodayBtn()
        setUpAllTasksBtn()
        setUpTasksDoneBtn()
        setUpDateByBtn()
        
        setupHighlight(btn: todayBtn)
    }
    
    private func setUpTodayBtn(){
        filterStackView.addArrangedSubview(todayBtn)
        todayBtn.setTitle("TODAY", for: .normal)
        todayBtn.setTitleColor(.white, for: .normal)
        todayBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        todayBtn.tag = FilterBy.today.asInt()
        todayBtn.addTarget(self, action: #selector(tasksSorted), for: .touchUpInside)
    }
    
    private func setUpAllTasksBtn(){
        filterStackView.addArrangedSubview(allTasksBtn)
        allTasksBtn.setTitle("ALL", for: .normal)
        allTasksBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        allTasksBtn.setTitleColor(.white, for: .normal)
        
        allTasksBtn.tag = FilterBy.all.asInt()
        allTasksBtn.addTarget(self, action: #selector(tasksSorted), for: .touchUpInside)
    }
    
    private func setUpTasksDoneBtn(){
        filterStackView.addArrangedSubview(doneTasksBtn)
        doneTasksBtn.setTitle("DONE", for: .normal)
        doneTasksBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        doneTasksBtn.setTitleColor(.white, for: .normal)
        
        doneTasksBtn.tag = FilterBy.done.asInt()
        doneTasksBtn.addTarget(self, action: #selector(tasksSorted), for: .touchUpInside)

    }
    
    private func setUpDateByBtn(){
        filterStackView.addArrangedSubview(byDateTasksBtn)
        byDateTasksBtn.setTitle("By Date", for: .normal)
        byDateTasksBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        byDateTasksBtn.setTitleColor(.white, for: .normal)
        
        byDateTasksBtn.tag = FilterBy.byDate.asInt()
        byDateTasksBtn.addTarget(self, action: #selector(tasksSorted), for: .touchUpInside)
    }
    
    
    private func setupHighlight(btn: UIButton){
        view.addSubview(highlightImg)
        highlightImg.translatesAutoresizingMaskIntoConstraints = false
        
        highlightImg.topAnchor.constraint(equalTo: btn.bottomAnchor,constant: 5).isActive = true
        highlightImg.heightAnchor.constraint(equalToConstant: 2).isActive = true
        highlightImg.leadingAnchor.constraint(equalTo: btn.leadingAnchor ,constant: 10).isActive = true
        highlightImg.trailingAnchor.constraint(equalTo: btn.trailingAnchor, constant: -10).isActive = true
        
        highlightImg.backgroundColor = .orange
    }
    
    private func setUpTableView(){
        view.addSubview(tblView)
        tblView.translatesAutoresizingMaskIntoConstraints = false
        tblView.register(AddTaskCustomCell.self, forCellReuseIdentifier: "cellId")
        
        
        let top = tblView.topAnchor.constraint(equalTo: filterStackView.bottomAnchor,constant: 20)
        let leading = tblView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor)
        let bottom = tblView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor,constant: -20)
        let trailing = tblView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        NSLayoutConstraint.activate([top,leading,bottom,trailing])

       // tblView.backgroundColor = UIColor.yellow
        
        tblView.delegate = self
        tblView.dataSource = self
        tblView.backgroundColor = .clear
    }
    
    
    private func setUpAddBtn(){
        
        view.addSubview(addBtn)
        addBtn.translatesAutoresizingMaskIntoConstraints = false
        
        
        let top = addBtn.topAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -60)
        let trailing = addBtn.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30)
        let width = addBtn.widthAnchor.constraint(equalToConstant: 50)
        let height = addBtn.heightAnchor.constraint(equalToConstant: 50)
        
        NSLayoutConstraint.activate([top,trailing,width,height])
        
        addBtn.setTitleColor(.orange, for: .normal)
        addBtn.backgroundColor = UIColor.CustomOrange
        addBtn.setImage(UIImage(named: "plus"), for: .normal)
        addBtn.addTarget(self, action: #selector(createTask), for: .touchUpInside)
        addBtn.layer.masksToBounds = true
        addBtn.layer.cornerRadius = 25
    }

    
    //MARK:- Logic
    
    
    
    @objc func tasksSorted(sender: UIButton){
       
         let btnTag = FilterBy.asArray[sender.tag] 
        highlightImg.removeFromSuperview()
        tasksFilteredBy = btnTag
        
        switch btnTag {
        case .today:
             setupHighlight(btn: todayBtn)
             listsTasks(filterByDate: Constants.getTodayDate(),byStatus: .today)
        case .all:
            setupHighlight(btn: allTasksBtn)
            listsTasks(filterByDate: "",byStatus: .all)
        case .done:
            setupHighlight(btn: doneTasksBtn)
            listsTasks(filterByDate: "",byStatus: .done)
        case .byDate:
            setupHighlight(btn: byDateTasksBtn)
            listsTasks(filterByDate: "",byStatus: .byDate)
        
        }
    }
    
    @objc func createTask(){
        self.navigationController?.pushViewController(CreateTaskViewController(mode: .Create), animated: true)
    }
    
    func listsTasks(filterByDate: String,byStatus: FilterBy){
        
        TasksViewController.taskListArr = self.taskRepository?.listTasks(filterByDate:filterByDate, byStatus: byStatus ) as! [TaskModel]
       
        switch (byStatus) {
        case .all:
            TasksViewController.todayAllTasks = TasksViewController.taskListArr
        case .today:
            TasksViewController.todayToDoTasks = TasksViewController.taskListArr
        case .done:
            TasksViewController.todayDoneTasks = TasksViewController.taskListArr
        case .byDate:
            TasksViewController.tasksByDate = TasksViewController.taskListArr

        }
        taskDb = TasksViewController.taskListArr
        tblView.reloadData()
     }
     
     func deleteTasks(id: Int64) {
        do{
            let _ =  try self.taskRepository?.deleteTask(taskId:id)
        }
        catch{
            print("Error")
        }
     }
    
   
    @objc func addAction(){
        print ("Clicked add method")
        alert_task?.textFields![0].text = ""
        
        self.present(alert_task!, animated: true, completion: nil)

    }
}

extension TasksViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskDb.count
    }
}

extension TasksViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        guard let taskCell = cell as? AddTaskCustomCell else{
            return cell
        }
        let task = taskDb[indexPath.row]
        taskCell.set(taskName: task.title)
        taskCell.taskView.removeTapAction() 
       // taskCell.taskView.delegate = self
        return taskCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedRow = indexPath.row
        let task = taskDb[indexPath.row]
        Task.currentTask = TaskModel(id: task.id, title: task.title,status: task.status)
        if tasksFilteredBy == .today{
        self.tabBarController?.selectedIndex = 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       
        let task = taskDb[indexPath.row]
        
        //delete action
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action,view,completion in
            
            do{
           let _ = self.deleteTasks(id: try task.requireID())
                self.taskDb.remove(at: indexPath.row)
                tableView.reloadData()
            completion(true)
            }
            catch{
                completion(false)
                   print ("error")
            }
        }
        
        //edit action
        let editAction = UIContextualAction(style: .destructive, title: "Edit") { action,view,completion in
         self.navigationController?.pushViewController(CreateTaskViewController(mode: .Edit(task)), animated: true)

        }
        return UISwipeActionsConfiguration(actions: [deleteAction,editAction])
    }
}

enum FilterBy: String,CaseIterable{
    case today
    case all
    case done
    case byDate
    
    static var asArray: [FilterBy] {return self.allCases}

    func asInt() -> Int {
        return FilterBy.asArray.firstIndex(of: self)!
    }
}


