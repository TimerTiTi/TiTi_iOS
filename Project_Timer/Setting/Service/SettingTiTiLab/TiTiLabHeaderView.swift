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
    @IBOutlet weak var developmentListLabel: UILabel!
    @IBOutlet weak var developmentListTextLabel: UILabel!
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
        
    @IBAction func showDevelopmentList(_ sender: Any) {
        self.delegate?.showWebview(url: NetworkURL.developmentList)
    }
    
    @IBAction func goInstaToTiTi(_ sender: Any) {
        self.delegate?.showWebview(url: NetworkURL.instagramToTiTi)
    }
}

extension TiTiLabHeaderView {
    private func configureLocalized() {
        self.developmentStatusLabel.text = "TiTi Development".localized()
        self.developmentListLabel.text = "Development list".localized()
        self.developmentListTextLabel.text = "Real-time development progress can be checked.\nYou can also check the next features in advance.".localized()
        self.instagramTextLabel.text = "Check out the news on TiTi's official Instagram account.".localized()
        
        self.participationDevelopLabel.text = "Participation in Develop".localized()
        self.surveyLabel.text = "Survey".localized()
        self.surveyTextLabel.text = "It greatly helps to develop and improve new features.\nNew surveys are added in real time.".localized()
    }
}
