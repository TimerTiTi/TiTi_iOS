//
//  TiTiLabHeaderView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/05.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class TiTiLabHeaderView: UICollectionReusableView {
    /* public */
    static let identifier = "TiTiLabHeaderView"
    /* private */
    @IBOutlet weak var developmentStatusLabel: UILabel!
    @IBOutlet weak var instagramTextLabel: UILabel!
    
    @IBOutlet weak var participationDevelopLabel: UILabel!
    @IBOutlet weak var surveyLabel: UILabel!
    @IBOutlet weak var surveyTextLabel: UILabel!
    
    private weak var delegate: TiTiLabActionDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureLocalized()
    }
    
    func configure(delegate: TiTiLabActionDelegate) {
        self.delegate = delegate
    }
    
    @IBAction func goInstaToTiTi(_ sender: Any) {
        self.delegate?.showWebview(url: NetworkURL.instagramToTiTi)
    }
}

extension TiTiLabHeaderView {
    private func configureLocalized() {
        self.developmentStatusLabel.font = Typographys.uifont(.semibold_4, size: 14)
        self.developmentStatusLabel.text = Localized.string(.TiTiLab_Text_DevelopNews)
        self.instagramTextLabel.font = Typographys.uifont(.semibold_4, size: 11)
        self.instagramTextLabel.text = Localized.string(.TiTiLab_Button_InstagramDesc)
        self.participationDevelopLabel.font = Typographys.uifont(.semibold_4, size: 14)
        self.participationDevelopLabel.text = Localized.string(.TiTiLab_Text_PartInDev)
        self.surveyLabel.font = Typographys.uifont(.semibold_4, size: 17)
        self.surveyLabel.text = Localized.string(.TiTiLab_Text_SurveyTitle)
        self.surveyTextLabel.font = Typographys.uifont(.semibold_4, size: 11)
        self.surveyTextLabel.text = Localized.string(.TiTiLab_Text_SurveyDesc)
    }
}
