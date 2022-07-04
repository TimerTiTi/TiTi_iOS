//
//  TiTiLabHeaderView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/05.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class TiTiLabHeaderView: UICollectionReusableView {
    static let identifier = "TiTiLabHeaderView"
    
    private weak var delegate: TiTiLabActionDelegate?
    
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
