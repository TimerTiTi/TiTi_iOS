//
//  TodoCell.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/03/16.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

class TodoCell: UITableViewCell {
    static let identifier = "TodoCell"
    
    @IBOutlet weak var check: UIButton!
    @IBOutlet weak var todoText: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var delete: UIButton!
    
    var doneButtonTapHandler: ((Bool) -> Void)?
    var deleteButtonTapHandler: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delete.isHidden = true
    }
    
    @IBAction func checkTapped(_ sender: Any) {
        self.check.isSelected.toggle()
        let isDone = self.check.isSelected
        self.showColorView(isDone)
        self.doneButtonTapHandler?(isDone)
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        self.deleteButtonTapHandler?()
    }
    
    func configure(todo: Todo, color: UIColor?) {
        self.check.tintColor = color
        self.colorView.backgroundColor = color
        self.check.isSelected = todo.isDone
        self.todoText.text = todo.text
        self.showColorView(todo.isDone)
    }
    
    private func showColorView(_ show: Bool) {
        if show {
            self.colorView.isHidden = false
            self.delete.isHidden = false
        } else {
            self.colorView.isHidden = true
            self.delete.isHidden = true
        }
    }
}
