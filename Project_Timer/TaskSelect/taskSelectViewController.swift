//
//  taskSelectViewController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/04/05.
//  Copyright © 2021 FDEE. All rights reserved.
//

import UIKit
import Combine

final class taskSelectViewController: UIViewController {
    static let identifier = "taskSelectViewController"
    
    @IBOutlet weak var tasksTableView: UITableView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var newTaskButton: UIButton!
    
    weak var delegate: TaskChangeable?
    private var viewModel: TaskSelectVM?
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureColor()
        self.configureTableView()
        self.configureViewModel()
        self.tasksTableView.reloadData()
        self.bindAll()
    }
    
    @IBAction func newTask(_ sender: Any) {
        self.showAlertNewTask()
    }
    
    @IBAction func edit() {
        self.tasksTableView.setEditing(!self.tasksTableView.isEditing, animated: true)
    }
}

// MARK: Configure
extension taskSelectViewController {
    private func configureColor() {
        
    }
    
    private func configureTableView() {
        self.tasksTableView.dataSource = self
        self.tasksTableView.delegate = self
        self.tasksTableView.separatorInset.left = 0
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        self.tasksTableView.addGestureRecognizer(longPress)
    }
    
    private func configureViewModel() {
        self.viewModel = TaskSelectVM()
    }
}

// MARK: Binding
extension taskSelectViewController {
    private func bindAll() {
        self.bindTasks()
    }
    
    private func bindTasks() {
        self.viewModel?.$tasks
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.reloadAfterAnimation()
            })
            .store(in: &self.cancellables)
    }
    
    private func reloadAfterAnimation() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(400)) { [weak self] in
            self?.tasksTableView.reloadData()
        }
    }
}

// MARK: Popups
extension taskSelectViewController {
    private func showAlertNewTask() {
        let alert = UIAlertController(title: "New task".localized(), message: "Task name's max length is 20".localized(), preferredStyle: .alert)
        let cancle = UIAlertAction(title: "CANCEL", style: .destructive, handler: nil)
        let ok = UIAlertAction(title: "ENTER", style: .default, handler: { [weak self] action in
            guard let newTask: String = alert.textFields?[0].text else { return }
            self?.viewModel?.addNewTask(taskName: newTask)
        })
        
        alert.addTextField { (inputNewNickName) in
            inputNewNickName.placeholder = "New task".localized()
            inputNewNickName.textAlignment = .center
            inputNewNickName.font = TiTiFont.HGGGothicssiP60g(size: 17)
        }
        alert.addAction(cancle)
        alert.addAction(ok)
        present(alert,animated: true,completion: nil)
    }
    
    private func showAlertEditTargetTime(index: Int, time: Int) {
        
    }
}

// MARK: ModifyTask
extension taskSelectViewController {
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
//        if sender.state == .began {
//            let touchPoint = sender.location(in: tasksTableView)
//            if let indexPath = tasksTableView.indexPathForRow(at: touchPoint) {
//                let alert = UIAlertController(title: "Modify subject's name".localized(), message: "Enter a subject that's max length is 20".localized(), preferredStyle: .alert)
//                let cancle = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
//                let ok = UIAlertAction(title: "ENTER", style: .default, handler: {
//                    action in
//                    let newTask: String = alert.textFields?[0].text ?? ""
//                    //이건 기록들 중 과목내용 수정 및 저장
//                    self.resetTaskname(before: self.tasks[indexPath.row], after: newTask)
//                    self.tasks[indexPath.row] = newTask
//                    self.table.reloadData()
//                    self.saveTasks()
//                })
//                //텍스트 입력 추가
//                alert.addTextField { (inputNewNickName) in
//                    inputNewNickName.placeholder = "New subject".localized()
//                    inputNewNickName.textAlignment = .center
//                    inputNewNickName.font = TiTiFont.HGGGothicssiP60g(size: 17)
//                    //기존 내용 보이기
//                    inputNewNickName.text = self.tasks[indexPath.row]
//                }
//                alert.addAction(cancle)
//                alert.addAction(ok)
//                present(alert,animated: true,completion: nil)
//            }
//        }
    }
    
    func resetTaskname(before: String, after: String) {
        let currentTask = RecordController.shared.recordTimes.recordTask
        var tasks = RecordController.shared.daily.tasks
        
        if let beforeTime = tasks[before] {
            tasks.removeValue(forKey: before)
            tasks[after] = beforeTime
            RecordController.shared.daily.updateTasks(to: tasks)
        }
        
        if currentTask == before {
            self.delegate?.selectTask(to: after)
        }
    }
}

// MARK: TableView
extension taskSelectViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.tasks.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.identifier, for: indexPath) as? TaskCell else {
            return .init()
        }
        guard let task = self.viewModel?.tasks[safe: indexPath.row] else { return cell }
        
        cell.configure(task: task, color: UIColor(named: "D1"))
        cell.toggleTargetTime = { [weak self] isOn in
            self?.viewModel?.updateTaskOn(at: indexPath.row, to: isOn)
        }
        cell.editTargetTime = { [weak self] in
            self?.showAlertEditTargetTime(index: indexPath.row, time: task.taskTargetTime)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedTask = self.viewModel?.tasks[safe: indexPath.row] else { return }
        self.delegate?.selectTask(to: selectedTask.taskName)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //제거 액션 설정
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] action, index in
            self?.viewModel?.deleteTask(at: indexPath.row)
            self?.tasksTableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.viewModel?.moveTask(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
        self.reloadAfterAnimation()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TaskCell.height
    }
}
