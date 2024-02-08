//
//  AddHistoryCollectionViewCell.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/08/16.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

protocol AddNewTaskHistoryButtonDelegate: AnyObject {
    func addNewTaskHistoryButtonTapped()
}

final class AddNewTaskHistoryCell: UICollectionViewCell {
    static let identifier = "AddNewTaskHistoryCell"
    static let height = CGFloat(20)
    
    private weak var delegate: AddNewTaskHistoryButtonDelegate?
    @IBOutlet weak var createNewTask: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.createNewTask.titleLabel?.font = Typographys.uifont(.semibold_4, size: 11)
        self.createNewTask.setTitle("+ " + Localized.string(.EditDaily_Button_CreateNewTaskHistory), for: .normal)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        self.delegate?.addNewTaskHistoryButtonTapped()
    }
}

extension AddNewTaskHistoryCell {
    func configureDelegate(_ delegate: AddNewTaskHistoryButtonDelegate) {
        self.delegate = delegate
    }
}
