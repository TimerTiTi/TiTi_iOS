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
    @IBOutlet weak var graphsScrollView: UIScrollView!
    @IBOutlet weak var graphsContentView: UIView!
    @IBOutlet weak var graphsPageControl: UIPageControl!
    private var graph1: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 365),
            view.heightAnchor.constraint(equalToConstant: 365)
        ])
        view.backgroundColor = .blue
        return view
    }()
    private var graph2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 365),
            view.heightAnchor.constraint(equalToConstant: 365)
        ])
        view.backgroundColor = .green
        return view
    }()
    private var graph3: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 365),
            view.heightAnchor.constraint(equalToConstant: 365)
        ])
        view.backgroundColor = .orange
        return view
    }()
    
    let dateFormatter = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCalender()
        self.configureColor()
        self.configureScrollView()
        self.configureGraphs()
    }
    
    @IBAction func changeColor(_ sender: UIButton) {
        print(sender.tag)
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
    
    private func configureScrollView() {
        self.graphsScrollView.delegate = self
    }
    
    private func configureGraphs() {
        self.graphsScrollView.addSubview(self.graph1)
        NSLayoutConstraint.activate([
            self.graph1.topAnchor.constraint(equalTo: self.graphsContentView.topAnchor),
            self.graph1.leadingAnchor.constraint(equalTo: self.graphsContentView.leadingAnchor),
            self.graph1.bottomAnchor.constraint(equalTo: self.graphsContentView.bottomAnchor)
        ])
        
        self.graphsScrollView.addSubview(self.graph2)
        NSLayoutConstraint.activate([
            self.graph2.topAnchor.constraint(equalTo: self.graphsContentView.topAnchor),
            self.graph2.leadingAnchor.constraint(equalTo: self.graph1.trailingAnchor),
            self.graph2.bottomAnchor.constraint(equalTo: self.graphsContentView.bottomAnchor)
        ])
        
        self.graphsScrollView.addSubview(self.graph3)
        NSLayoutConstraint.activate([
            self.graph3.topAnchor.constraint(equalTo: self.graphsContentView.topAnchor),
            self.graph3.leadingAnchor.constraint(equalTo: self.graph2.trailingAnchor),
            self.graph3.bottomAnchor.constraint(equalTo: self.graphsContentView.bottomAnchor),
            self.graph3.trailingAnchor.constraint(equalTo: self.graphsContentView.trailingAnchor)
        ])
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

extension DailysVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.graphsScrollView else { return }
        let value = scrollView.contentOffset.x/scrollView.frame.size.width
        self.graphsPageControl.currentPage = Int(round(value))
    }
}
