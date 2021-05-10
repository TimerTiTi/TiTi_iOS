//
//  taskSelectViewController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/04/05.
//  Copyright © 2021 FDEE. All rights reserved.
//

import UIKit

class taskSelectViewController: UIViewController {
    
    
    @IBOutlet var studyTitle: UILabel!
    @IBOutlet var table: UITableView!
    
    var tasks: [String] = []
    var SetTimerViewControllerDelegate : ChangeViewController2!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalizable()
        tasks = UserDefaults.standard.value(forKey: "tasks") as? [String] ?? []
    }
    
    @IBAction func test_new(_ sender: Any) {
        let alert = UIAlertController(title: "Enter a new subject".localized(), message: "Enter a subject that's max length is 20".localized(), preferredStyle: .alert)
        let cancle = UIAlertAction(title: "CANCLE", style: .default, handler: nil)
        let ok = UIAlertAction(title: "ENTER", style: .destructive, handler: {
            action in
            let newTask: String = alert.textFields?[0].text ?? ""
            // 위 변수를 통해 특정기능 수행
//            self.selectTask(newTask)
            self.addTableCell(newTask)
        })
        //텍스트 입력 추가
        alert.addTextField { (inputNewNickName) in
            inputNewNickName.placeholder = "New subject".localized()
            inputNewNickName.textAlignment = .center
            inputNewNickName.font = UIFont(name: "HGGGothicssiP60g", size: 17)
        }
        alert.addAction(ok)
        alert.addAction(cancle)
        present(alert,animated: true,completion: nil)
    }
    
    func selectTask(_ task: String) {
        UserDefaults.standard.set(task, forKey: "task")
        SetTimerViewControllerDelegate.changeTask()
        self.dismiss(animated: true, completion: nil)
    }
    
    func addTableCell(_ task: String) {
        tasks.append(task)
        saveTasks()
        table.reloadData()
    }
    
    func saveTasks() {
        UserDefaults.standard.set(tasks, forKey: "tasks")
    }
    
    func setLocalizable() {
        studyTitle.text = "Select a subject".localized()
    }
    
}

extension taskSelectViewController: UITableViewDataSource, UITableViewDelegate {
    //몇개 표시 할까?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    //셀 어떻게 표시 할까?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskListCell", for: indexPath) as? taskListCell else {
            return UITableViewCell()
        }
        cell.taskName.text = tasks[indexPath.row]
        return cell
    }
    // 클릭했을때 어떻게 할까?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.item]
        selectTask(task)
    }
    
    //제거 액션여부 설정
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //제거 액션 설정
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            self.tasks.remove(at: indexPath.row)
            self.saveTasks()
            self.table.deleteRows(at: [indexPath], with: .automatic)
        }
        return [deleteAction]
    }
}

class taskListCell: UITableViewCell {
    @IBOutlet var taskName: UILabel!
}
