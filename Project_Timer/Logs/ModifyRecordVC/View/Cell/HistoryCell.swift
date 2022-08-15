//
//  HistoryCell.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/08/14.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

protocol EditHistoryButtonDelegate: AnyObject {
    func editHistoryButtonTapped(at indexPath: IndexPath?)
}

class HistoryCell: UITableViewCell {
    static let identifier = "HistoryCell"
    static let height = CGFloat(42)
    
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var timeIntervalLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var underLine: UIView!
    
    private weak var delegate: EditHistoryButtonDelegate?
    var indexPath: IndexPath? {
        return (self.superview as? UITableView)?.indexPath(for: self)
    }
    
    @IBAction func editHistoryButtonTapped(_ sender: UIButton) {
        self.delegate?.editHistoryButtonTapped(at: self.indexPath)
    }
    
    override func awakeFromNib() {
        self.startTimeLabel.backgroundColor = UIColor(named: String.userTintColor)?.withAlphaComponent(0.5)
        self.endTimeLabel.backgroundColor = UIColor(named: String.userTintColor)?.withAlphaComponent(0.5)
        self.underLine.backgroundColor = UIColor(named: String.userTintColor)
    }
    
    override func prepareForReuse() {
        let defaultTimeLabelString = "00:00:00"
        
        self.startTimeLabel.text = defaultTimeLabelString
        self.endTimeLabel.text = defaultTimeLabelString
        self.timeIntervalLabel.text = defaultTimeLabelString
    }
}

extension HistoryCell {
    func configure(with taskHistory: TaskHistory?) {
        guard let taskHistory = taskHistory else { return }
        
        self.startTimeLabel.text = taskHistory.startDate.HHmmssStyleString
        self.endTimeLabel.text = taskHistory.endDate.HHmmssStyleString
        self.timeIntervalLabel.text = taskHistory.interval.toHHmmss
    }
    
    func configureDelegate(_ delegate: EditHistoryButtonDelegate) {
        self.delegate = delegate
    }
}
