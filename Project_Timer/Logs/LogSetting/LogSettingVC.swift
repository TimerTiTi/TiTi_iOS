//
//  LogSettingVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/05/20.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit

final class LogSettingVC: UIViewController {
    static let identifier = "LogSettingVC"
    
    private let themeColorSelector: ThemeColorSelectorView
    private var frameWidth: CGFloat {
        let windowWidth: CGFloat = min(SceneDelegate.sharedWindow?.bounds.width ?? 390, SceneDelegate.sharedWindow?.bounds.height ?? 844)
        return min(windowWidth, 439+32)
    }
    
    init(delegate: LogUpdateable) {
        self.themeColorSelector = ThemeColorSelectorView(delegate: delegate)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
    }
}

extension LogSettingVC {
    private func configureUI() {
        self.view.backgroundColor = .secondarySystemGroupedBackground
        
        self.view.addSubview(self.themeColorSelector)
        NSLayoutConstraint.activate([
            self.themeColorSelector.widthAnchor.constraint(equalToConstant: self.frameWidth),
            self.themeColorSelector.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.themeColorSelector.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
}
