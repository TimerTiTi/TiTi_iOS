//
//  todolistViewController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/06/09.
//  Copyright © 2021 FDEE. All rights reserved.
//

import UIKit
import Combine

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
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewModel()
        self.configureTodoGroupButton()
        self.configureSelectTodoGroupButton()
        self.configureTableView()
        self.configureRadius()
        self.configureKeyboard()
        self.bindAll()
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
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(changeGroupName))
        self.todoGroupButton.addGestureRecognizer(longPress)
    }
    
    private func configureSelectTodoGroupButton() {
        self.selectTodoGroupButton.setImage(UIImage(named: "bars-3")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.selectTodoGroupButton.showsMenuAsPrimaryAction = true
    }
    
    private func getMenu(_ currentGroupName: String) -> UIMenu {
        guard let groupNames = self.viewModel?.groups.map(\.groupName) else { return UIMenu() }
        
        var menu: [UIMenuElement] = groupNames.map { groupName in
            UIAction(title: groupName, image: nil, state: groupName == currentGroupName ? .on : .off) { [weak self] _ in
                self?.viewModel?.changeTodoGroup(to: groupName)
            }
        }
        let subMenu = UIMenu(title: "", options: .displayInline, children: [
            UIAction(title: "Create Group".localized(), image: UIImage(systemName: "plus"), state: .off) { [weak self] _ in
                self?.addNewGroup()
            },
            UIAction(title: "Delete Group".localized(), image: UIImage(systemName: "trash"), attributes: .destructive, state: .off) { [weak self] _ in
                self?.deleteGroup()
            }
        ])
        menu.append(subMenu)
        return UIMenu(title: "Todo Groups", image: nil, children: menu)
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
        let alert = UIAlertController(title: "Modify Group's Name".localized(), message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "New Group Name".localized()
            textField.textAlignment = .center
            textField.font = TiTiFont.HGGGothicssiP60g(size: 17)
            textField.text = self.viewModel?.currentGroupName ?? "Untitled"
        }
        let cancle = UIAlertAction(title: "CANCEL", style: .default, handler: nil)
        let ok = UIAlertAction(title: "UPDATE", style: .destructive, handler: { [weak self] action in
            guard let newText: String = alert.textFields?.first?.text else { return }
            if self?.viewModel?.updateTodoGroupName(to: newText) == false {
                // 다른 TodoGroup명 alert
            }
        })
        
        alert.addAction(cancle)
        alert.addAction(ok)
        present(alert,animated: true,completion: nil)
    }
    
    private func addNewGroup() {
        let alert = UIAlertController(title: "Create Group".localized(), message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "New Group Name".localized()
            textField.textAlignment = .center
            textField.font = TiTiFont.HGGGothicssiP60g(size: 17)
            textField.text = ""
        }
        let cancle = UIAlertAction(title: "CANCEL", style: .default, handler: nil)
        let ok = UIAlertAction(title: "ADD", style: .default, handler: { [weak self] action in
            guard let newText: String = alert.textFields?.first?.text else { return }
            if self?.viewModel?.addNewTodoGroup(newText) == false {
                // 다른 TodoGroup명 alert
            }
        })
        
        alert.addAction(cancle)
        alert.addAction(ok)
        present(alert,animated: true,completion: nil)
    }
    
    private func deleteGroup() {
        guard let target = self.viewModel?.currentGroupName else { return }
        let locale = NSLocale.current.languageCode
        let title = locale == "ko" ? "\(target) 삭제" : "Delete \(target)"
        let subTitle = locale == "ko" ? "\(target) 그룹을 삭제하시겠습니까?" : "Do you want to delete \(target) group?"
        let alert = UIAlertController(title: title, message: subTitle, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
        let delete = UIAlertAction(title: "DELETE", style: .destructive, handler: { [weak self] _ in
            self?.viewModel?.deleteTodoGroup()
        })
        
        alert.addAction(cancel)
        alert.addAction(delete)
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
    private func bindAll() {
        self.bindGroupName()
    }
    
    private func bindGroupName() {
        self.viewModel?.$currentGroupName
            .sink(receiveValue: { [weak self] groupName in
                self?.changeTodoGroupTitle(to: groupName)
                self?.todos.reloadData()
            })
            .store(in: &self.cancellables)
    }
}

extension TodolistViewController {
    private func changeTodoGroupTitle(to groupName: String) {
        self.todoGroupButton.setTitle(groupName, for: .normal)
        self.selectTodoGroupButton.menu = self.getMenu(groupName)
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
