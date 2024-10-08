//
//  AddHistoryCell.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/08/15.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

protocol AddHistoryButtonDelegate: AnyObject {
    func addHistoryButtonTapped()
}

final class AddHistoryCell: UITableViewCell {
    static let identifier = "AddHistoryCell"
    static let height = CGFloat(42)
    
    private weak var delegate: AddHistoryButtonDelegate?
    @IBOutlet weak var createNewRecord: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.createNewRecord.titleLabel?.font = Typographys.uifont(.semibold_4, size: 12)
        self.createNewRecord.setTitle(Localized.string(.EditDaily_Button_AppendNewHistory), for: .normal)
    }
    
    @IBAction func addHistoryButtonTapped(_ sender: UIButton) {
        self.delegate?.addHistoryButtonTapped()
    }
}

extension AddHistoryCell {
    func configureDelegate(_ delegate: AddHistoryButtonDelegate) {
        self.delegate = delegate
    }
}
