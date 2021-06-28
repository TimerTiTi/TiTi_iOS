//
//  ViewController.swift
//  calanderTest
//
//  Created by Kang Minsang on 2021/06/28.
//

import UIKit
import FSCalendar

class calendarViewController: UIViewController {

    @IBOutlet var calendar: FSCalendar!
    @IBOutlet var frame: UIView!
    @IBOutlet var backBT: UIButton!
    let dateFormatter = DateFormatter()
    var dumyDays: [Date] = []
    var colorIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        frame.layer.cornerRadius = 25
        dateFormatter.dateFormat = "yyyy.MM.dd"
        getColor()
        
        calendar.appearance.headerDateFormat = "YYYY.MM"
//        calendar.appearance.borderRadius = 0.6
//        UIFont(name: "HGGGothicssiP60g", size: 35)
        calendar.appearance.headerTitleFont = UIFont(name: "HGGGothicssiP60g", size: 25)
        calendar.appearance.weekdayFont = UIFont(name: "HGGGothicssiP60g", size: 13)
        calendar.appearance.titleFont = UIFont(name: "HGGGothicssiP60g", size: 20)
        
        let color = UIColor(named: "D\(colorIndex)")
        let color2 = UIColor(named: "D\(colorIndex)")!.withAlphaComponent(0.5)
        calendar.appearance.todayColor = UIColor.systemRed.withAlphaComponent(0.5)
        calendar.appearance.headerTitleColor = color
        calendar.appearance.weekdayTextColor = color
        calendar.appearance.selectionColor = color2
        calendar.appearance.eventSelectionColor = color2
        calendar.appearance.eventDefaultColor = UIColor.systemRed.withAlphaComponent(0.5)
        backBT.tintColor = color
        
        dumyDays = getDumyNSDays(getDumyDays())
    }

    @IBAction func back(_ sender: UIButton) {
        if(sender.currentTitle != "NO DATA") {
            //날짜 보내기
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // FSCalendarDataSource
    func calendar(calendar: FSCalendar!, hasEventForDate date: NSDate!) -> Bool {
        return true
    }
    
    func getDumyDays() -> [String] {
        var days: [String] = []
        days.append("2021.05.30")
        days.append("2021.06.11")
        days.append("2021.06.20")
        days.append("2021.06.22")
        days.append("2021.06.25")
        days.append("2021.06.28")
        return days
    }
    
    func getDumyNSDays(_ stringDays: [String]) -> [Date] {
        var days: [Date] = []
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY.MM.dd"
        for day in stringDays {
            let tempDay: Date = formatter.date(from: day)!
            days.append(tempDay)
        }
        return days
    }
    
    func showDayEvents(_ dumyDays: [NSDate]) {
        for day in dumyDays {
            calendar(calendar: calendar, hasEventForDate: day)
        }
    }
    
    func getColor() {
        colorIndex = UserDefaults.standard.value(forKey: "startColor") as? Int ?? 1
    }
}



extension calendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    //이벤트 표시 개수
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if self.dumyDays.contains(date) {
            return 1
        } else {
            return 0
        }
    }
    
    // 날짜 선택 시 콜백 메소드
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(dateFormatter.string(from: date) + " 선택됨")
        if(dumyDays.contains(date)) {
            backBT.setTitle(dateFormatter.string(from: date), for: .normal)
        } else {
            backBT.setTitle("NO DATA", for: .normal)
        }
        
    }
    
}

