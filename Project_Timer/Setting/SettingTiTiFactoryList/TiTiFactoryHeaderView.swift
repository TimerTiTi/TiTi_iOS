//
//  TiTiFactoryHeaderView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/05.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class TiTiFactoryHeaderView: UICollectionReusableView {
    static let identifier = "TiTiFactoryHeaderView"
    
    private weak var delegate: FactoryActionDelegate?
    
    func configure(delegate: FactoryActionDelegate) {
        self.delegate = delegate
    }
        
    @IBAction func showDevelopmentList(_ sender: Any) {
        self.delegate?.showWebview(url: NetworkURL.developmentList)
    }
    
    @IBAction func goInstaToTiTi(_ sender: Any) {
        self.delegate?.showWebview(url: NetworkURL.instagramToTiTi)
    }
}
