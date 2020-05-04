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
    var taskDb = [String]()
    var alert_task: UIAlertController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        
        //alert to take task details such as name
        self.createTextField()
        
        addLongGesture()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
  
    
    //MARK: - Private methods
    
   
    
    private func setUpView(){
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        navigationItem.title = "Workout"

        let addButton = UIBarButtonItem(
                   title: "Add",
                   style: .done,
                   target: self,
                   action: #selector(addAction)
               )
        addButton.tintColor = .red
        navigationItem.rightBarButtonItem = addButton
        
        setUpTableView()
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
        //tblView.isEditing = true
     
    }
    
    
    private func addLongGesture(){
           
           let longpress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized(_:)))
           tblView.addGestureRecognizer(longpress)
           
       }
       
       
    
    //MARK:- Logic
    
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
        taskCell.backgroundColor = UIColor.clear
        taskCell.set(taskName: task)
        return taskCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    

}

extension TasksViewController{
    
    func createTextField(){
        
         alert_task = UIAlertController(
            title: "Add Task",
            message: "Enter task details",
            preferredStyle: .alert)
        alert_task?.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = " "
                        
        })
        
        alert_task?.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler:{ [weak alert_task] (action) -> Void in
                                        
                                        let textField = (alert_task?.textFields![0])! as UITextField
                                        self.taskDb.append(textField.text!)
                                        self.tblView.reloadData()
                                        
        })
        )
    }
    
    
    
   
}
