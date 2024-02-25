//
//  ModifyRecordVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/08/13.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit
import SwiftUI
import Combine
#if targetEnvironment(macCatalyst)
#else
import GoogleMobileAds
#endif

final class ModifyRecordVC: UIViewController {
    static let identifier = "ModifyRecordVC"
    
    @IBOutlet weak var graphsScrollView: UIScrollView! 
    @IBOutlet weak var graphsContentView: UIView!
    @IBOutlet weak var graphsPageControl: UIPageControl!
    @IBOutlet weak var superContentView: UIView!
    @IBOutlet weak var superContentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollViewBottom: NSLayoutConstraint!
    private var standardDailyGraphView = StandardDailyGraphView()
    private var timeTableDailyGraphView = TimeTableDailyGraphView()
    private var timelineDailyGraphView = TimelineDailyGraphView()
    private var tasksProgressDailyGraphView = TasksProgressDailyGraphView()
    private var taskInteractionFrameView = UIView()                         // 인터렉션 뷰의 프레임 뷰
    private var taskModifyInteractionView = TaskModifyInteractionView()     // 기존 Task의 기록 편집 뷰
    private var taskCreateInteractionView = TaskCreateInteractionView()     // 새로운 Task의 기록 편집 뷰
    private var taskInteratcionViewPlaceholder = TaskInteractionViewPlaceholder()   // 인터렉션뷰 placeholder
    private var taskInteractionFrameViewHeight: NSLayoutConstraint?
    private var viewModel: ModifyRecordVM?
    private var cancellables: Set<AnyCancellable> = []
    #if targetEnvironment(macCatalyst)
    #else
    private var rewardedAd: GADRewardedAd?
    #endif
    enum GraphCollectionView: Int {
        case standardDailyGraphView = 0
        case timeTableDailyGraphView = 1
        case tasksProgressDailyGraphView = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        #if targetEnvironment(macCatalyst)
        #else
        self.loadRewardedAd()
        #endif
        self.configureNavigationBar()
        self.configureScrollView()
        self.configurePage()
        self.configureTaskInteractionViews()
        self.configureGraphs()
        self.configureCollectionViewDelegate()
        self.configureTableViewDelegate()
        self.configureHostingVC()
        self.bindAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        #if targetEnvironment(macCatalyst)
        #else
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        #endif
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.standardDailyGraphView.updateDarkLightMode()
        self.timeTableDailyGraphView.updateDarkLightMode()
        self.timelineDailyGraphView.updateDarkLightMode()
        self.tasksProgressDailyGraphView.updateDarkLightMode()
        self.updateGraphsFromDaily()
        self.updateGraphsFromTasks()
        self.configureShadows(self.taskModifyInteractionView, self.taskCreateInteractionView)
    }
}

// MARK: public configure
extension ModifyRecordVC {
    func configureViewModel(daily: Daily, isReverseColor: Bool) {
        self.viewModel = ModifyRecordVM(daily: daily, isReverseColor: isReverseColor)
        self.taskInteratcionViewPlaceholder.setText(mode: .modify)
    }
    
    func configureViewModel(date: Date, isReverseColor: Bool) {
        self.viewModel = ModifyRecordVM(newDate: date, isReverseColor: isReverseColor)
        self.taskInteratcionViewPlaceholder.setText(mode: .create)
    }
}

// MARK: 네비게이션 바 구성
extension ModifyRecordVC {
    private func configureNavigationBar() {
        self.configureTitle()
        self.configureSaveButton()
        self.configureBackButton()
    }
    
    private func configureTitle() {
        guard let day = self.viewModel?.currentDaily.day else { return }
        self.title = day.YYYYMMDDstyleString
    }
    
    private func configureSaveButton() {
        let saveButton = UIBarButtonItem(title: "SAVE",
                                         style: .plain,
                                         target: self,
                                         action: #selector(saveButtonTapped))
        self.navigationItem.setRightBarButton(saveButton, animated: false)
    }

    private func configureBackButton() {
        // TODO: 이미지만 보이고 타이틀 안보임. 해결 필요
        let backButton = UIBarButtonItem(title: "",
                                         style: .done,
                                         target: self,
                                         action: #selector(backButtonTapped))
        backButton.image = UIImage(systemName: "chevron.backward")
        self.navigationItem.setLeftBarButton(backButton, animated: false)
    }
}

// MARK: 뷰 구성
extension ModifyRecordVC {
    private func configureShadows(_ views: UIView...) {
        views.forEach { $0.configureShadow() }
    }
    
    private func configureScrollView() {
        self.graphsScrollView.delegate = self
    }
    
    private func configurePage() {
        var page = UserDefaultsManager.get(forKey: .lastDailyGraphForm) as? Int ?? 0
        page = page < 2 ? page : 0
        self.graphsScrollView.configureScrollHorizontalPage(frame: self.graphsScrollView.frame, to: page)
    }
    
    private func configureTaskInteractionViews() {
        self.superContentView.addSubview(self.taskInteractionFrameView)
        self.taskInteractionFrameView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.taskInteractionFrameView.widthAnchor.constraint(equalToConstant: 365),
            self.taskInteractionFrameView.centerXAnchor.constraint(equalTo: self.superContentView.centerXAnchor),
            self.taskInteractionFrameView.topAnchor.constraint(equalTo: self.graphsScrollView.bottomAnchor, constant: 16),
            self.taskInteractionFrameView.bottomAnchor.constraint(equalTo: self.superContentView.bottomAnchor, constant: -16)
        ])
        // MARK: 기기별 height 값 적용 (Max 인 경우와 아닌 경우)
        let taskInteractionFrameViewHeight: CGFloat = self.view.frame.height >= 926 ? 321 : 277
        self.taskInteractionFrameViewHeight = self.taskInteractionFrameView.heightAnchor.constraint(equalToConstant: taskInteractionFrameViewHeight)
        self.taskInteractionFrameViewHeight?.isActive = true
        // scrollView.contentView.height 값 수정
        self.superContentViewHeight.constant = (365 + 16 + taskInteractionFrameViewHeight + 16)
        
        self.taskInteractionFrameView.addSubview(self.taskInteratcionViewPlaceholder)
        self.taskInteratcionViewPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.taskInteratcionViewPlaceholder.centerXAnchor.constraint(equalTo: self.taskInteractionFrameView.centerXAnchor),
            self.taskInteratcionViewPlaceholder.centerYAnchor.constraint(equalTo: self.taskInteractionFrameView.centerYAnchor)
        ])
        
        self.taskInteractionFrameView.addSubview(self.taskModifyInteractionView)
        self.taskModifyInteractionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.taskModifyInteractionView.centerXAnchor.constraint(equalTo: self.taskInteractionFrameView.centerXAnchor),
            self.taskModifyInteractionView.topAnchor.constraint(equalTo: self.taskInteractionFrameView.topAnchor),
            self.taskModifyInteractionView.bottomAnchor.constraint(equalTo: self.taskInteractionFrameView.bottomAnchor)
        ])
        
        self.taskInteractionFrameView.addSubview(self.taskCreateInteractionView)
        self.taskCreateInteractionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.taskCreateInteractionView.centerXAnchor.constraint(equalTo: self.taskInteractionFrameView.centerXAnchor),
            self.taskCreateInteractionView.topAnchor.constraint(equalTo: self.taskInteractionFrameView.topAnchor),
            self.taskCreateInteractionView.bottomAnchor.constraint(equalTo: self.taskInteractionFrameView.bottomAnchor)
        ])
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
    
    private func configureCollectionViewDelegate() {
        self.standardDailyGraphView.configureDelegate(self)
        self.timeTableDailyGraphView.configureDelegate(self)
        self.tasksProgressDailyGraphView.configureDelegate(self)
    }
    
    private func configureTableViewDelegate() {
        self.taskModifyInteractionView.configureDelegate(self)
        self.taskCreateInteractionView.configureDelegate(self)
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

// MARK: 바인딩
extension ModifyRecordVC {
    private func bindAll() {
        self.bindDaily()
        self.bindTasks()
        self.bindMode()
        self.bindIsModified()
        self.bindSelectedTask()
        self.bindSelectedTaskHistorys()
        self.bindAlert()
    }
    
    private func bindDaily() {
        self.viewModel?.$currentDaily
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] daily in
                self?.updateGraphsFromDaily()
            })
            .store(in: &self.cancellables)
    }
    
    private func bindTasks() {
        self.viewModel?.$tasks
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.updateGraphsFromTasks()
                self?.updateInteractionViews()
            })
            .store(in: &self.cancellables)
    }
    
    private func bindMode() {
        self.viewModel?.$modifyMode
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { [weak self] mode in
                guard let self = self else { return }
                
                self.standardDailyGraphView.reload()
                self.timeTableDailyGraphView.reload()
                
                switch mode {
                case .existingTask:
                    self.changeInteractionView(to: self.taskModifyInteractionView)
                    self.standardDailyGraphView.removeCollectionViewHighlight()
                    self.timeTableDailyGraphView.removeCollectionViewHighlight()
                case .newTask:
                    self.changeInteractionView(to: self.taskCreateInteractionView)
                    self.standardDailyGraphView.removeCollectionViewHighlight()
                    self.timeTableDailyGraphView.removeCollectionViewHighlight()
                case .none:
                    self.changeInteractionView(to: self.taskInteratcionViewPlaceholder)
                    self.standardDailyGraphView.highlightCollectionView()
                    self.timeTableDailyGraphView.highlightCollectionView()
                }
            })
            .store(in: &self.cancellables)
    }
    
    private func bindIsModified() {
        self.viewModel?.$isModified
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { isModified in
                // 변경 사항이 있는 경우에만 SAVE 버튼 enable
                self.navigationItem.rightBarButtonItem?.isEnabled = isModified
            })
            .store(in: &self.cancellables)
    }
    
    private func bindSelectedTask() {
        self.viewModel?.$selectedTask
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] selectedTask in
                self?.updateInteractionViews()
                self?.updateADDButtonState()
            })
            .store(in: &self.cancellables)
    }
    
    private func bindSelectedTaskHistorys() {
        self.viewModel?.$selectedTaskHistorys
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] selectedTaskHistorys in
                self?.updateInteractionViews()
                self?.updateADDButtonState()
            })
            .store(in: &self.cancellables)
    }
    
    private func bindAlert() {
        self.viewModel?.$alert
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] alert in
                guard let alert = alert else { return }
                switch alert {
                case .pastRecord:
                    self?.showAlertWithOK(title: Localized.string(.EditDaily_Popup_UnableEditTitle), text: Localized.string(.EditDaily_Popup_UndableEditDesc))
                }
            })
            .store(in: &self.cancellables)
    }
}

// MARK: 뷰 업데이트
extension ModifyRecordVC {
    private func updateGraphsFromDaily() {
        let daily = self.viewModel?.currentDaily
        self.standardDailyGraphView.updateFromDaily(daily)
        self.timeTableDailyGraphView.updateFromDaily(daily)
        self.timelineDailyGraphView.updateFromDaily(daily)
        self.tasksProgressDailyGraphView.updateFromDaily(daily)
    }
    
    private func updateGraphsFromTasks() {
        guard let isReverseColor = self.viewModel?.isReverseColor else { return }
        
        let tasks = self.viewModel?.tasks ?? []
        self.standardDailyGraphView.reload()
        self.standardDailyGraphView.layoutIfNeeded()
        self.standardDailyGraphView.progressView.updateProgress(tasks: tasks, width: .small, isReversColor: isReverseColor)
        
        self.timeTableDailyGraphView.reload()
        self.timeTableDailyGraphView.layoutIfNeeded()
        self.timeTableDailyGraphView.progressView.updateProgress(tasks: tasks, width: .small, isReversColor: isReverseColor)
        
        self.tasksProgressDailyGraphView.reload()
        self.tasksProgressDailyGraphView.layoutIfNeeded()
        self.tasksProgressDailyGraphView.progressView.updateProgress(tasks: tasks, width: .medium, isReversColor: isReverseColor)
    }
    
    private func updateInteractionViews() {
        guard let viewModel = self.viewModel else { return }
        let colorIndex = viewModel.selectedColorIndex
        let historys = viewModel.selectedTaskHistorys
        let mode = viewModel.modifyMode
        
        switch mode {
        case .existingTask:
            guard let task = viewModel.selectedTask else { return }
            let isDeleteAnimation = viewModel.isDeleteAnimation
            self.viewModel?.isDeleteAnimation = false
            self.taskModifyInteractionView.update(colorIndex: colorIndex, task: task, historys: historys)
            self.taskModifyInteractionView.reload(withDelay: isDeleteAnimation)
        case .newTask:
            let task = viewModel.selectedTask ?? Localized.string(.EditDaily_Text_InfoEnterTaskName)
            self.taskCreateInteractionView.update(colorIndex: colorIndex, task: task, historys: historys)
            self.taskCreateInteractionView.reload()
        case .none:
            return
        }
    }
}

// MARK: 인터렉션 뷰
extension ModifyRecordVC {
    private func changeInteractionView(to targetView: UIView) {
        self.taskInteractionFrameView.subviews.forEach { view in
            UIView.animate(withDuration: 0.2, animations: {
                view.alpha = view == targetView ? 1 : 0
            })
        }
    }
}

// MARK: Alert
extension ModifyRecordVC {
    /// 과목명을 편집할 수 있는 Alert 생성
    private func showEditTaskNameAlert(title: String? = nil, handler: ((String) -> Void)? = nil) {
        guard let editTaskNameVC = storyboard?.instantiateViewController(withIdentifier: PopupEditTaskNameVC.identifier) as? PopupEditTaskNameVC else { return }
        
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: Localized.string(.Common_Text_Cencel), style: .default)
        let ok = UIAlertAction(title: Localized.string(.Common_Text_Done), style: .destructive) { [weak editTaskNameVC] _ in
            let text = editTaskNameVC?.textField.text ?? ""
            handler?(text)
        }
        
        editTaskNameVC.configure(title: title,
                                 taskName: self.viewModel?.selectedTask,
                                 handler: { [weak editTaskNameVC, weak ok, weak self] (text) in
            guard let text = text,
                  let isValidTaskName = self?.viewModel?.validateNewTaskName(text) else { return }
        
            if isValidTaskName {
                editTaskNameVC?.showNormalMessage()
                ok?.isEnabled = true
            } else {
                editTaskNameVC?.showErrorMessage()
                ok?.isEnabled = false
            }
        })
        
        alert.setValue(editTaskNameVC, forKey: "contentViewController")
        alert.addAction(cancel)
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
    
    /// TaskHistory를 편집할 수 있는 Alert 생성
    private func showEditHistoryAlert(with history: TaskHistory, isNewHistory: Bool, handler: ((TaskHistory) -> Void)? = nil) {
        guard let editHistoryViewController = storyboard?.instantiateViewController(withIdentifier: PopupEditHistoryVC.identifier) as? PopupEditHistoryVC,
              let colorIndex = self.viewModel?.selectedColorIndex else { return }
        
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: Localized.string(.Common_Text_Cencel), style: .default)
        let ok = UIAlertAction(title: Localized.string(.Common_Text_Done), style: .destructive) { _ in
            handler?(editHistoryViewController.history)
        }
        
        editHistoryViewController.configure(delegate: self,
                                            history: history,
                                            isNewHistory: isNewHistory,
                                            colorIndex: colorIndex)
        
        alert.setValue(editHistoryViewController, forKey: "contentViewController")
        alert.addAction(cancel)
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
    
    /// OK 버튼만 있는 Alert 생성
    private func showOKAlert(title: String?, message: String?, handler: (()->Void)?) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: Localized.string(.Common_Text_OK), style: .default) { _ in
            handler?()
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    /// Ok와 Cancel 버튼이 있는 Alert 생성
    private func showOKCancelAlert(title: String?, message: String?, handler: (()->Void)?) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: Localized.string(.Common_Text_Cencel), style: .default)
        let ok = UIAlertAction(title: Localized.string(.Common_Text_OK), style: .default) { _ in
            handler?()
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
}

// MARK: UIScrollViewDelegate
extension ModifyRecordVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.graphsScrollView else { return }
        let value = scrollView.contentOffset.x/scrollView.frame.size.width
        self.graphsPageControl.currentPage = Int(round(value))
    }
}

// MARK: UICollectionViewDataSource
extension ModifyRecordVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let graph = GraphCollectionView(rawValue: collectionView.tag),
           let viewModel = self.viewModel {
            switch graph {
            case .standardDailyGraphView, .timeTableDailyGraphView:
                // 아무 과목도 선택하지 않은 경우 마지막에 기록 추가 셀 보여주기
                if viewModel.modifyMode == .none {
                    return viewModel.tasks.count + 1
                } else {
                    return viewModel.tasks.count
                }
            case .tasksProgressDailyGraphView:
                return min(8, viewModel.tasks.count)
            }
        } else { return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let graph = GraphCollectionView(rawValue: collectionView.tag) {
            switch graph {
            case .standardDailyGraphView, .timeTableDailyGraphView:
                let isNoneMode = self.viewModel?.modifyMode == ModifyRecordVM.ModifyMode.none
                let isLastCell = indexPath.row == (self.viewModel?.tasks.count ?? 0)
                
                // 편집 중이 아닌 경우 마지막 셀은 +기록추가 셀
                if isNoneMode && isLastCell {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddNewTaskHistoryCell.identifier, for: indexPath) as? AddNewTaskHistoryCell else { return UICollectionViewCell() }
                    cell.configureDelegate(self)
                    return cell
                } else {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StandardDailyTaskCell.identifier, for: indexPath) as? StandardDailyTaskCell else { return .init() }
                    guard let taskInfo = self.viewModel?.tasks[safe: indexPath.item],
                          let isReverseColor = self.viewModel?.isReverseColor else { return cell }
                    
                    cell.configure(index: indexPath.item, taskInfo: taskInfo, isReversColor: isReverseColor)
                    // 편집중인 Task는 빨간색 테두리 처리
                    if self.viewModel?.modifyMode == .existingTask,
                       taskInfo.taskName == self.viewModel?.selectedTask {
                        cell.highlightBorder()
                    } else {
                        cell.removeHighlight()
                    }
                    
                    return cell
                }
            case .tasksProgressDailyGraphView:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressDailyTaskCell.identifier, for: indexPath) as? ProgressDailyTaskCell else { return .init() }
                guard let taskInfo = self.viewModel?.tasks[safe: indexPath.item],
                      let isReverseColor = self.viewModel?.isReverseColor else { return cell }
                cell.configure(index: indexPath.item, taskInfo: taskInfo, isReversColor: isReverseColor)
                return cell
            }
        } else { return .init() }
    }
}

// MARK: UICollectionViewDelegate
extension ModifyRecordVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let graph = GraphCollectionView(rawValue: collectionView.tag),
              graph == .standardDailyGraphView || graph == .timeTableDailyGraphView,
              let taskName = self.viewModel?.tasks[safe: indexPath.row]?.taskName else { return }
        // 그래프에서 Task 선택 -> 기존 Task 편집 모드로 전환
        self.viewModel?.changeToExistingTaskMode(task: taskName)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ModifyRecordVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let graph = GraphCollectionView(rawValue: collectionView.tag) {
            switch graph {
            case .standardDailyGraphView, .timeTableDailyGraphView:
                return CGSize(width: collectionView.bounds.width-4, height: StandardDailyTaskCell.height)
            case .tasksProgressDailyGraphView:
                return CGSize(width: collectionView.bounds.width, height: ProgressDailyTaskCell.height)
            }
        } else { return .zero }
    }
}

// MARK: UITableViewDelegate
extension ModifyRecordVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let lastCellIndex = self.viewModel?.selectedTaskHistorys.count ?? 0
        let isLastCell = (indexPath.row == lastCellIndex)
        
        // 마지막 셀은 기록추가 셀
        return isLastCell ? AddHistoryCell.height : HistoryCell.height
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let lastCellIndex = self.viewModel?.selectedTaskHistorys.count ?? 0
        guard indexPath.row != lastCellIndex, self.viewModel?.modifyMode == .existingTask else { return nil }
        let deleteAction = UIContextualAction(style: .normal, title: Localized.string(.Common_Text_Delete)) { [weak self] action, view, completionHandler in
            print("DELETE \(indexPath.row)")
            self?.viewModel?.deleteHistory(at: indexPath.row)
            self?.taskModifyInteractionView.deleteRows(at: indexPath)
        }
        deleteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: UITableViewDataSource
extension ModifyRecordVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfHistorys = self.viewModel?.selectedTaskHistorys.count ?? 0
        return numberOfHistorys + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lastCellIndex = self.viewModel?.selectedTaskHistorys.count ?? 0
        let isLastCell = (indexPath.row == lastCellIndex)
        
        if isLastCell {     // 마지막 셀은 기록추가 셀
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddHistoryCell.identifier, for: indexPath) as? AddHistoryCell else { return UITableViewCell() }
            cell.configureDelegate(self)
            return cell
        } else {            // 나머지는 일반 히스토리 셀
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.identifier, for: indexPath) as? HistoryCell else { return UITableViewCell() }
            guard let history = self.viewModel?.selectedTaskHistorys[safe: indexPath.row],
                  let colorIndex = self.viewModel?.selectedColorIndex else { return cell }
            cell.configureDelegate(self)
            cell.configure(with: history, colorIndex: colorIndex)
            return cell
        }
    }
}

// MARK: Task 편집 버튼 (연필 모양)
extension ModifyRecordVC: EditTaskButtonDelegate {
    func editTaskButtonTapped() {
        guard let mode = self.viewModel?.modifyMode else { return }
        
        switch mode {
        case .existingTask:
            FirebaseEvent.shared.postEvent(.editTaskName)
            self.showEditTaskNameAlert(title: Localized.string(.EditDaily_Popup_EditTaskName)) { [weak self] text in
                self?.viewModel?.changeTaskName(to: text)
            }
        case .newTask:
            FirebaseEvent.shared.postEvent(.createTaskName)
            self.showEditTaskNameAlert(title: Localized.string(.EditDaily_Popup_EnterTaskName)) { [weak self] text in
                self?.viewModel?.setNewTaskName(text)
            }
        default:
            return
        }
    }
}

// MARK: 히스토리 편집 버튼 (연필 모양)
extension ModifyRecordVC: EditHistoryButtonDelegate {
    func editHistoryButtonTapped(at indexPath: IndexPath?) {
        FirebaseEvent.shared.postEvent(.editRecordHistory)
        guard let index = indexPath?.row,
              let history = self.viewModel?.selectedTaskHistorys[safe: index] else { return }
        
        self.showEditHistoryAlert(with: history, isNewHistory: false) { [weak self] newHistory in
            self?.viewModel?.modifyHistory(at: index, to: newHistory)
        }
    }
}

// MARK: 기존 Task에 기록 추가 버튼
extension ModifyRecordVC: AddHistoryButtonDelegate {
    func addHistoryButtonTapped() {
        FirebaseEvent.shared.postEvent(.createRecordInRecord)
        guard let day = self.viewModel?.currentDaily.day else { return }
        
        // 초기 placeholder는 00:00:00
        let defaultHistory = TaskHistory(startDate: day.zeroDate, endDate: day.zeroDate)
        self.showEditHistoryAlert(with: defaultHistory, isNewHistory: true) { [weak self] newHistory in
            self?.viewModel?.addHistory(newHistory)
        }
    }
}

// MARK: 새로운 Task 기록 추가 버튼
extension ModifyRecordVC: AddNewTaskHistoryButtonDelegate {
    func addNewTaskHistoryButtonTapped() {
        FirebaseEvent.shared.postEvent(.createRecordInRecord)
        self.viewModel?.changeToNewTaskMode()
    }
}

// MARK: OK & ADD 버튼
extension ModifyRecordVC: FinishButtonDelegate {
    func finishButtonTapped() {
        guard let mode = self.viewModel?.modifyMode else { return }
        
        switch mode {
        case .existingTask:
            self.viewModel?.changeToNoneMode()
        case .newTask:
            // 그래프에도 반영하기 위해 Daily 업데이트
            self.viewModel?.updateDailysTaskHistory()
            self.viewModel?.changeToNoneMode()
        default:
            return
        }
    }
    
    func updateADDButtonState() {
        // 과목명이 존재하고, 기록이 1개 이상인 경우에만 ADD 버튼 활성화
        if self.viewModel?.selectedTask != nil,
           self.viewModel?.selectedTaskHistorys.count ?? 0 > 0 {
            self.taskCreateInteractionView.updateFinishButtonEnable(to: true)
        } else {
            self.taskCreateInteractionView.updateFinishButtonEnable(to: false)
        }
    }
}

// MARK: Date 선택시 겹치는 시각 확인
extension ModifyRecordVC: DateValidator {
    func isValidDate(selected date: Date, currentHistory: TaskHistory) -> Bool {
        return self.viewModel?.validateDate(selected: date, currentHistory: currentHistory) ?? false
    }
}

// MARK: 네비게이션 바 아이템 버튼
extension ModifyRecordVC {
    @objc func saveButtonTapped() {
        #if targetEnvironment(macCatalyst)
        self.viewModel?.save()
        self.showOKAlert(title: "Save Completed".localized(), message: "Your changes have been saved.".localized()) { [weak self] in
            self?.viewModel?.reset()
        }
        #else
        FirebaseEvent.shared.postEvent(.saveRecord)
        if self.viewModel?.isRemoveAd == true {
            self.viewModel?.save()
            self.showOKAlert(title: Localized.string(.Common_Popup_SaveCompleted), message: Localized.string(.EditDaily_Popup_EditTaskSaved)) { [weak self] in
                self?.viewModel?.reset()
            }
        } else {
            self.showOKCancelAlert(title: Localized.string(.Common_Popup_Inform),
                                   message: Localized.string(.EditDaily_Popup_WatchADRequired)) { [weak self] in
                self?.showRewardedAd()
            }
        }
        #endif
    }
    
    @objc private func backButtonTapped() {
        guard let isModified = self.viewModel?.isModified else { return }
        
        // 변경 사항이 있는 경우 얼럿 제공
        if isModified {
            self.confirmCancel()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func confirmCancel() {
        self.showOKCancelAlert(title: Localized.string(.Common_Popup_Warning),
                               message: Localized.string(.EditDaily_Popup_EditChangeCanceled)) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

#if targetEnvironment(macCatalyst)
#else
// MARK: 애드몹
extension ModifyRecordVC: GADFullScreenContentDelegate {
    /// 광고 로드
    private func loadRewardedAd() {
        guard let adID = Bundle.main.object(forInfoDictionaryKey: "ADMOB_AD_ID") as? String else { return }
        
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: adID,
                           request: request) { [weak self] ad, error in
            if let error = error {
                print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                return
            }
            
            self?.rewardedAd = ad
            self?.rewardedAd?.fullScreenContentDelegate = self
            print("Rewarded ad loaded.")
            self?.viewModel?.isRemoveAd = true
        }
    }
    
    private func showRewardedAd() {
        if let ad = rewardedAd {
            ad.present(fromRootViewController: self) {
                let reward = ad.adReward
                print("Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
                self.viewModel?.save()
            }
        } else {
            print("Ad wasn't ready")
        }
    }
    
    /// 델리게이트에게 전면 광고 표시 실패를 알림
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }
    
    /// 델리게이트에게 전면 광고 표시 성공을 알림
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }
    
    /// 델리게이트에게 전면 광고가 dismiss 되었음을 알림
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        
        self.showOKAlert(title: Localized.string(.Common_Popup_SaveCompleted), message: Localized.string(.EditDaily_Popup_EditTaskSaved)) { [weak self] in
            self?.viewModel?.reset()
        }
        // 다음 광고 미리 로드
        self.loadRewardedAd()
    }
}
#endif
