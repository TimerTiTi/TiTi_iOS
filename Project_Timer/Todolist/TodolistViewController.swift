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
    @IBOutlet weak var todoGroupButton: UIButton!
    @IBOutlet weak var selectTodoGroupButton: UIButton!
    
    private var color: UIColor?
    private var viewModel: TodolistVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewModel()
        self.configureTodoGroupButton()
        self.configureSelectTodoGroupButton()
        self.configureTableView()
        self.configureRadius()
        self.configureKeyboard()
        self.todos.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.updateTabbarColor(backgroundColor: TiTiColor.tabbarBackground, tintColor: .label, normalColor: .lightGray)
        self.configurePointColor()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.innerView.configureShadow() // Dynamic CGColor
        self.tabBarController?.updateTabbarColor(backgroundColor: TiTiColor.tabbarBackground, tintColor: .label, normalColor: .lightGray)
    }
    
    @IBAction func addList(_ sender: Any) {
        guard let text = input.text,
              text.isEmpty == false else { return }
        self.viewModel?.addNewTodo(text: text)
        let count = self.viewModel?.todos.count ?? 0
        self.todos.insertRows(at: [IndexPath.init(row: count-1, section: 0)], with: .automatic)
        self.reloadAfterAnimation()
        self.input.text = ""
    }
    
    @IBAction func editAction(_ sender: Any) {
        self.todos.setEditing(!self.todos.isEditing, animated: true)
        self.editButton.setTitle(self.todos.isEditing ? "Done" : "Edit", for: .normal)
    }
}

extension TodolistViewController {
    private func configureViewModel() {
        self.viewModel = TodolistVM()
    }
    
    private func configureTodoGroupButton() {
        guard let todoGroupName = self.viewModel?.currentTodoGroup else { return }
        self.todoGroupButton.setTitle(todoGroupName, for: .normal)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(changeGroupName))
        self.todoGroupButton.addGestureRecognizer(longPress)
    }
    
    private func configureSelectTodoGroupButton() {
        self.selectTodoGroupButton.setImage(UIImage(named: "bars-3")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.selectTodoGroupButton.menu = self.getMenu()
        self.selectTodoGroupButton.showsMenuAsPrimaryAction = true
    }
    
    private func getMenu() -> UIMenu {
        guard let todolist = self.viewModel?.todolist else { return UIMenu() }
        let todoGroupNames = todolist.todoGroups.map({ $0.groupName })
        var actions = todoGroupNames.map { groupName in
            UIAction(title: groupName, image: nil) { [weak self] _ in
                self?.viewModel?.changeTodoGroup(to: groupName)
                self?.changeTodoGroupTitle(to: groupName)
                self?.todos.reloadData()
            }
        }
        actions.append(UIAction(title: "Add New Group", image: nil, attributes: .destructive) { [weak self] _ in
            self?.addNewGroup()
        })
        return UIMenu(title: "Todo Groups", image: nil, children: actions)
    }
    
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
    
    private func configureKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func configurePointColor() {
        let colorIndex = UserDefaults.standard.value(forKey: "startColor") as? Int ?? 1
        self.color = UIColor(named: "D\(colorIndex)")
        self.editButton.setTitleColor(self.color, for: .normal)
        self.todos.reloadData()
    }
    
    private func reloadAfterAnimation() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(400)) { [weak self] in
            self?.todos.reloadData()
        }
    }
    
    @objc func changeGroupName() {
        let alert = UIAlertController(title: "Modify Todo Group's Name".localized(), message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "New Todo Group Name".localized()
            textField.textAlignment = .center
            textField.font = TiTiFont.HGGGothicssiP60g(size: 17)
            textField.text = self.viewModel?.currentTodoGroup ?? "Untitled"
        }
        let cancle = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "UPDATE", style: .default, handler: { [weak self] action in
            guard let newText: String = alert.textFields?.first?.text else { return }
            self?.viewModel?.updateTodoGroupName(to: newText)
            self?.changeTodoGroupTitle(to: newText)
        })
        
        alert.addAction(cancle)
        alert.addAction(ok)
        present(alert,animated: true,completion: nil)
    }
    
    private func addNewGroup() {
        let alert = UIAlertController(title: "Add New Todo Group".localized(), message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "New Todo Group Name".localized()
            textField.textAlignment = .center
            textField.font = TiTiFont.HGGGothicssiP60g(size: 17)
            textField.text = ""
        }
        let cancle = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "ADD", style: .default, handler: { [weak self] action in
            guard let newText: String = alert.textFields?.first?.text else { return }
            self?.viewModel?.addNewTodoGroup(newText)
            self?.changeTodoGroupTitle(to: newText)
            self?.todos.reloadData()
        })
        
        alert.addAction(cancle)
        alert.addAction(ok)
        present(alert,animated: true,completion: nil)
    }
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: self.todos)
            guard let indexPath = self.todos.indexPathForRow(at: touchPoint),
                  let originText = self.viewModel?.todos[indexPath.row].text else { return }
            
            let alert = UIAlertController(title: "Modify Todo's content".localized(), message: "", preferredStyle: .alert)
            alert.addTextField { textField in
                textField.placeholder = "New Todo's content".localized()
                textField.textAlignment = .center
                textField.font = TiTiFont.HGGGothicssiP60g(size: 17)
                textField.text = originText
            }
            let cancle = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
            let ok = UIAlertAction(title: "UPDATE", style: .default, handler: { [weak self] action in
                guard let newText: String = alert.textFields?.first?.text else { return }
                
                self?.viewModel?.updateText(at: indexPath.row, to: newText)
                self?.todos.reloadRows(at: [indexPath], with: .automatic)
                self?.reloadAfterAnimation()
            })
            
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
            self.appTapGestureForDismissingKeyboard()
            adjustmentHeight = keyboardFrame.height - view.safeAreaInsets.bottom
        } else {
            self.view.gestureRecognizers?.removeAll()
            adjustmentHeight = 0
        }
        //구한 Height 만큼 변화시킨다
        self.inputBottom.constant = adjustmentHeight
        self.view.layoutIfNeeded()
    }
}

extension TodolistViewController {
    private func changeTodoGroupTitle(to title: String) {
        self.todoGroupButton.setTitle(title, for: .normal)
        self.selectTodoGroupButton.menu = self.getMenu()
    }
}

extension TodolistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.todos.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.identifier, for: indexPath) as? TodoCell else {
            return UITableViewCell() }
        guard let todo = self.viewModel?.todos[indexPath.row] else { return cell }
        
        cell.configure(todo: todo, color: self.color)
        cell.doneButtonTapHandler = { [weak self] isDone in
            self?.viewModel?.updateDone(at: indexPath.row, to: isDone)
        }
        cell.deleteButtonTapHandler = { [weak self] in
            self?.viewModel?.deleteTodo(at: indexPath.row)
            self?.todos.deleteRows(at: [indexPath], with: .automatic)
            self?.reloadAfterAnimation()
        }
        
        return cell
    }
}

extension TodolistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] action, index in
            self?.viewModel?.deleteTodo(at: indexPath.row)
            self?.todos.deleteRows(at: [indexPath], with: .automatic)
            self?.reloadAfterAnimation()
        }

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.viewModel?.moveTodo(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
        self.reloadAfterAnimation()
    }
}
