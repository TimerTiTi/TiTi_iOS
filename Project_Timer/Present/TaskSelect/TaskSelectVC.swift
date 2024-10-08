//
//  TaskSelectVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/04/05.
//  Copyright © 2021 FDEE. All rights reserved.
//

import UIKit
import Combine

final class TaskSelectVC: UIViewController {
    static let identifier = "TaskSelectVC"
    
    @IBOutlet weak var tasksTableView: UITableView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var newTaskButton: UIButton!
    /* mac */
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    
    weak var delegate: TaskChangeable?
    private var viewModel: TaskSelectVM?
    private var cancellables: Set<AnyCancellable> = []
    private var tintColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.editButton.titleLabel?.font = Typographys.uifont(.semibold_4, size: 18)
        self.editButton.setTitle(self.tasksTableView.isEditing ? Localized.string(.Common_Text_Done) : Localized.string(.Common_Text_Edit), for: .normal)
        self.configureDevice()
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
        self.editButton.setTitle(self.tasksTableView.isEditing ? Localized.string(.Common_Text_Done) : Localized.string(.Common_Text_Edit), for: .normal)
    }
    
    @IBAction func close(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
}

// MARK: Configure
extension TaskSelectVC {
    private func configureDevice() {
        #if targetEnvironment(macCatalyst)
        self.closeButton.isHidden = false
        self.collectionViewBottomConstraint.constant = 35
        #endif
    }
    
    private func configureColor() {
        self.tintColor = UIColor(named: String.userTintColor)
        self.editButton.setTitleColor(self.tintColor, for: .normal)
        self.newTaskButton.tintColor = self.tintColor
        self.closeButton.setTitleColor(self.tintColor, for: .normal)
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
extension TaskSelectVC {
    private func bindAll() {
        self.bindTasks()
        self.bindSelectedTask()
    }
    
    private func bindTasks() {
        self.viewModel?.$tasks
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.reloadAfterAnimation()
            })
            .store(in: &self.cancellables)
    }
    
    private func bindSelectedTask() {
        self.viewModel?.$selectedTask
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] taskName in
                guard let taskName = taskName else { return }
                self?.delegate?.selectTask(to: taskName)
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
extension TaskSelectVC {
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: self.tasksTableView)
            guard let indexPath = self.tasksTableView.indexPathForRow(at: touchPoint),
                  let beforeTaskName = self.viewModel?.tasks[safe: indexPath.row]?.taskName else { return }
            
            let alert = UIAlertController(title: Localized.string(.Tasks_Popup_EditTaskName), message: Localized.string(.Tasks_Popup_NewTaskDesc), preferredStyle: .alert)
            let cancle = UIAlertAction(title: Localized.string(.Common_Text_Cencel), style: .default, handler: nil)
            let ok = UIAlertAction(title: Localized.string(.Common_Text_OK), style: .destructive, handler: { [weak self] action in
                let newTask: String = alert.textFields?[0].text ?? ""
                
                guard self?.viewModel?.isSameNameExist(name: newTask) == false else {
                    self?.showAlertWithOK(title: Localized.string(.Tasks_Popup_SameTaskExistTitle), text: Localized.string(.Tasks_Popup_SameTaskExistDesc))
                    return
                }
                
                self?.viewModel?.updateTaskName(at: indexPath.row, to: newTask)
                self?.tasksTableView.reloadData()
            })
            
            alert.addTextField { (inputNewNickName) in
                inputNewNickName.placeholder = Localized.string(.Tasks_Hint_NewTaskTitle)
                inputNewNickName.textAlignment = .center
                inputNewNickName.font = .systemFont(ofSize: 17, weight: .semibold)
                inputNewNickName.text = beforeTaskName
            }
            alert.addAction(cancle)
            alert.addAction(ok)
            
            present(alert,animated: true,completion: nil)
        }
    }
    
    private func showAlertNewTask() {
        let alert = UIAlertController(title: Localized.string(.Tasks_Hint_NewTaskTitle), message: Localized.string(.Tasks_Popup_NewTaskDesc), preferredStyle: .alert)
        let cancle = UIAlertAction(title: Localized.string(.Common_Text_Cencel), style: .default, handler: nil)
        let ok = UIAlertAction(title: Localized.string(.Common_Text_OK), style: .destructive, handler: { [weak self] action in
            guard let newTask: String = alert.textFields?[0].text,
                  let count = self?.viewModel?.tasks.count else { return }
            
            guard self?.viewModel?.isSameNameExist(name: newTask) == false else {
                self?.showAlertWithOK(title: Localized.string(.Tasks_Popup_SameTaskExistTitle), text: Localized.string(.Tasks_Popup_SameTaskExistDesc))
                return
            }
            
            self?.viewModel?.addNewTask(taskName: newTask)
            self?.tasksTableView.insertRows(at: [IndexPath.init(row: count, section: 0)], with: .automatic)
        })
        
        alert.addTextField { (inputNewNickName) in
            inputNewNickName.placeholder = Localized.string(.Tasks_Hint_NewTaskTitle)
            inputNewNickName.textAlignment = .center
            inputNewNickName.font = .systemFont(ofSize: 17, weight: .semibold)
        }
        alert.addAction(cancle)
        alert.addAction(ok)
        
        present(alert,animated: true,completion: nil)
    }
    
    private func showAlertEditTargetTime(index: Int, time: Int) {
        guard let targetTimeSettingVC = storyboard?.instantiateViewController(withIdentifier: TargetTimeSettingPopupVC.identifier) as? TargetTimeSettingPopupVC else { return }
        guard let task = self.viewModel?.tasks[safe: index] else { return }
        targetTimeSettingVC.configure(task: task)
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.setValue(targetTimeSettingVC, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: Localized.string(.Common_Text_OK), style: .default, handler: { [weak self] _ in
            guard let targetTime = targetTimeSettingVC.settedTargetTime else { return }
            self?.viewModel?.updateTaskTime(at: index, to: targetTime)
            self?.tasksTableView.reloadData()
        }))
        present(alert, animated: true)
    }
}

// MARK: TableView
extension TaskSelectVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.tasks.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.identifier, for: indexPath) as? TaskCell else {
            return .init()
        }
        guard let task = self.viewModel?.tasks[safe: indexPath.row] else { return cell }
        
        cell.configure(task: task, color: self.tintColor)
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
        let deleteAction = UITableViewRowAction(style: .destructive, title: Localized.string(.Common_Text_Delete)) { [weak self] action, index in
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
