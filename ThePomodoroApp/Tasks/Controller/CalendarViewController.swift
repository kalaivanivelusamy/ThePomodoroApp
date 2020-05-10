//
//  CalendarViewController.swift
//  ThePomodoroApp
//
//  Created by V, Kalaivani V. (623-Extern) on 09/05/20.
//  Copyright © 2020 V, Kalaivani V. (623-Extern). All rights reserved.
//

import UIKit
import CVCalendar
final class CalendarViewController: UIViewController{
    
    var safeArea : UILayoutGuide!

    var calendarView = CVCalendarView()
    var menuView = CVCalendarMenuView()
    private var currentCalendar: Calendar?

    override func viewDidLoad() {
        super.viewDidLoad()
        safeArea = view.layoutMarginsGuide
        //setUpCalendar()
        self.calendarView = CVCalendarView(frame: CGRect(x: 0, y: 20, width: 300, height: 100))

        self.menuView = CVCalendarMenuView(frame: CGRect(x:0, y:0,width:300,height: 15))

        self.calendarView.calendarDelegate = self
        self.menuView.menuViewDelegate = self
        
        let timeZoneBias = 480 // (UTC+08:00)

        
        currentCalendar = Calendar(identifier: .gregorian)
        currentCalendar?.locale = Locale(identifier: "fr_FR")
        if let timeZone = TimeZone(secondsFromGMT: -timeZoneBias * 60) {
            currentCalendar?.timeZone = timeZone
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.calendarView.commitCalendarViewUpdate()
        self.menuView.commitMenuViewUpdate()
    }
    
    //MARK: - Private methods
    
    private func setUpCalendar(){
        view.backgroundColor = .white
        view.addSubview(calendarView)
//calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.backgroundColor = .yellow
//        let leading = calendarView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 5)
//        let trailing = calendarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 5)
//        let height = calendarView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 1/4)
//        let top = calendarView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10)
//
//        NSLayoutConstraint.activate([leading,trailing,height,top])
        
        self.calendarView = CVCalendarView(frame: CGRect(x: 0, y: 20, width: 300, height: 100))

        self.menuView = CVCalendarMenuView(frame: CGRect(x:0, y:0,width:300,height: 15))


    }
    
}

extension CalendarViewController: CVCalendarMenuViewDelegate,CVCalendarViewDelegate{
    // MARK: Required methods
    
    func presentationMode() -> CalendarMode { return .monthView }
    
    func firstWeekday() -> Weekday { return .sunday }
    
    func calendar() -> Calendar? { return currentCalendar }

}



