//
//  WeeksVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/07/30.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit
import Combine
import SwiftUI
import FSCalendar

final class WeeksVC: UIViewController {
    static let identifier = "WeeksVC"
    @IBOutlet var calendar: FSCalendar!
    @IBOutlet weak var graphsScrollView: UIScrollView!
    @IBOutlet weak var graphsContentView: UIView!
    private var standardWeekGraphView = StandardWeekGraphView()
    
    private var viewModel: WeeksVM?
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCalender()
        self.updateCalendarColor()
        self.configureGraphs()
        
        self.configureViewModel()
        self.bindAll()
        
        self.viewModel?.selectDate(to: RecordController.shared.daily.day.localDate)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: LogVC.changePageIndex, object: nil, userInfo: ["pageIndex" : 2])
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.updateGraphsFromWeekData()
    }
    
    @IBAction func changeColor(_ sender: UIButton) {
        self.updateGraphsFromWeekData()
    }
    
    @IBAction func saveGraphsToLibrary(_ sender: Any) {
        
    }
    
    @IBAction func shareGraphs(_ sender: UIButton) {
        let images = [UIImage(view: self.standardWeekGraphView)]
        
        let activityViewController = UIActivityViewController(activityItems: images, applicationActivities: nil)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.popoverPresentationController?.sourceRect = sender.frame
        }
        
        self.present(activityViewController, animated: true)
    }
}

extension WeeksVC {
    private func configureCalender() {
        self.calendar.delegate = self
        self.calendar.dataSource = self
        self.calendar.appearance.headerDateFormat = "YYYY.MM"
        self.calendar.appearance.headerTitleFont = TiTiFont.HGGGothicssiP80g(size: 25)
        self.calendar.appearance.weekdayFont = TiTiFont.HGGGothicssiP80g(size: 13)
        self.calendar.appearance.titleFont = TiTiFont.HGGGothicssiP60g(size: 20)
        self.calendar.clipsToBounds = true
        self.calendar.layer.cornerCurve = .continuous
        self.calendar.layer.borderWidth = 2
        self.calendar.layer.cornerRadius = 25
        
        self.calendar.appearance.todayColor = UIColor.clear
        self.calendar.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
        self.calendar.backgroundColor = UIColor(named: "Background_second")
    }
    
    private func updateCalendarColor() {
        let color = UIColor(named: String.userTintColor)
        self.calendar.appearance.eventSelectionColor = color?.withAlphaComponent(0.5)
        self.calendar.appearance.selectionColor = color?.withAlphaComponent(0.5)
        self.calendar.appearance.titleTodayColor = color
        self.calendar.appearance.headerTitleColor = color
        self.calendar.appearance.weekdayTextColor = color
    }
    
    private func configureGraphs() {
        self.graphsContentView.addSubview(self.standardWeekGraphView)
        NSLayoutConstraint.activate([
            self.standardWeekGraphView.topAnchor.constraint(equalTo: self.graphsContentView.topAnchor),
            self.standardWeekGraphView.leadingAnchor.constraint(equalTo: self.graphsContentView.leadingAnchor),
            self.standardWeekGraphView.trailingAnchor.constraint(equalTo: self.graphsContentView.trailingAnchor),
            self.standardWeekGraphView.bottomAnchor.constraint(equalTo: self.graphsContentView.bottomAnchor)
        ])
    }
    
    private func configureViewModel() {
        self.viewModel = WeeksVM()
    }
}

extension WeeksVC {
    private func bindAll() {
        self.bindWeekData()
        self.bindTasks()
    }
    
    private func bindWeekData() {
        self.viewModel?.$weekData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] _ in
                self?.updateGraphsFromWeekData()
            })
            .store(in: &self.cancellables)
    }
    
    private func bindTasks() {
        self.viewModel?.$top5Tasks
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] tasks in
                // MARK: 임시 로직
                print(tasks)
            })
            .store(in: &self.cancellables)
    }
}

extension WeeksVC {
    private func updateGraphsFromWeekData() {
        guard let weekData = self.viewModel?.weekData else { return }
        self.standardWeekGraphView.updateFromWeekData(weekData)
    }
}


extension WeeksVC: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.viewModel?.selectDate(to: date.localDate)
    }
}

extension WeeksVC: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return RecordController.shared.dailys.dates.contains(date) ? 1 : 0
    }
}
