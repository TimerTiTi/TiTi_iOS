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
    var startColorIndex: Int = 0
    var colorIndex: Int = 0
    var colors: [UIColor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        
        setRadius()
        setShadow(innerView)
        
        setColors()
        setColorIndex()
        
        todoListViewModel.loadTodos()
        
        // TODO: 키보드 디텍션 : keyboard가 띄워지고, 사라지면 adjustInputView가 실행되는 원리 : OK
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func addList(_ sender: Any) {
        guard let text = input.text, text.isEmpty == false else { return }
        let todo = TodoManager.shared.createTodo(text: text)
        todoListViewModel.addTodo(todo)
        
        collectionView.reloadData()
        input.text = ""
        self.view.endEditing(true)
        inputBottom.constant = 0
        self.view.layoutIfNeeded()
    }
    
}


extension TodolistViewController {
    
    func setRadius() {
        innerView.layer.cornerRadius = 25
//        inputFraim.layer.cornerRadius = 25
        inputFraim.clipsToBounds = true
        inputFraim.layer.cornerRadius = 5
        inputFraim.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func setShadow(_ view: UIView) {
        view.layer.shadowColor = UIColor(named: "shadow")?.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 5
    }
    
    func setColors() {
        var colors: [UIColor] = []
        for i in 1...12 {
            colors.append(UIColor(named: "D\(i)")!)
        }
        self.colors = colors
    }
    
    func setColorIndex() {
        startColorIndex = UserDefaults.standard.value(forKey: "startColor") as? Int ?? 1
    }
    
    func getIndex(_ i: Int) -> Int {
        let index = (startColorIndex-1+i)%12
        return index
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodoCell", for: indexPath) as? TodoCell else {
            return UICollectionViewCell() }
        
        var todo = todoListViewModel.todos[indexPath.item]
//        let index = getIndex(indexPath.row)
        cell.check.tintColor = UIColor(named: "D\(startColorIndex)")
        cell.colorView.backgroundColor = UIColor(named: "D\(startColorIndex)")
        cell.updateUI(todo: todo)
        self.view.layoutIfNeeded()
        
        cell.doneButtonTapHandler = { isDone in
            todo.isDone = isDone
            self.todoListViewModel.updateTodo(todo)
            self.collectionView.reloadData()
        }
        
        cell.deleteButtonTapHandler = {
            self.todoListViewModel.deleteTodo(todo)
            self.collectionView.reloadData()
        }
        
        return cell
    }
}


class TodoCell: UICollectionViewCell {
    @IBOutlet weak var check: UIButton!
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var delete: UIButton!
    
    var doneButtonTapHandler: ((Bool) -> Void)?
    var deleteButtonTapHandler: (() -> Void)?
    
    @IBAction func checkTapped(_ sender: Any) {
        check.isSelected = !check.isSelected
        let isDone = check.isSelected
        showColorView(isDone)
        delete.isHidden = !isDone
        doneButtonTapHandler?(isDone)
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        deleteButtonTapHandler?()
    }
    
    func reset() {
        delete.isHidden = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reset()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    func updateUI(todo: Todo) {
        check.isSelected = todo.isDone
        text.text = todo.text
        delete.isHidden = todo.isDone == false
        showColorView(todo.isDone)
    }
    
    private func showColorView(_ show: Bool) {
        if show {
            colorView.alpha = 0.5
        } else {
            colorView.alpha = 0
        }
    }
    
    
}
