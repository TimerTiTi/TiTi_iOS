//
//  DailysVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/07/16.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit
import FSCalendar

final class DailysVC: UIViewController {
    static let identifier = "DailysVC"
    @IBOutlet var calendar: FSCalendar!
    
    let dateFormatter = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCalender()
        self.configureColor()
        
    }
}

extension DailysVC {
    private func configureCalender() {
        self.calendar.appearance.headerDateFormat = "YYYY.MM"
        self.calendar.appearance.headerTitleFont = TiTiFont.HGGGothicssiP60g(size: 25)
        self.calendar.appearance.weekdayFont = TiTiFont.HGGGothicssiP60g(size: 13)
        self.calendar.appearance.titleFont = TiTiFont.HGGGothicssiP60g(size: 20)
        self.calendar.clipsToBounds = true
        self.calendar.layer.cornerCurve = .continuous
        self.calendar.layer.borderWidth = 2
        self.calendar.layer.cornerRadius = 25
    }
    
    private func configureColor() {
        let color = UIColor(named: String.userTintColor)
        self.calendar.appearance.todayColor = UIColor.systemRed.withAlphaComponent(0.5)
        self.calendar.appearance.headerTitleColor = color
        self.calendar.appearance.weekdayTextColor = color
        self.calendar.appearance.selectionColor = color?.withAlphaComponent(0.5)
        self.calendar.appearance.eventSelectionColor = color?.withAlphaComponent(0.5)
        self.calendar.appearance.eventDefaultColor = UIColor.systemRed.withAlphaComponent(0.5)
        self.calendar.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
    }
}

extension DailysVC: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if RecordController.shared.dailys.dates.contains(date),
           let targetIndex = RecordController.shared.dailys.dates.firstIndex(of: date) {
            let targetDaily = RecordController.shared.dailys.dailys[targetIndex]
            // daily 교체 로직
            dump(targetDaily)
        } else {
            // 기록이 없는 날 로직
            print("no records")
        }
    }
}

extension DailysVC: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return RecordController.shared.dailys.dates.contains(date) ? 1 : 0
    }
}
