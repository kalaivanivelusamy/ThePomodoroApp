//
//  TaksViewController.swift
//  ThePomodoroApp
//
//  Created by V, Kalaivani V. (623-Extern) on 28/04/20.
//  Copyright © 2020 V, Kalaivani V. (623-Extern). All rights reserved.
//

import UIKit

final class TasksViewController: UIViewController{
    
    private let tblView = UITableView()
    var safeArea : UILayoutGuide!
    var taskDb = [TaskModel]()
    var alert_task: UIAlertController?
    var taskRepository: TaskRepository?
    var taskListArr = [TaskModel]()
    let addBtn = UIButton()
    var selectedRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        do{
        try setUpDb()
        }
        catch{
           print("Errors is \( DatabaseManager.DatabaseError.CouldNotFindPathToCreateDatabaseFileIn)")
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        view.backgroundColor = .black
        
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        addLongGesture()
        listsTasks()
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

        setUpTableView()
        setUpAddBtn()
    }
    
    private func setUpTableView(){
        view.addSubview(tblView)
        tblView.translatesAutoresizingMaskIntoConstraints = false
        tblView.register(AddTaskCustomCell.self, forCellReuseIdentifier: "cellId")
        
        
        let top = tblView.topAnchor.constraint(equalTo: safeArea.topAnchor,constant: 20)
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
        addBtn.backgroundColor = UIColor.orange
        addBtn.setImage(UIImage(named: "plus"), for: .normal)
        addBtn.addTarget(self, action: #selector(createTask), for: .touchUpInside)
        addBtn.layer.masksToBounds = true
        addBtn.layer.cornerRadius = 25
    }

    private func addLongGesture(){
           
           let longpress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized(_:)))
           tblView.addGestureRecognizer(longpress)
       }
    
    //MARK:- Logic
    
    @objc func createTask(){
        self.navigationController?.pushViewController(CreateTaskViewController(mode: .Create), animated: true)
    }
    
    func listsTasks(){
        
        self.taskListArr = self.taskRepository?.listTasks() as! [TaskModel]
             taskDb = self.taskListArr
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
    
    @objc func longPressGestureRecognized(_ gestureRecognizer: UIGestureRecognizer) {
        
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        let locationInView = longPress.location(in: tblView)
        let indexPath = tblView.indexPathForRow(at: locationInView)
        
        
        struct My {
            static var cellSnapshot : UIView? = nil
            static var cellIsAnimating : Bool = false
            static var cellNeedToShow : Bool = false
        }
        struct Path {
            static var initialIndexPath : IndexPath? = nil
        }
        
        
        switch state {
            case UIGestureRecognizerState.began:
                    if indexPath != nil {
                            Path.initialIndexPath = indexPath
                            let cell = tblView.cellForRow(at: indexPath!) as! AddTaskCustomCell?
                            My.cellSnapshot  = snapshotOfCell(cell!)
                        var center = cell?.center
                        My.cellSnapshot!.center = center!
                        My.cellSnapshot!.alpha = 0.0
                        tblView.addSubview(My.cellSnapshot!)
                        UIView.animate(withDuration: 0.25, animations: { () -> Void in
                            center?.y = locationInView.y
                            My.cellIsAnimating = true
                            My.cellSnapshot!.center = center!
                            My.cellSnapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                            My.cellSnapshot!.alpha = 0.98
                            cell?.alpha = 0.0
                        }, completion: { (finished) -> Void in
                            if finished {
                                My.cellIsAnimating = false
                                if My.cellNeedToShow {
                                    My.cellNeedToShow = false
                                    UIView.animate(withDuration: 0.25, animations: { () -> Void in
                                        cell?.alpha = 1
                                    })
                                } else {
                                    cell?.isHidden = true
                                }
                            }
                        })
            }
        case UIGestureRecognizerState.changed:
            if My.cellSnapshot != nil {
                var center = My.cellSnapshot!.center
                center.y = locationInView.y
                My.cellSnapshot!.center = center
                if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
                    taskDb.insert(taskDb.remove(at: Path.initialIndexPath!.row), at: indexPath!.row)
                    tblView.moveRow(at: Path.initialIndexPath!, to: indexPath!)
                    Path.initialIndexPath = indexPath
                }
            }
        default:
            if Path.initialIndexPath != nil {
                let cell = tblView.cellForRow(at: Path.initialIndexPath!) as! AddTaskCustomCell?
                if My.cellIsAnimating {
                    My.cellNeedToShow = true
                } else {
                    cell?.isHidden = false
                    cell?.alpha = 0.0
                }
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
            My.cellSnapshot!.center = (cell?.center)!
            My.cellSnapshot!.transform = CGAffineTransform.identity
                My.cellSnapshot!.alpha = 0.0
                cell?.alpha = 1.0
            }, completion: { (finished) -> Void in
            if finished {
            Path.initialIndexPath = nil
            My.cellSnapshot!.removeFromSuperview()
            My.cellSnapshot = nil
               }
            })
          }
        }
        
    }
    
    func snapshotOfCell(_ inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
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
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedRow = indexPath.row
        let task = taskDb[indexPath.row]
        Task.currentTask = TaskModel(id: task.id, title: task.title)
        self.navigationController?.popViewController(animated: true)
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




