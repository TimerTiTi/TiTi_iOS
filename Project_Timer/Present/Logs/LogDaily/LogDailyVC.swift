//
//  LogDailyVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/07/16.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit
import Combine
import SwiftUI
import FSCalendar
import Photos

protocol ModifyRecordDelegate: AnyObject {
    func showModifyRecordVC(daily: Daily, isReverseColor: Bool)
    func showCreateRecordVC(date: Date, isReverseColor: Bool)
}

final class LogDailyVC: UIViewController {
    static let identifier = "LogDailyVC"
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var graphsScrollView: UIScrollView!
    @IBOutlet weak var graphsContentView: UIView!
    @IBOutlet weak var graphsPageControl: UIPageControl!
    @IBOutlet weak var editRecordButton: UIButton!
    
    @IBOutlet var calendarTopConstraint: NSLayoutConstraint!
    @IBOutlet var graphScrollViewBottomConstraint: NSLayoutConstraint!
    
    private var standardDailyGraphView = StandardDailyGraphView()
    private var timeTableDailyGraphView = TimeTableDailyGraphView()
    private var timelineDailyGraphView = TimelineDailyGraphView()
    private var tasksProgressDailyGraphView = TasksProgressDailyGraphView()
    private var checkGraphButtons: [CheckGraphButton] = []
    private var isGraphChecked: [Bool] = [true, true, true, true] {
        didSet {
            UserDefaultsManager.set(to: isGraphChecked, forKey: .checks)
        }
    }
    private weak var delegate: ModifyRecordDelegate?
    private var colorIndex: Int = 1
    private var isReverseColor: Bool = false
    private var viewModel: LogDailyVM?
    private var cancellables: Set<AnyCancellable> = []
    enum GraphCollectionView: Int {
        case standardDailyGraphView = 0
        case timeTableDailyGraphView = 1
        case tasksProgressDailyGraphView = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCalender()
        self.fetchColor()
        self.updateCalendarColor()
        self.configureScrollView()
        self.configurePage()
        self.configureGraphs()
        self.configureChecks()
        self.configureCheckGraphs()
        self.configureCollectionViewDelegate()
        self.configureViewModel()
        self.configureHostingVC()
        self.bindAll()
        
        #if targetEnvironment(macCatalyst)
        self.configureCalenderHorizontalButtons()
        self.configureGraphHorizontalButtons()
        self.configureBiggerUI()
        #endif
        
        self.viewModel?.updateDaily(to: RecordsManager.shared.dailyManager.currentDaily)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: LogVC.changePageIndex, object: nil, userInfo: ["pageIndex" : 1])
        self.fetchColor()
        self.updateCalendarColor()
        self.viewModel?.updateColor()
        self.viewModel?.updateCurrentDaily()
        self.calendar.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.standardDailyGraphView.updateDarkLightMode()
        self.timeTableDailyGraphView.updateDarkLightMode()
        self.timelineDailyGraphView.updateDarkLightMode()
        self.tasksProgressDailyGraphView.updateDarkLightMode()
        self.updateGraphsFromDaily()
        self.updateGraphsFromTasks()
    }
    
    @IBAction func changeColor(_ sender: UIButton) {
        if self.colorIndex == sender.tag {
            self.isReverseColor.toggle()
        }
        self.colorIndex = sender.tag
        UserDefaultsManager.set(to: self.colorIndex, forKey: .startColor)
        UserDefaultsManager.set(to: self.isReverseColor, forKey: .reverseColor)
        self.updateCalendarColor()
        self.viewModel?.updateColor()
        self.updateGraphsFromDaily()
        self.updateGraphsFromTasks()
    }
    
    @IBAction func saveGraphsToLibrary(_ sender: Any) {
        self.saveGraphs()
    }
    
    @IBAction func shareGraphs(_ sender: UIButton) {
        let dailyGraphViews = [self.standardDailyGraphView, self.timeTableDailyGraphView, self.timelineDailyGraphView, self.tasksProgressDailyGraphView]
        let images = (0..<4).filter{ self.isGraphChecked[$0] }.map{ UIImage(view: dailyGraphViews[$0]) }
        
        let activityViewController = UIActivityViewController(activityItems: images, applicationActivities: nil)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.popoverPresentationController?.sourceRect = self.navigationController!.navigationBar.frame
        }
        
        self.present(activityViewController, animated: true)
    }
    
    @IBAction func modifyRecord(_ sender: Any) {
        if let targetDaily = self.viewModel?.currentDaily {
            FirebaseAnalytics.log(AdEvent.ad_visit(screen: AdScreen.EditRecord.rawValue, reason: "Edit"))
            self.delegate?.showModifyRecordVC(daily: targetDaily, isReverseColor: self.isReverseColor)
        } else {
            FirebaseAnalytics.log(AdEvent.ad_visit(screen: AdScreen.EditRecord.rawValue, reason: "Create"))
            guard let selectedDate = self.viewModel?.selectedDate else { return }
            self.delegate?.showCreateRecordVC(date: selectedDate, isReverseColor: self.isReverseColor)
        }
    }
}

// MARK: save images
extension LogDailyVC {
    private func saveGraphs() {
        let dailyGraphViews = [self.standardDailyGraphView, self.timeTableDailyGraphView, self.timelineDailyGraphView, self.tasksProgressDailyGraphView]
        let graphViews = (0..<4).filter({ self.isGraphChecked[$0] }).map({ dailyGraphViews[$0] })
        #if targetEnvironment(macCatalyst)
        guard let recordDay = self.viewModel?.currentDaily?.day.localDate.YYYYMMDDstyleString else { return }
        guard let fileURLs = IOUsecase.saveImagesToMAC(views: graphViews, fileName: recordDay) else {
            self.showAlertWithOK(title: "Save Failed", warningRed: "")
            return
        }
        let controller = UIDocumentPickerViewController(forExporting: fileURLs)
        controller.delegate = self
        present(controller, animated: true, completion: nil)
        #else
        IOUsecase.saveImagesToIOS(views: graphViews)
        self.showAlertWithOK(title: Localized.string(.Common_Popup_SaveCompleted), text: "")
        #endif
    }
}

extension LogDailyVC: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let recordDay = self.viewModel?.currentDaily?.day.localDate.YYYYMMDDstyleString else { return }
        self.showAlertWithOK(title: Localized.string(.Common_Popup_SaveCompleted), text: "\(recordDay)")
    }
}

extension LogDailyVC {
    func configureDelegate(to delegate: ModifyRecordDelegate) {
        self.delegate = delegate
    }
}

extension LogDailyVC {
    private func configureCalender() {
        self.calendar.delegate = self
        self.calendar.dataSource = self
        self.calendar.appearance.headerDateFormat = "yyyy.MM"
        self.calendar.appearance.headerTitleFont = Fonts.HGGGothicssiP80g(size: 25)
        self.calendar.appearance.weekdayFont = Typographys.uifont(.bold_5, size: 13)
        self.calendar.appearance.titleFont = Fonts.HGGGothicssiP60g(size: 18)
        self.calendar.clipsToBounds = true
        self.calendar.layer.cornerCurve = .continuous
        self.calendar.layer.borderWidth = 2
        self.calendar.layer.cornerRadius = 25
        
        self.calendar.appearance.todayColor = UIColor.clear
        self.calendar.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
        self.calendar.backgroundColor = UIColor(named: "Background_second")
        self.calendar.locale = Language.currentLocale
    }
    
    private func updateCalendarColor() {
        let color = UIColor(named: "D\(self.colorIndex)")
        self.calendar.appearance.eventSelectionColor = color?.withAlphaComponent(0.5)
        self.calendar.appearance.selectionColor = color?.withAlphaComponent(0.5)
        self.calendar.appearance.titleTodayColor = color
        self.calendar.appearance.headerTitleColor = color
        self.calendar.appearance.weekdayTextColor = color
    }
    
    private func configureScrollView() {
        self.graphsScrollView.delegate = self
    }
    
    private func configurePage() {
        let page = UserDefaultsManager.get(forKey: .lastDailyGraphForm) as? Int ?? 0
        self.graphsScrollView.configureScrollHorizontalPage(frame: self.graphsScrollView.frame, to: page)
    }
    
    private func configureGraphs() {
        self.graphsContentView.addSubview(self.standardDailyGraphView)
        NSLayoutConstraint.activate([
            self.standardDailyGraphView.topAnchor.constraint(equalTo: self.graphsContentView.topAnchor),
            self.standardDailyGraphView.leadingAnchor.constraint(equalTo: self.graphsContentView.leadingAnchor),
            self.standardDailyGraphView.bottomAnchor.constraint(equalTo: self.graphsContentView.bottomAnchor)
        ])
        
        self.graphsContentView.addSubview(self.timeTableDailyGraphView)
        NSLayoutConstraint.activate([
            self.timeTableDailyGraphView.topAnchor.constraint(equalTo: self.graphsContentView.topAnchor),
            self.timeTableDailyGraphView.leadingAnchor.constraint(equalTo: self.standardDailyGraphView.trailingAnchor),
            self.timeTableDailyGraphView.bottomAnchor.constraint(equalTo: self.graphsContentView.bottomAnchor)
        ])
        
        self.graphsContentView.addSubview(self.timelineDailyGraphView)
        NSLayoutConstraint.activate([
            self.timelineDailyGraphView.topAnchor.constraint(equalTo: self.graphsContentView.topAnchor),
            self.timelineDailyGraphView.leadingAnchor.constraint(equalTo: self.timeTableDailyGraphView.trailingAnchor),
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
        guard checks.count == 4 else {
            self.isGraphChecked = [checks[0], true, checks[1], checks[2]]
            return
        }
        self.isGraphChecked = checks
    }
    
    private func configureCheckGraphs() {
        (0...3).forEach { idx in
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
            self.checkGraphButtons[1].topAnchor.constraint(equalTo: self.timeTableDailyGraphView.topAnchor, constant: 73),
            self.checkGraphButtons[1].leadingAnchor.constraint(equalTo: self.timeTableDailyGraphView.leadingAnchor, constant: 25)
        ])
        
        self.graphsContentView.addSubview(self.checkGraphButtons[2])
        NSLayoutConstraint.activate([
            self.checkGraphButtons[2].topAnchor.constraint(equalTo: self.timelineDailyGraphView.topAnchor, constant: 25),
            self.checkGraphButtons[2].leadingAnchor.constraint(equalTo: self.timelineDailyGraphView.leadingAnchor, constant: 25)
        ])
        
        self.graphsContentView.addSubview(self.checkGraphButtons[3])
        NSLayoutConstraint.activate([
            self.checkGraphButtons[3].topAnchor.constraint(equalTo: self.tasksProgressDailyGraphView.topAnchor, constant: 25),
            self.checkGraphButtons[3].leadingAnchor.constraint(equalTo: self.tasksProgressDailyGraphView.leadingAnchor, constant: 25)
        ])
    }
    
    private func configureCollectionViewDelegate() {
        self.standardDailyGraphView.configureDelegate(self)
        self.timeTableDailyGraphView.configureDelegate(self)
        self.tasksProgressDailyGraphView.configureDelegate(self)
    }
    
    private func configureViewModel() {
        self.viewModel = LogDailyVM()
    }
    
    private func configureHostingVC() {
        guard let timelineVM = self.viewModel?.timelineVM else { return }
        let hostingStandardVC = UIHostingController(rootView: TimelineView(frameHeight: 100, viewModel: timelineVM))
        addChild(hostingStandardVC)
        hostingStandardVC.didMove(toParent: self)
        
        self.standardDailyGraphView.configureTimelineLayout(hostingStandardVC.view)
        
        guard let timeTableVM = self.viewModel?.timeTableVM else { return }
        let hostingTimeTableVC = UIHostingController(rootView: TimeTableView(frameSize: CGSize(width: 105, height: 274.333), viewModel: timeTableVM))
        addChild(hostingTimeTableVC)
        hostingTimeTableVC.didMove(toParent: self)
        
        self.timeTableDailyGraphView.configureTimetableLayout(hostingTimeTableVC.view)
        
        let hostingTimelineVC = UIHostingController(rootView: TimelineView(frameHeight: 150, viewModel: timelineVM))
        addChild(hostingTimelineVC)
        hostingTimelineVC.didMove(toParent: self)
        
        self.timelineDailyGraphView.configureTimelineLayout(hostingTimelineVC.view)
    }
}

// MARK: Configure for Mac
extension LogDailyVC {
    private func configureCalenderHorizontalButtons() {
        let rightButton = ChangeNextGraphButton()
        rightButton.addAction(UIAction(handler: { [weak self] _ in
            guard let scrollView = self?.calendar.collectionView else { return }
            let current = scrollView.contentOffset.x / scrollView.frame.size.width
            scrollView.scrollHorizontalToPage(frame: scrollView.frame, to: Int(current)+1)
        }), for: .touchUpInside)
        
        let leftButton = ChangePrevGraphButton()
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
    
    private func configureGraphHorizontalButtons() {
        let rightButton = ChangeNextGraphButton()
        rightButton.addAction(UIAction(handler: { [weak self] _ in
            guard let scrollView = self?.graphsScrollView else { return }
            let current = scrollView.contentOffset.x / scrollView.frame.size.width
            if current < 3 {
                scrollView.scrollHorizontalToPage(frame: scrollView.frame, to: Int(current)+1)
            }
        }), for: .touchUpInside)
        
        let leftButton = ChangePrevGraphButton()
        leftButton.addAction(UIAction(handler: { [weak self] _ in
            guard let scrollView = self?.graphsScrollView else { return }
            let current = scrollView.contentOffset.x / scrollView.frame.size.width
            if current > 0 {
                scrollView.scrollHorizontalToPage(frame: scrollView.frame, to: Int(current)-1)
            }
        }), for: .touchUpInside)
        
        self.contentView.addSubview(leftButton)
        NSLayoutConstraint.activate([
            leftButton.trailingAnchor.constraint(equalTo: self.graphsScrollView.leadingAnchor, constant: 0),
            leftButton.centerYAnchor.constraint(equalTo: self.graphsScrollView.centerYAnchor)
        ])
        self.contentView.addSubview(rightButton)
        NSLayoutConstraint.activate([
            rightButton.leadingAnchor.constraint(equalTo: self.graphsScrollView.trailingAnchor, constant: 0),
            rightButton.centerYAnchor.constraint(equalTo: self.graphsScrollView.centerYAnchor)
        ])
    }
    
    private func configureBiggerUI() {
        let height: CGFloat = self.contentView.bounds.height
        let scale: CGFloat = 1.25
        self.calendarTopConstraint.constant = 8+((scale-1)*height/2)
        self.graphScrollViewBottomConstraint.constant = 16+((scale-1)*height/2)
        self.contentView.transform = CGAffineTransform.init(scaleX: scale, y: scale)
    }
}

extension LogDailyVC {
    private func bindAll() {
        self.bindDaily()
        self.bindTasks()
    }
    
    private func bindDaily() {
        self.viewModel?.$currentDaily
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] daily in
                self?.updateGraphsFromDaily()
                if daily != nil {
                    self?.editRecordButton.setTitle("Edit", for: .normal)
                    self?.editRecordButton.setImage(UIImage.init(systemName: "hammer"), for: .normal)
                } else {
                    self?.editRecordButton.setTitle("Create", for: .normal)
                    self?.editRecordButton.setImage(UIImage.init(systemName: "plus.app"), for: .normal)
                }
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

extension LogDailyVC {
    private func fetchColor() {
        self.colorIndex = UserDefaultsManager.get(forKey: .startColor) as? Int ?? 1
        self.isReverseColor = UserDefaultsManager.get(forKey: .reverseColor) as? Bool ?? false
    }
    
    private func updateGraphsFromDaily() {
        let daily = self.viewModel?.currentDaily
        self.standardDailyGraphView.updateFromDaily(daily)
        self.timeTableDailyGraphView.updateFromDaily(daily)
        self.timelineDailyGraphView.updateFromDaily(daily)
        self.tasksProgressDailyGraphView.updateFromDaily(daily)
    }
    
    private func updateGraphsFromTasks() {
        let tasks = self.viewModel?.tasks ?? []
        self.standardDailyGraphView.reload()
        self.standardDailyGraphView.layoutIfNeeded()
        self.standardDailyGraphView.progressView.updateProgress(tasks: tasks, width: .small, isReversColor: self.isReverseColor)
        
        self.timeTableDailyGraphView.reload()
        self.timeTableDailyGraphView.layoutIfNeeded()
        self.timeTableDailyGraphView.progressView.updateProgress(tasks: tasks, width: .small, isReversColor: self.isReverseColor)
        
        self.tasksProgressDailyGraphView.reload()
        self.tasksProgressDailyGraphView.layoutIfNeeded()
        self.tasksProgressDailyGraphView.progressView.updateProgress(tasks: tasks, width: .medium, isReversColor: self.isReverseColor)
    }
}

extension LogDailyVC: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.viewModel?.selectedDate = date
        if RecordsManager.shared.dailyManager.dates.contains(date),
           let targetIndex = RecordsManager.shared.dailyManager.dates.firstIndex(of: date) {
            self.viewModel?.updateDaily(to: RecordsManager.shared.dailyManager.dailys[targetIndex])
        } else {
            self.viewModel?.updateDaily(to: nil)
        }
    }
}

extension LogDailyVC: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return RecordsManager.shared.dailyManager.dates.contains(date) ? 1 : 0
    }
}

extension LogDailyVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.graphsScrollView else { return }
        let value = scrollView.contentOffset.x/scrollView.frame.size.width
        self.graphsPageControl.currentPage = Int(round(value))
        // 마지막 그래프 인덱스 저장
        UserDefaultsManager.set(to: Int(round(value)), forKey: .lastDailyGraphForm)
    }
}

extension LogDailyVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let graph = GraphCollectionView(rawValue: collectionView.tag) {
            switch graph {
            case .standardDailyGraphView, .timeTableDailyGraphView:
                return self.viewModel?.tasks.count ?? 0
            case .tasksProgressDailyGraphView:
                return min(8, self.viewModel?.tasks.count ?? 0)
            }
        } else { return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let graph = GraphCollectionView(rawValue: collectionView.tag) {
            switch graph {
            case .standardDailyGraphView, .timeTableDailyGraphView:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StandardDailyTaskCell.identifier, for: indexPath) as? StandardDailyTaskCell else { return .init() }
                guard let taskInfo = self.viewModel?.tasks[safe: indexPath.item] else { return cell }
                cell.configure(index: indexPath.item, taskInfo: taskInfo, isReversColor: self.isReverseColor)
                return cell
            case .tasksProgressDailyGraphView:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressDailyTaskCell.identifier, for: indexPath) as? ProgressDailyTaskCell else { return .init() }
                guard let taskInfo = self.viewModel?.tasks[safe: indexPath.item] else { return cell }
                cell.configure(index: indexPath.item, taskInfo: taskInfo, isReversColor: self.isReverseColor)
                return cell
            }
        } else { return .init() }
    }
}

extension LogDailyVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let graph = GraphCollectionView(rawValue: collectionView.tag) {
            switch graph {
            case .standardDailyGraphView, .timeTableDailyGraphView:
                return CGSize(width: collectionView.bounds.width, height: StandardDailyTaskCell.height)
            case .tasksProgressDailyGraphView:
                return CGSize(width: collectionView.bounds.width, height: ProgressDailyTaskCell.height)
            }
        } else { return .zero }
    }
}
