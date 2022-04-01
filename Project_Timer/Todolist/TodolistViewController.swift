//
//  todolistViewController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/06/09.
//  Copyright © 2021 FDEE. All rights reserved.
//

import UIKit

class TodolistViewController: UIViewController {
    @IBOutlet weak var fraim: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var inputFraim: UIView!
    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var inputBottom: NSLayoutConstraint!
    @IBOutlet weak var todos: UITableView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var todayLabel: UILabel!
    
    let todoListViewModel = TodolistViewModel()
    private var color: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.configureRadius()
        self.configureColor()
        self.todoListViewModel.loadTodos()
        
        // TODO: 키보드 디텍션 : keyboard가 띄워지고, 사라지면 adjustInputView가 실행되는 원리 : OK
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureTodayLabel()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.configureShadow(self.innerView) // Dynamic CGColor
    }
    
    @IBAction func addList(_ sender: Any) {
        guard let text = input.text, text.isEmpty == false else { return }
        let todo = TodoManager.shared.createTodo(text: text)
        self.todoListViewModel.addTodo(todo)
        self.todos.reloadData()
        self.input.text = ""
    }
    
    @IBAction func editAction(_ sender: Any) {
        self.todos.setEditing(!self.todos.isEditing, animated: true)
    }
}


extension TodolistViewController {
    private func configureTableView() {
        self.todos.dataSource = self
        self.todos.delegate = self
        self.todos.separatorInset.left = 0
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        self.todos.addGestureRecognizer(longPress)
    }
    
    private func configureRadius() {
        innerView.layer.cornerRadius = 25
        inputFraim.clipsToBounds = true
        inputFraim.layer.cornerRadius = 5
        inputFraim.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func configureShadow(_ view: UIView) {
        view.layer.shadowColor = UIColor(named: "shadow")?.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 5
    }
    
    private func configureColor() {
        let colorIndex = UserDefaults.standard.value(forKey: "startColor") as? Int ?? 1
        self.color = UIColor(named: "D\(colorIndex)")
        self.editButton.setTitleColor(self.color, for: .normal)
    }
    
    private func configureTodayLabel() {
        var daily = Daily()
        daily.load()
        self.todayLabel.text = daily.day.MDstyleString
    }
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: self.todos)
            guard let indexPath = self.todos.indexPathForRow(at: touchPoint) else { return }
            let alert = UIAlertController(title: "Modify Todo's content".localized(), message: "", preferredStyle: .alert)
            let cancle = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
            let ok = UIAlertAction(title: "ENTER", style: .default, handler: {
                action in
                let newName: String = alert.textFields?[0].text ?? ""
                //이건 기록들 중 과목내용 수정 및 저장
                TodoManager.shared.todos[indexPath.row].rename(text: newName)
                TodoManager.shared.saveTodo()
                self.todos.reloadRows(at: [indexPath], with: .automatic)
            })
            //텍스트 입력 추가
            alert.addTextField { (newName) in
                newName.placeholder = "New Todo's content".localized()
                newName.textAlignment = .center
                newName.font = UIFont(name: "HGGGothicssiP60g", size: 17)
                //기존 내용 보이기
                newName.text = TodoManager.shared.todos[indexPath.row].text
            }
            alert.addAction(cancle)
            alert.addAction(ok)
            present(alert,animated: true,completion: nil)
        }
    }
    
    @objc private func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        // TODO: 키보드 높이에 따른 인풋뷰 위치 변경 : OK
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        var adjustmentHeight: CGFloat = 0
        //이동시킬 Height를 구한다
        if noti.name == UIResponder.keyboardWillShowNotification {
            self.hideKeyboard()
            adjustmentHeight = keyboardFrame.height - view.safeAreaInsets.bottom
        } else {
            self.view.gestureRecognizers?.removeAll()
            adjustmentHeight = 0
        }
        //구한 Height 만큼 변화시킨다
        self.inputBottom.constant = adjustmentHeight
        self.view.layoutIfNeeded()
        print("--> keyboard End Frame: \(keyboardFrame)")
    }
}


extension TodolistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoListViewModel.todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.identifier, for: indexPath) as? TodoCell else {
            return UITableViewCell() }
        
        var todo = todoListViewModel.todos[indexPath.row]
        cell.configure(todo: todo, color: self.color)
        
        cell.doneButtonTapHandler = { isDone in
            todo.isDone = isDone
            self.todoListViewModel.updateTodo(todo)
        }
        
        cell.deleteButtonTapHandler = {
            self.todoListViewModel.deleteTodo(todo)
            self.todos.reloadData()
        }
        
        return cell
    }
}

extension TodolistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            let todo = self.todoListViewModel.todos[indexPath.row]
            self.todoListViewModel.deleteTodo(todo)
            self.todos.deleteRows(at: [indexPath], with: .automatic)
        }

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var todos = TodoManager.shared.todos
        let target = todos.remove(at: sourceIndexPath.row)
        todos.insert(target, at: destinationIndexPath.row)
        TodoManager.shared.todos = todos
        TodoManager.shared.saveTodo()
    }
}
