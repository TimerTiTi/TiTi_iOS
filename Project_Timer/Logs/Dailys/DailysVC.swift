//
//  DailysVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/07/16.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit
import Combine
import SwiftUI
import FSCalendar

final class DailysVC: UIViewController {
    static let identifier = "DailysVC"
    @IBOutlet var calendar: FSCalendar!
    @IBOutlet weak var graphsScrollView: UIScrollView!
    @IBOutlet weak var graphsContentView: UIView!
    @IBOutlet weak var graphsPageControl: UIPageControl!
    private var standardDailyGraphView = StandardDailyGraphView()
    private var timelineDailyGraphView = TimelineDailyGraphView()
    private var tasksProgressDailyGraphView = TasksProgressDailyGraphView()
    private var checkGraphButtons: [CheckGraphButton] = []
    private var isGraphChecked: [Bool] = [true, true, true] {
        didSet {
            UserDefaultsManager.set(to: isGraphChecked, forKey: .checks)
        }
    }
    private var previusColorIndex: Int?
    private var isReversColor: Bool = false
    private var viewModel: DailysVM?
    private var cancellables: Set<AnyCancellable> = []
    enum GraphCollectionView: Int {
        case standardDailyGraphView = 0
        case tasksProgressDailyGraphView = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCalender()
        self.updateCalendarColor()
        self.configureScrollView()
        self.configureGraphs()
        self.configureChecks()
        self.configureCheckGraphs()
        self.configureCollectionViewDelegate()
        self.configureViewModel()
        self.configureHostingVC()
        self.bindAll()
        
        self.viewModel?.updateDaily(to: RecordController.shared.daily)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.standardDailyGraphView.updateDarkLightMode()
        self.timelineDailyGraphView.updateDarkLightMode()
        self.tasksProgressDailyGraphView.updateDarkLightMode()
        self.updateGraphsFromDaily()
        self.updateGraphsFromTasks()
    }
    
    @IBAction func changeColor(_ sender: UIButton) {
        UserDefaultsManager.set(to: sender.tag, forKey: .startColor)
        if self.previusColorIndex == sender.tag {
            self.isReversColor.toggle()
        } else {
            self.isReversColor = false
        }
        self.previusColorIndex = sender.tag
        self.updateCalendarColor()
        self.viewModel?.updateColor(isReverseColor: self.isReversColor)
        self.updateGraphsFromDaily()
        self.updateGraphsFromTasks()
    }
    
    @IBAction func saveGraphsToLibrary(_ sender: Any) {
        let dailyGraphViews = [self.standardDailyGraphView, self.timelineDailyGraphView, self.tasksProgressDailyGraphView]
                
        for i in 0..<3 {
            if self.isGraphChecked[i] == true {
                let graphImage = UIImage(view: dailyGraphViews[i])
                UIImageWriteToSavedPhotosAlbum(graphImage, nil, nil, nil)
            }
        }
        self.showAlertWithOK(title: "Save completed".localized(), text: "")
    }
    
    @IBAction func shareGraphs(_ sender: UIButton) {
        let dailyGraphViews = [self.standardDailyGraphView, self.timelineDailyGraphView, self.tasksProgressDailyGraphView]
        let images = (0..<3).filter{ self.isGraphChecked[$0] }.map{ UIImage(view: dailyGraphViews[$0]) }
        
        let activityViewController = UIActivityViewController(activityItems: images, applicationActivities: nil)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.popoverPresentationController?.sourceRect = sender.frame
        }
        
        self.present(activityViewController, animated: true)
    }
}

extension DailysVC {
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
    
    private func configureScrollView() {
        self.graphsScrollView.delegate = self
    }
    
    private func configureGraphs() {
        self.graphsContentView.addSubview(self.standardDailyGraphView)
        NSLayoutConstraint.activate([
            self.standardDailyGraphView.topAnchor.constraint(equalTo: self.graphsContentView.topAnchor),
            self.standardDailyGraphView.leadingAnchor.constraint(equalTo: self.graphsContentView.leadingAnchor),
            self.standardDailyGraphView.bottomAnchor.constraint(equalTo: self.graphsContentView.bottomAnchor)
        ])
        
        self.graphsContentView.addSubview(self.timelineDailyGraphView)
        NSLayoutConstraint.activate([
            self.timelineDailyGraphView.topAnchor.constraint(equalTo: self.graphsContentView.topAnchor),
            self.timelineDailyGraphView.leadingAnchor.constraint(equalTo: self.standardDailyGraphView.trailingAnchor),
            self.timelineDailyGraphView.bottomAnchor.constraint(equalTo: self.graphsContentView.bottomAnchor)
        ])
        
        self.graphsContentView.addSubview(self.tasksProgressDailyGraphView)
        NSLayoutConstraint.activate([
            self.tasksProgressDailyGraphView.topAnchor.constraint(equalTo: self.graphsContentView.topAnchor),
            self.tasksProgressDailyGraphView.leadingAnchor.constraint(equalTo: self.timelineDailyGraphView.trailingAnchor),
            self.tasksProgressDailyGraphView.bottomAnchor.constraint(equalTo: self.graphsContentView.bottomAnchor),
            self.tasksProgressDailyGraphView.trailingAnchor.constraint(equalTo: self.graphsContentView.trailingAnchor)
        ])
    }
    
    private func configureChecks() {
        guard let checks = UserDefaultsManager.get(forKey: .checks) as? [Bool] else { return }
        self.isGraphChecked = checks
    }
    
    private func configureCheckGraphs() {
        (0...2).forEach { idx in
            let button = CheckGraphButton()
            button.isSelected = self.isGraphChecked[idx]
            button.addAction(UIAction(handler: { [weak self] _ in
                button.isSelected.toggle()
                self?.isGraphChecked[idx].toggle()
            }), for: .touchUpInside)
            self.checkGraphButtons.append(button)
        }
        
        self.graphsContentView.addSubview(self.checkGraphButtons[0])
        NSLayoutConstraint.activate([
            self.checkGraphButtons[0].topAnchor.constraint(equalTo: self.standardDailyGraphView.topAnchor, constant: 73),
            self.checkGraphButtons[0].leadingAnchor.constraint(equalTo: self.standardDailyGraphView.leadingAnchor, constant: 25)
        ])
        
        self.graphsContentView.addSubview(self.checkGraphButtons[1])
        NSLayoutConstraint.activate([
            self.checkGraphButtons[1].topAnchor.constraint(equalTo: self.timelineDailyGraphView.topAnchor, constant: 25),
            self.checkGraphButtons[1].leadingAnchor.constraint(equalTo: self.timelineDailyGraphView.leadingAnchor, constant: 25)
        ])
        
        self.graphsContentView.addSubview(self.checkGraphButtons[2])
        NSLayoutConstraint.activate([
            self.checkGraphButtons[2].topAnchor.constraint(equalTo: self.tasksProgressDailyGraphView.topAnchor, constant: 25),
            self.checkGraphButtons[2].leadingAnchor.constraint(equalTo: self.tasksProgressDailyGraphView.leadingAnchor, constant: 25)
        ])
    }
    
    private func configureCollectionViewDelegate() {
        self.standardDailyGraphView.configureDelegate(self)
        self.tasksProgressDailyGraphView.configureDelegate(self)
    }
    
    private func configureViewModel() {
        self.viewModel = DailysVM()
    }
    
    private func configureHostingVC() {
        guard let timelineVM = self.viewModel?.timelineVM else { return }
        let hostingStandardVC = UIHostingController(rootView: TimelineView(frameHeight: 100, viewModel: timelineVM))
        addChild(hostingStandardVC)
        hostingStandardVC.didMove(toParent: self)
        
        self.standardDailyGraphView.configureTimelineLayout(hostingStandardVC.view)
        
        let hostingTimelineVC = UIHostingController(rootView: TimelineView(frameHeight: 150, viewModel: timelineVM))
        addChild(hostingTimelineVC)
        hostingTimelineVC.didMove(toParent: self)
        
        self.timelineDailyGraphView.configureTimelineLayout(hostingTimelineVC.view)
    }
}

extension DailysVC {
    private func bindAll() {
        self.bindDaily()
        self.bindTasks()
    }
    
    private func bindDaily() {
        self.viewModel?.$currentDaily
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] _ in
                self?.updateGraphsFromDaily()
            })
            .store(in: &self.cancellables)
    }
    
    private func bindTasks() {
        self.viewModel?.$tasks
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] _ in
                self?.updateGraphsFromTasks()
            })
            .store(in: &self.cancellables)
    }
}

extension DailysVC {
    private func updateGraphsFromDaily() {
        let daily = self.viewModel?.currentDaily
        self.standardDailyGraphView.updateFromDaily(daily)
        self.timelineDailyGraphView.updateFromDaily(daily)
        self.tasksProgressDailyGraphView.updateFromDaily(daily)
    }
    
    private func updateGraphsFromTasks() {
        let tasks = self.viewModel?.tasks ?? []
        self.standardDailyGraphView.reload()
        self.standardDailyGraphView.layoutIfNeeded()
        self.standardDailyGraphView.progressView.updateProgress(tasks: tasks, width: .small, isReversColor: self.isReversColor)
        self.tasksProgressDailyGraphView.reload()
        self.tasksProgressDailyGraphView.layoutIfNeeded()
        self.tasksProgressDailyGraphView.progressView.updateProgress(tasks: tasks, width: .medium, isReversColor: self.isReversColor)
    }
}

extension DailysVC: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if RecordController.shared.dailys.dates.contains(date),
           let targetIndex = RecordController.shared.dailys.dates.firstIndex(of: date) {
            self.viewModel?.updateDaily(to: RecordController.shared.dailys.dailys[targetIndex])
        } else {
            self.viewModel?.updateDaily(to: nil)
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

extension DailysVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let graph = GraphCollectionView(rawValue: collectionView.tag) {
            switch graph {
            case .standardDailyGraphView:
                return self.viewModel?.tasks.count ?? 0
            case .tasksProgressDailyGraphView:
                return min(8, self.viewModel?.tasks.count ?? 0)
            }
        } else { return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let graph = GraphCollectionView(rawValue: collectionView.tag) {
            switch graph {
            case .standardDailyGraphView:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StandardDailyTaskCell.identifier, for: indexPath) as? StandardDailyTaskCell else { return .init() }
                guard let taskInfo = self.viewModel?.tasks[safe: indexPath.item] else { return cell }
                cell.configure(index: indexPath.item, taskInfo: taskInfo, isReversColor: self.isReversColor)
                return cell
            case .tasksProgressDailyGraphView:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressDailyTaskCell.identifier, for: indexPath) as? ProgressDailyTaskCell else { return .init() }
                guard let taskInfo = self.viewModel?.tasks[safe: indexPath.item] else { return cell }
                cell.configure(index: indexPath.item, taskInfo: taskInfo, isReversColor: self.isReversColor)
                return cell
            }
        } else { return .init() }
    }
}

extension DailysVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let graph = GraphCollectionView(rawValue: collectionView.tag) {
            switch graph {
            case .standardDailyGraphView:
                return CGSize(width: collectionView.bounds.width, height: StandardDailyTaskCell.height)
            case .tasksProgressDailyGraphView:
                return CGSize(width: collectionView.bounds.width, height: ProgressDailyTaskCell.height)
            }
        } else { return .zero }
    }
}
