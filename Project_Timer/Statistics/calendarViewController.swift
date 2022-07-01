//
//  ViewController.swift
//  calanderTest
//
//  Created by Kang Minsang on 2021/06/28.
//

import UIKit
import FSCalendar

protocol selectCalendar {
    func getDailyIndex()
}

class calendarViewController: UIViewController {

    @IBOutlet var calendar: FSCalendar!
    @IBOutlet var frame: UIView!
    @IBOutlet var backBT: UIButton!
    
    let dateFormatter = DateFormatter()
    var dumyDays: [Date] = []
    var colorIndex: Int = 0
    var calendarViewControllerDelegate : selectCalendar!
    
    var dailyViewModel = DailyViewModel()
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        frame.layer.cornerRadius = 25
        dateFormatter.dateFormat = "yyyy.MM.dd"
        getColor()
        
        setCalendar()
        setColor()

        dailyViewModel.loadDailys()
    }

    @IBAction func back(_ sender: UIButton) {
        if(sender.currentTitle != "NO DATA" && index != nil) {
            UserDefaults.standard.setValue(index, forKey: "dateIndex")
            calendarViewControllerDelegate.getDailyIndex()
            self.dismiss(animated: true, completion: nil)
        }
    }
}


extension calendarViewController {
    func setCalendar() {
        calendar.appearance.headerDateFormat = "YYYY.MM"
        calendar.appearance.headerTitleFont = TiTiFont.HGGGothicssiP60g(size: 25)
        calendar.appearance.weekdayFont = TiTiFont.HGGGothicssiP60g(size: 13)
        calendar.appearance.titleFont = TiTiFont.HGGGothicssiP60g(size: 20)
    }
    
    func setColor() {
        let color = UIColor(named: "D\(colorIndex)")
        let color2 = UIColor(named: "D\(colorIndex)")!.withAlphaComponent(0.5)
        calendar.appearance.todayColor = UIColor.systemRed.withAlphaComponent(0.5)
        calendar.appearance.headerTitleColor = color
        calendar.appearance.weekdayTextColor = color
        calendar.appearance.selectionColor = color2
        calendar.appearance.eventSelectionColor = color2
        calendar.appearance.eventDefaultColor = UIColor.systemRed.withAlphaComponent(0.5)
        backBT.tintColor = color
    }
    
    func getColor() {
        colorIndex = UserDefaults.standard.value(forKey: "startColor") as? Int ?? 1
    }
}


extension calendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    //이벤트 표시 개수
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if self.dailyViewModel.dates.contains(date) {
            return 1
        } else {
            return 0
        }
    }
    
    // 날짜 선택 시 콜백 메소드
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(dateFormatter.string(from: date) + " 선택됨")
        if(self.dailyViewModel.dates.contains(date)) {
            index = Int("\(self.dailyViewModel.dates.firstIndex(of: date)!)")!
            print("index : ",index!)
            backBT.setTitle(dateFormatter.string(from: date), for: .normal)
        } else {
            backBT.setTitle("NO DATA", for: .normal)
        }
        
    }
    
}

