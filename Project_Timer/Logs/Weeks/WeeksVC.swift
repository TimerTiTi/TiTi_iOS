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
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var graphsScrollView: UIScrollView!
    @IBOutlet weak var graphsContentView: UIView!
    private var standardWeekGraphView = StandardWeekGraphView()
    
    private var colorIndex: Int = 1
    private var isReverseColor: Bool = false
    private var viewModel: WeeksVM?
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCalender()
        self.fetchColor()
        self.updateCalendarColor()
        self.configureGraphs()
        self.configureCollectionViewDelegate()
        self.configureViewModel()
        self.configureHostingVC()
        self.bindAll()
        
        #if targetEnvironment(macCatalyst)
        self.configureCalenderHorizontalButtons()
        #endif
        
        self.viewModel?.selectDate(to: RecordController.shared.daily.day.zeroDate.localDate)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: LogVC.changePageIndex, object: nil, userInfo: ["pageIndex" : 2])
        self.fetchColor()
        self.updateCalendarColor()
        self.viewModel?.updateColor()
        self.viewModel?.updateCurrentDate()
        self.calendar.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.standardWeekGraphView.updateDarkLightMode()
        self.updateGraphsFromWeekData()
        self.updateGraphsFromTasks()
    }
    
    @IBAction func changeColor(_ sender: UIButton) {
        UserDefaultsManager.set(to: sender.tag, forKey: .startColor)
        if self.colorIndex == sender.tag {
            self.isReverseColor.toggle()
        }
        self.colorIndex = sender.tag
        UserDefaultsManager.set(to: self.colorIndex, forKey: .startColor)
        UserDefaultsManager.set(to: self.isReverseColor, forKey: .reverseColor)
        self.updateCalendarColor()
        self.viewModel?.updateColor()
        self.updateGraphsFromWeekData()
        self.updateGraphsFromTasks()
    }
    
    @IBAction func saveGraphsToLibrary(_ sender: Any) {
        self.saveGraphs()
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

// MARK: save images
extension WeeksVC {
    private func saveGraphs() {
        #if targetEnvironment(macCatalyst)
        guard let week = self.viewModel?.selectedDate.localDate.YYYYMMstypeString else { return }
        guard let fileURLs = IOUsecase.saveImagesToMAC(views: [self.standardWeekGraphView], fileName: week) else {
            self.showAlertWithOK(title: "Save Failed", text: "")
            return
        }
        let controller = UIDocumentPickerViewController(forExporting: fileURLs)
        controller.delegate = self
        present(controller, animated: true, completion: nil)
        #else
        IOUsecase.saveImagesToIOS(views: [self.standardWeekGraphView])
        self.showAlertWithOK(title: "Save Completed".localized(), text: "")
        #endif
    }
}

extension WeeksVC: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let week = self.viewModel?.selectedDate.localDate.YYYYMMstypeString else { return }
        self.showAlertWithOK(title: "Save Completed".localized(), text: "\(week)")
    }
}

extension WeeksVC {
    private func configureCalender() {
        self.calendar.delegate = self
        self.calendar.dataSource = self
        self.calendar.appearance.headerDateFormat = "yyyy.MM"
        self.calendar.appearance.headerTitleFont = TiTiFont.HGGGothicssiP80g(size: 25)
        self.calendar.appearance.weekdayFont = TiTiFont.HGGGothicssiP80g(size: 13)
        self.calendar.appearance.titleFont = TiTiFont.HGGGothicssiP60g(size: 18)
        self.calendar.clipsToBounds = true
        self.calendar.layer.cornerCurve = .continuous
        self.calendar.layer.borderWidth = 2
        self.calendar.layer.cornerRadius = 25
        
        self.calendar.appearance.todayColor = UIColor.clear
        self.calendar.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
        self.calendar.backgroundColor = UIColor(named: "Background_second")
    }
    
    private func updateCalendarColor() {
        let color = UIColor(named: "D\(self.colorIndex)")
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
    
    private func configureCollectionViewDelegate() {
        self.standardWeekGraphView.configureDelegate(self)
    }
    
    private func configureViewModel() {
        self.viewModel = WeeksVM()
    }
    
    private func configureHostingVC() {
        guard let timelineVM = self.viewModel?.timelineVM else { return }
        let hostingStandardVC = UIHostingController(rootView: WeekTimelineView(frameHeight: 140, viewModel: timelineVM))
        addChild(hostingStandardVC)
        hostingStandardVC.didMove(toParent: self)
        
        self.standardWeekGraphView.configureTimelineLayout(hostingStandardVC.view)
    }
    
    private func configureCalenderHorizontalButtons() {
        let rightButton = RightButton()
        rightButton.addAction(UIAction(handler: { [weak self] _ in
            guard let scrollView = self?.calendar.collectionView else { return }
            let current = scrollView.contentOffset.x / scrollView.frame.size.width
            scrollView.scrollHorizontalToPage(frame: scrollView.frame, to: Int(current)+1)
        }), for: .touchUpInside)
        
        let leftButton = LeftButton()
        leftButton.addAction(UIAction(handler: { [weak self] _ in
            guard let scrollView = self?.calendar.collectionView else { return }
            let current = scrollView.contentOffset.x / scrollView.frame.size.width
            scrollView.scrollHorizontalToPage(frame: scrollView.frame, to: Int(current)-1)
        }), for: .touchUpInside)
        
        self.contentView.addSubview(leftButton)
        NSLayoutConstraint.activate([
            leftButton.trailingAnchor.constraint(equalTo: self.calendar.leadingAnchor, constant: -10),
            leftButton.centerYAnchor.constraint(equalTo: self.calendar.centerYAnchor)
        ])
        self.contentView.addSubview(rightButton)
        NSLayoutConstraint.activate([
            rightButton.leadingAnchor.constraint(equalTo: self.calendar.trailingAnchor, constant: 10),
            rightButton.centerYAnchor.constraint(equalTo: self.calendar.centerYAnchor)
        ])
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
            .sink(receiveValue: { [weak self] _ in
                self?.updateGraphsFromTasks()
            })
            .store(in: &self.cancellables)
    }
}

extension WeeksVC {
    private func fetchColor() {
        self.colorIndex = UserDefaultsManager.get(forKey: .startColor) as? Int ?? 1
        self.isReverseColor = UserDefaultsManager.get(forKey: .reverseColor) as? Bool ?? false
    }
    
    private func updateGraphsFromWeekData() {
        guard let weekData = self.viewModel?.weekData else { return }
        self.standardWeekGraphView.updateFromWeekData(weekData)
    }
    
    private func updateGraphsFromTasks() {
        let tasks = self.viewModel?.top5Tasks ?? []
        self.standardWeekGraphView.reload()
        self.standardWeekGraphView.layoutIfNeeded()
        self.standardWeekGraphView.progressView.updateProgress(tasks: tasks, width: .small, isReversColor: self.isReverseColor)
    }
}


extension WeeksVC: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.viewModel?.selectedDate = date
        self.viewModel?.selectDate(to: date.zeroDate.localDate)
    }
}

extension WeeksVC: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return RecordController.shared.dailys.dates.contains(date) ? 1 : 0
    }
}

extension WeeksVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.top5Tasks.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StandardWeekTaskCell.identifier, for: indexPath) as? StandardWeekTaskCell else { return .init() }
        guard let taskInfo = self.viewModel?.top5Tasks[safe: indexPath.item] else { return cell }
        cell.configure(index: indexPath.item, taskInfo: taskInfo, isReversColor: self.isReverseColor)
        return cell
    }
}
