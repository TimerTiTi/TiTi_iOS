//
//  todolistViewController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/06/09.
//  Copyright © 2021 FDEE. All rights reserved.
//

import UIKit

class TodolistViewController: UIViewController {

    @IBOutlet var fraim: UIView!
    @IBOutlet var innerView: UIView!
    
    @IBOutlet var inputFraim: UIView!
    @IBOutlet var input: UITextField!
    @IBOutlet var add: UIButton!
    @IBOutlet var inputBottom: NSLayoutConstraint!
    
    @IBOutlet var collectionView: UICollectionView!
    
    let todoListViewModel = TodolistViewModel()
    private var color: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        
        self.configureRadius()
        self.configureShadow(self.innerView)
        self.configureColor()
        
        self.todoListViewModel.loadTodos()
        
        // TODO: 키보드 디텍션 : keyboard가 띄워지고, 사라지면 adjustInputView가 실행되는 원리 : OK
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func addList(_ sender: Any) {
        guard let text = input.text, text.isEmpty == false else { return }
        let todo = TodoManager.shared.createTodo(text: text)
        self.todoListViewModel.addTodo(todo)
        self.collectionView.reloadData()
        
        self.input.text = ""
    }
}


extension TodolistViewController {
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
    }
    
    @objc private func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        // TODO: 키보드 높이에 따른 인풋뷰 위치 변경 : OK
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        var adjustmentHeight: CGFloat = 0
        //이동시킬 Height를 구한다
        if noti.name == UIResponder.keyboardWillShowNotification {
            adjustmentHeight = keyboardFrame.height - view.safeAreaInsets.bottom
        } else {
            adjustmentHeight = 0
        }
        //구한 Height 만큼 변화시킨다
        self.inputBottom.constant = adjustmentHeight
        self.view.layoutIfNeeded()
        print("--> keyboard End Frame: \(keyboardFrame)")
    }
}


extension TodolistViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todoListViewModel.todos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodoCell.identifier, for: indexPath) as? TodoCell else {
            return UICollectionViewCell() }
        
        var todo = todoListViewModel.todos[indexPath.item]
        cell.configure(todo: todo, color: self.color)
        
        cell.doneButtonTapHandler = { isDone in
            todo.isDone = isDone
            self.todoListViewModel.updateTodo(todo)
        }
        
        cell.deleteButtonTapHandler = {
            self.todoListViewModel.deleteTodo(todo)
            self.collectionView.reloadData()
        }
        
        return cell
    }
}
