//
//  FunctionInfoCell.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/05.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class FunctionInfoCell: UICollectionViewCell {
    static let identifier = "FunctionInfoCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    private weak var delegate: FunctionsActionDelegate?
    private var info: FunctionInfo?
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                guard let url = self.info?.url.value else { return }
                self.delegate?.showWebview(url: url)
            }
        }
    }
    
    func configure(with info: FunctionInfo, delegate: FunctionsActionDelegate) {
        self.delegate = delegate
        self.info = info
        self.titleLabel.text = info.title.value
    }
}
