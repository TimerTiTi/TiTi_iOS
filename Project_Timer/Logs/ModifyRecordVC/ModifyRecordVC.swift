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
    private var taskInteractionFrameView = UIView()
    private var taskModifyInteractionView = TaskInteractionView()
    private var taskEmptyInteractionView: UILabel = {
        let label = UILabel()
        label.text = "과목을 선택하여 기록수정 후\nSAVE를 눌러주세요"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = TiTiFont.HGGGothicssiP60g(size: 17)
        label.textColor = UIColor.label
        return label
    }()
    private var isReverseColor: Bool = false    // Daily로부터 받아와야 함
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
        self.configureTaskInteractionFrameView()
        self.configureGraphs()
        self.configureCollectionViewDelegate()
        self.configureTableViewDelegate()
        self.configureHostingVC()
        self.bindAll()
        
        self.showTaskModifyInteractionView()
//        self.showTaskEmptyInteractionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.configureShadows(self.taskModifyInteractionView)
    }
}

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
        let backButton = UIBarButtonItem(title: "Back",
                                         style: .done,
                                         target: self,
                                         action: #selector(backButtonTapped))
        backButton.image = UIImage(systemName: "chevron.backward")
        self.navigationItem.setLeftBarButton(backButton, animated: false)
    }
}

extension ModifyRecordVC {
    private func configureShadows(_ views: UIView...) {
        views.forEach { $0.configureShadow() }
    }
    
    private func configureScrollView() {
        self.graphsScrollView.delegate = self
    }
    
    private func configureTaskInteractionFrameView() {
        self.view.addSubview(self.taskInteractionFrameView)
        self.taskInteractionFrameView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.taskInteractionFrameView.widthAnchor.constraint(equalToConstant: 365),
            self.taskInteractionFrameView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.taskInteractionFrameView.topAnchor.constraint(equalTo: self.graphsScrollView.bottomAnchor, constant: 16),
            self.taskInteractionFrameView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16 - (self.tabBarController?.tabBar.frame.height ?? 0))
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
    }
    
    func configureViewModel(with daily: Daily) {
        self.viewModel = ModifyRecordVM(daily: daily)
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

extension ModifyRecordVC {
    private func bindAll() {
        self.bindDaily()
        self.bindTasks()
        self.bindSelectedTask()
        self.bindIsModified()
    }
    
    private func bindDaily() {
        self.viewModel?.$currentDaily
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.updateGraphsFromDaily()
                self?.updateInteractionViews()
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
    
    private func bindSelectedTask() {
        self.viewModel?.$selectedTask
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] selectedTask in
                if selectedTask == nil {
                    self?.showTaskEmptyInteractionView()
                    self?.standardDailyGraphView.highlightCollectionView()
                } else {
                    self?.updateInteractionViews()
                    self?.showTaskModifyInteractionView()
                    self?.standardDailyGraphView.removeCollectionViewHighlight()
                }
                self?.standardDailyGraphView.reload()
            })
            .store(in: &self.cancellables)
    }
    
    private func bindIsModified() {
        self.viewModel?.$isModified
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { isModified in
                self.navigationItem.rightBarButtonItem?.isEnabled = isModified
            })
            .store(in: &self.cancellables)
    }
}

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
        // TODO: self.taskCreateInteractionView.update
    }
}

extension ModifyRecordVC {
    private func emptyInteractionFrameView() {
        self.taskInteractionFrameView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    private func showTaskEmptyInteractionView() {
        self.emptyInteractionFrameView()
        
        self.taskInteractionFrameView.addSubview(self.taskEmptyInteractionView)
        self.taskEmptyInteractionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.taskEmptyInteractionView.centerXAnchor.constraint(equalTo: self.taskInteractionFrameView.centerXAnchor),
            self.taskEmptyInteractionView.centerYAnchor.constraint(equalTo: self.taskInteractionFrameView.centerYAnchor)
        ])
    }
    
    private func showTaskModifyInteractionView() {
        self.emptyInteractionFrameView()
        
        self.taskInteractionFrameView.addSubview(self.taskModifyInteractionView)
        self.taskModifyInteractionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.taskModifyInteractionView.centerXAnchor.constraint(equalTo: self.taskInteractionFrameView.centerXAnchor),
            self.taskModifyInteractionView.topAnchor.constraint(equalTo: self.taskInteractionFrameView.topAnchor),
            self.taskModifyInteractionView.bottomAnchor.constraint(equalTo: self.taskInteractionFrameView.bottomAnchor)
        ])
    }
}

extension ModifyRecordVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.graphsScrollView else { return }
        let value = scrollView.contentOffset.x/scrollView.frame.size.width
        self.graphsPageControl.currentPage = Int(round(value))
    }
}

extension ModifyRecordVC: UICollectionViewDataSource {
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
                cell.configure(index: indexPath.item, taskInfo: taskInfo, isReversColor: self.isReverseColor)
                if taskInfo.taskName == self.viewModel?.selectedTask {
                    cell.layer.borderWidth = 2
                    cell.layer.borderColor = UIColor.red.cgColor
                } else {
                    cell.layer.borderWidth = 0
                }
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

extension ModifyRecordVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let graph = GraphCollectionView(rawValue: collectionView.tag),
              graph == .standardDailyGraphView else { return }
        self.viewModel?.selectTask(at: indexPath.row)
    }
}

extension ModifyRecordVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let graph = GraphCollectionView(rawValue: collectionView.tag) {
            switch graph {
            case .standardDailyGraphView:
                // 컬렉션뷰 테두리가 안쪽으로 생겨서 셀 테두리를 덮는 버그 때문에 width 수정함
                return CGSize(width: collectionView.bounds.width-4, height: StandardDailyTaskCell.height)
            case .tasksProgressDailyGraphView:
                return CGSize(width: collectionView.bounds.width, height: ProgressDailyTaskCell.height)
            }
        } else { return .zero }
    }
}

extension ModifyRecordVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let isLastCell = indexPath.row == (self.viewModel?.selectedTaskHistorys.count ?? 0)
        
        return isLastCell ? AddHistoryCell.height : HistoryCell.height
    }
}

extension ModifyRecordVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.viewModel?.selectedTaskHistorys.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isLastCell = indexPath.row == (self.viewModel?.selectedTaskHistorys.count ?? 0)
        
        if isLastCell {
            guard let cell = self.taskModifyInteractionView.historyTableView.dequeueReusableCell(withIdentifier: AddHistoryCell.identifier, for: indexPath) as? AddHistoryCell else { return UITableViewCell() }
            cell.configureDelegate(self)
            return cell
        } else {
            guard let cell = self.taskModifyInteractionView.historyTableView.dequeueReusableCell(withIdentifier: HistoryCell.identifier, for: indexPath) as? HistoryCell else { return UITableViewCell() }
            cell.configureDelegate(self)
            cell.configure(with: self.viewModel?.selectedTaskHistorys[indexPath.row])
            return cell
        }
    }
}

extension ModifyRecordVC: EditTaskButtonDelegate {
    func editTaskButtonTapped() {
        // TODO: localize
        let alert = UIAlertController(title: "과목명 수정",
                                      message: "새로운 과목을 입력해주세요",
                                      preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let ok = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            let newTaskName = alert.textFields?[0].text ?? ""
            self?.viewModel?.updateSelectedTaskName(to: newTaskName)
        }
        
        alert.addTextField { (inputNewTaskName) in
            inputNewTaskName.placeholder = "새로운 과목"
            inputNewTaskName.textAlignment = .center
            inputNewTaskName.font = TiTiFont.HGGGothicssiP60g(size: 17)
            inputNewTaskName.text = self.viewModel?.selectedTask
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
}

extension ModifyRecordVC: EditHistoryButtonDelegate {
    func editHistoryButtonTapped(at indexPath: IndexPath?) {
        guard let viewModel = self.viewModel,
              let index = indexPath?.row,
              let editHistoryViewController = storyboard?.instantiateViewController(withIdentifier: "EditHistoryVC") as? EditHistoryVC else { return }
        
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .alert)
        
        editHistoryViewController.history = viewModel.selectedTaskHistorys[index]
        alert.setValue(editHistoryViewController, forKey: "contentViewController")
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let ok = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.viewModel?.updateHistory(at: index, to: editHistoryViewController.history)
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
}

extension ModifyRecordVC: AddHistoryButtonDelegate {
    func addHistoryButtonTapped() {
        guard let editHistoryViewController = storyboard?.instantiateViewController(withIdentifier: "EditHistoryVC") as? EditHistoryVC,
              let day = self.viewModel?.currentDaily.day else { return }

        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .alert)
        
        editHistoryViewController.history = TaskHistory(startDate: day.zeroDate, endDate: day.zeroDate)
        alert.setValue(editHistoryViewController, forKey: "contentViewController")
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let ok = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            // TODO: 시작시각 > 종료시각인 경우 에러 처리
            self?.viewModel?.addHistory(editHistoryViewController.history)
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
}

extension ModifyRecordVC: FinishButtonDelegate {
    func finishButtonTapped() {
        self.viewModel?.deselectTask()
    }
}

extension ModifyRecordVC {
    @objc func saveButtonTapped() {
        self.viewModel?.save()
        
        // TODO: localize
        let alert = UIAlertController(title: "저장 완료",
                                      message: "변경 사항이 저장되었습니다.",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.viewModel?.reset()
        }
        alert.addAction(okAction)
        present(alert, animated: true)
        
        // TODO: dailys를 쓰는 다른 화면에게 noti 보내서 화면 갱신 시키기
    }
    
    @objc private func backButtonTapped() {
        guard let isModified = self.viewModel?.isModified else { return }
        
        if isModified {
            self.confirmCancel()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func confirmCancel() {
        // TODO: localize
        let alert = UIAlertController(title: "경고",
                                      message: "변경 사항이 제거됩니다.",
                                      preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let ok = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
}
