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

final class ModifyRecordVC: UIViewController {
    static let identifier = "ModifyRecordVC"
    
    @IBOutlet weak var graphsScrollView: UIScrollView!
    @IBOutlet weak var graphsContentView: UIView!
    @IBOutlet weak var graphsPageControl: UIPageControl!
    private var standardDailyGraphView = StandardDailyGraphView()
    private var timelineDailyGraphView = TimelineDailyGraphView()
    private var tasksProgressDailyGraphView = TasksProgressDailyGraphView()
    private var taskInteractionFrameView = UIView()                         // 인터렉션 뷰의 프레임 뷰
    private var taskModifyInteractionView = TaskModifyInteractionView()     // 기존 Task의 기록 편집 뷰
    private var taskCreateInteractionView = TaskCreateInteractionView()     // 새로운 Task의 기록 편집 뷰
    private var taskInteratcionViewPlaceholder = TaskInteractionViewPlaceholder()   // 인터렉션뷰 placeholder
    private var isReverseColor: Bool = false    // TODO: 받아와야서 반영해야 함
    private var viewModel: ModifyRecordVM?
    private var cancellables: Set<AnyCancellable> = []
    enum GraphCollectionView: Int {
        case standardDailyGraphView = 0
        case tasksProgressDailyGraphView = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationBar()
        self.configureScrollView()
        self.configureTaskInteractionViews()
        self.configureGraphs()
        self.configureCollectionViewDelegate()
        self.configureTableViewDelegate()
        self.configureHostingVC()
        self.bindAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.standardDailyGraphView.updateDarkLightMode()
        self.timelineDailyGraphView.updateDarkLightMode()
        self.tasksProgressDailyGraphView.updateDarkLightMode()
        self.updateGraphsFromDaily()
        self.updateGraphsFromTasks()
        self.configureShadows(self.taskModifyInteractionView, self.taskCreateInteractionView)
    }
}

// MARK: public configure
extension ModifyRecordVC {
    func configureViewModel(with daily: Daily) {
        self.viewModel = ModifyRecordVM(daily: daily)
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd"
        self.title = dateFormatter.string(from: day)
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
        let backButton = UIBarButtonItem(title: "Back",
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
    
    private func configureTaskInteractionViews() {
        self.view.addSubview(self.taskInteractionFrameView)
        self.taskInteractionFrameView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // 가로 365로 고정
            self.taskInteractionFrameView.widthAnchor.constraint(equalToConstant: 365),
            self.taskInteractionFrameView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.taskInteractionFrameView.topAnchor.constraint(equalTo: self.graphsScrollView.bottomAnchor, constant: 16),
            // 세로는 가변 길이, 단 탭바로부터 16만큼 띄우기
            self.taskInteractionFrameView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16 - (self.tabBarController?.tabBar.frame.height ?? 0))
        ])
        
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
    
    private func configureCollectionViewDelegate() {
        self.standardDailyGraphView.configureDelegate(self)
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
            })
            .store(in: &self.cancellables)
    }
    
    private func bindMode() {
        self.viewModel?.$mode
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] mode in
                self?.standardDailyGraphView.reload()
                
                switch mode {
                case .existingTask:
                    self?.showTaskModifyInteractionView()
                    self?.standardDailyGraphView.removeCollectionViewHighlight()
                case .newTask:
                    self?.showTaskCreateInteractionView()
                    self?.standardDailyGraphView.removeCollectionViewHighlight()
                case .none:
                    self?.showTaskInteractionViewPlaceholder()
                    self?.standardDailyGraphView.highlightCollectionView()
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
}

// MARK: 뷰 업데이트
extension ModifyRecordVC {
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
        self.standardDailyGraphView.progressView.updateProgress(tasks: tasks, width: .small, isReversColor: self.isReverseColor)
        self.tasksProgressDailyGraphView.reload()
        self.tasksProgressDailyGraphView.layoutIfNeeded()
        self.tasksProgressDailyGraphView.progressView.updateProgress(tasks: tasks, width: .medium, isReversColor: self.isReverseColor)
    }
    
    private func updateInteractionViews() {
        self.taskModifyInteractionView.update(task: self.viewModel?.selectedTask,
                                                 historys: self.viewModel?.selectedTaskHistorys)
        self.taskCreateInteractionView.update(task: self.viewModel?.selectedTask,
                                                 historys: self.viewModel?.selectedTaskHistorys)
    }
}

// MARK: 인터렉션 뷰
extension ModifyRecordVC {
    /// 모든 인터렉션 뷰 제거
    private func emptyInteractionFrameView() {
        self.taskInteractionFrameView.subviews.forEach { $0.isHidden = true }
    }
    
    private func showTaskInteractionViewPlaceholder() {
        self.emptyInteractionFrameView()
        self.taskInteratcionViewPlaceholder.isHidden = false
    }
    
    private func showTaskModifyInteractionView() {
        self.emptyInteractionFrameView()
        self.taskModifyInteractionView.isHidden = false
    }
    
    private func showTaskCreateInteractionView() {
        self.emptyInteractionFrameView()
        self.taskCreateInteractionView.isHidden = false
    }
}

// MARK: Alert
extension ModifyRecordVC {
    /// 텍스트필드가 포함된 Alert 생성
    private func showTextFieldAlert(title: String? = nil, message: String? = nil, placeholder: String? = nil, handler: ((String)->Void)? = nil) {
        // TODO: localize
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
            let text = alert.textFields?[0].text ?? ""
            handler?(text)
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = placeholder
            textField.textAlignment = .center
            textField.font = TiTiFont.HGGGothicssiP60g(size: 17)
            textField.text = self.viewModel?.selectedTask
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
    
    /// TaskHistory를 편집할 수 있는 Alert 생성
    private func showEditHistoryAlert(with history: TaskHistory, handler: ((TaskHistory)->Void)? = nil) {
        guard let editHistoryViewController = storyboard?.instantiateViewController(withIdentifier: "EditHistoryVC") as? EditHistoryVC else { return }
        
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .alert)
        
        editHistoryViewController.history = history
        alert.setValue(editHistoryViewController, forKey: "contentViewController")
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
            handler?(editHistoryViewController.history)
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
    
    /// OK 버튼만 있는 Alert 생성
    private func showOKAlert(title: String?, message: String?, handler: (()->Void)?) {
        // TODO: localize
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            handler?()
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    /// Ok와 Cancel 버튼이 있는 Alert 생성
    private func showOKCancelAlert(title: String?, message: String?, handler: (()->Void)?) {
        // TODO: localize
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
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
            case .standardDailyGraphView:
                // 아무 과목도 선택하지 않은 경우 마지막에 기록 추가 셀 보여주기
                if viewModel.mode == .none {
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
            case .standardDailyGraphView:
                let isNoneMode = self.viewModel?.mode == ModifyRecordVM.ModifyMode.none
                let isLastCell = indexPath.row == (self.viewModel?.tasks.count ?? 0)
                
                // 편집 중이 아닌 경우 마지막 셀은 +기록추가 셀
                if isNoneMode && isLastCell {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddNewTaskHistoryCell.identifier, for: indexPath) as? AddNewTaskHistoryCell else { return UICollectionViewCell() }
                    cell.configureDelegate(self)
                    return cell
                } else {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StandardDailyTaskCell.identifier, for: indexPath) as? StandardDailyTaskCell else { return .init() }
                    guard let taskInfo = self.viewModel?.tasks[safe: indexPath.item] else { return cell }
                    
                    cell.configure(index: indexPath.item, taskInfo: taskInfo, isReversColor: self.isReverseColor)
                    // 편집중인 Task는 빨간색 테두리 처리
                    if taskInfo.taskName == self.viewModel?.selectedTask {
                        cell.layer.borderWidth = 2
                        cell.layer.borderColor = UIColor.red.cgColor
                    } else {
                        cell.layer.borderWidth = 0
                    }
                    
                    return cell
                }
            case .tasksProgressDailyGraphView:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressDailyTaskCell.identifier, for: indexPath) as? ProgressDailyTaskCell else { return .init() }
                guard let taskInfo = self.viewModel?.tasks[safe: indexPath.item] else { return cell }
                cell.configure(index: indexPath.item, taskInfo: taskInfo, isReversColor: self.isReverseColor)
                return cell
            }
        } else { return .init() }
    }
}

// MARK: UICollectionViewDelegate
extension ModifyRecordVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let graph = GraphCollectionView(rawValue: collectionView.tag),
              graph == .standardDailyGraphView,
              let taskName = self.viewModel?.tasks[indexPath.row].taskName else { return }
        // 그래프에서 Task 선택 -> 기존 Task 편집 모드로 전환
        self.viewModel?.changeToExistingTaskMode(task: taskName)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ModifyRecordVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let graph = GraphCollectionView(rawValue: collectionView.tag) {
            switch graph {
            case .standardDailyGraphView:
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
        let lastCellIndex = self.viewModel?.selectedTaskHistorys?.count ?? 0
        let isLastCell = (indexPath.row == lastCellIndex)
        
        // 마지막 셀은 기록추가 셀
        return isLastCell ? AddHistoryCell.height : HistoryCell.height
    }
}

// MARK: UITableViewDataSource
extension ModifyRecordVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfHistorys = self.viewModel?.selectedTaskHistorys?.count ?? 0
        return numberOfHistorys + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lastCellIndex = self.viewModel?.selectedTaskHistorys?.count ?? 0
        let isLastCell = (indexPath.row == lastCellIndex)
        
        if isLastCell {     // 마지막 셀은 기록추가 셀
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddHistoryCell.identifier, for: indexPath) as? AddHistoryCell else { return UITableViewCell() }
            cell.configureDelegate(self)
            return cell
        } else {            // 나머지는 일반 히스토리 셀
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.identifier, for: indexPath) as? HistoryCell else { return UITableViewCell() }
            guard let history = self.viewModel?.selectedTaskHistorys?[indexPath.row] else { return cell }
            cell.configureDelegate(self)
            cell.configure(with: history)
            return cell
        }
    }
}

// MARK: Task 편집 버튼 (연필 모양)
extension ModifyRecordVC: EditTaskButtonDelegate {
    func editTaskButtonTapped() {
        guard let mode = self.viewModel?.mode else { return }
        
        switch mode {
        case .existingTask:
            self.showTextFieldAlert(title: "과목명 수정",
                                    message: "새로운 과목을 입력해주세요",
                                    placeholder: "새로운 과목") { [weak self] text in
                self?.viewModel?.changeTaskName(to: text)
            }
        case .newTask:
            self.showTextFieldAlert(title: "과목명 입력",
                                    message: "새로운 과목을 입력해주세요",
                                    placeholder: "새로운 과목") { [weak self] text in
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
        guard let index = indexPath?.row,
              let history = self.viewModel?.selectedTaskHistorys?[index] else { return }
        
        self.showEditHistoryAlert(with: history) { [weak self] newHistory in
            self?.viewModel?.modifyHistory(at: index, to: newHistory)
        }
    }
}

// MARK: 기존 Task에 기록 추가 버튼
extension ModifyRecordVC: AddHistoryButtonDelegate {
    func addHistoryButtonTapped() {
        guard let day = self.viewModel?.currentDaily.day else { return }
        
        // 초기 placeholder는 00:00:00
        let defaultHistory = TaskHistory(startDate: day.zeroDate, endDate: day.zeroDate)
        self.showEditHistoryAlert(with: defaultHistory) { [weak self] newHistory in
            self?.viewModel?.addHistory(newHistory)
        }
    }
}

// MARK: 새로운 Task 기록 추가 버튼
extension ModifyRecordVC: AddNewTaskHistoryButtonDelegate {
    func addNewTaskHistoryButtonTapped() {
        self.viewModel?.changeToNewTaskMode()
    }
}

// MARK: OK & ADD 버튼
extension ModifyRecordVC: FinishButtonDelegate {
    func finishButtonTapped() {
        guard let mode = self.viewModel?.mode else { return }
        
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
           let numberOfHistorys = self.viewModel?.selectedTaskHistorys?.count,
           numberOfHistorys > 0 {
            self.taskCreateInteractionView.enableFinishButton()
        } else {
            self.taskCreateInteractionView.disableFinishButton()
        }
    }
}

// MARK: 네비게이션 바 아이템 버튼
extension ModifyRecordVC {
    @objc func saveButtonTapped() {
        self.viewModel?.save()
        self.showOKAlert(title: "저장 완료", message: "변경 사항이 저장되었습니다") { [weak self] in
            self?.viewModel?.reset()
        }
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
        self.showOKCancelAlert(title: "경고", message: "변경 사항이 제거됩니다.") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
