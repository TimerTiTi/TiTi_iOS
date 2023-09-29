//
//  WhiteNavigationVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/09/29.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit

class WhiteNavigationVC: PortraitVC {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationStyle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.disableNavigationStyle()
    }
    
    // MARK: NavigationBar
    private func configureNavigationStyle(color: UIColor = .white) {
        self.navigationController?.navigationBar.tintColor = color
        self.navigationItem.largeTitleDisplayMode = .never
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]
        self.navigationController?.navigationBar.topItem?.title = ""
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func disableNavigationStyle() {
        self.navigationController?.navigationBar.tintColor = .tintColor
        self.navigationItem.largeTitleDisplayMode = .automatic
        
        self.tabBarController?.tabBar.isHidden = false
    }
}
