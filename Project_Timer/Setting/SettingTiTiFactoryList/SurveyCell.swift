//
//  SurveyCell.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/05.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class SurveyCell: UICollectionViewCell {
    static let identifier = "SurveyCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var touchableMark: UIImageView!
    @IBOutlet weak var warningLabel: UILabel!
    private weak var delegate: FactoryActionDelegate?
    private var info: SurveyInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.warningLabel.isHidden = true
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                guard let url = self.info?.url else { return }
                self.delegate?.showWebview(url: url)
            }
        }
    }
    
    func configure(with info: SurveyInfo, delegate: FactoryActionDelegate) {
        self.delegate = delegate
        self.info = info
        
        self.contentView.backgroundColor = UIColor.secondarySystemGroupedBackground
        self.titleLabel.text = info.title
        self.touchableMark.isHidden = false
        self.warningLabel.isHidden = true
    }
    
    func configureWarning() {
        self.contentView.backgroundColor = .clear
        self.titleLabel.text = ""
        self.touchableMark.isHidden = true
        self.warningLabel.isHidden = false
    }
}
