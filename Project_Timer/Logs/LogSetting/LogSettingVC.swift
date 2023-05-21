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
    private weak var delegate: LogUpdateable?
    
    private var themeColorSelector: ThemeColorSelectorView!
    private var themeColorDirection: ThemeColorDirectionView!
    private var logTargetTimeView: LogTargetTimeView!
    private let monthTargetButton = TargetTimeButton(key: .goalTimeOfMonth)
    private let weekTargetButton = TargetTimeButton(key: .goalTimeOfWeek)
    private var frameWidth: CGFloat {
        let windowWidth: CGFloat = min(SceneDelegate.sharedWindow?.bounds.width ?? 390, SceneDelegate.sharedWindow?.bounds.height ?? 844)
        return min(windowWidth, 439+32)
    }
    
    init(delegate: LogUpdateable) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        
        self.themeColorSelector = ThemeColorSelectorView(delegate: self)
        self.themeColorDirection = ThemeColorDirectionView(delegate: self)
        self.logTargetTimeView = LogTargetTimeView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureTargetButtons()
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
        
        self.view.addSubview(self.themeColorDirection)
        NSLayoutConstraint.activate([
            self.themeColorDirection.widthAnchor.constraint(equalToConstant: self.frameWidth),
            self.themeColorDirection.topAnchor.constraint(equalTo: self.themeColorSelector.bottomAnchor, constant: 32),
            self.themeColorDirection.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        self.view.addSubview(self.logTargetTimeView)
        NSLayoutConstraint.activate([
            self.logTargetTimeView.widthAnchor.constraint(equalToConstant: self.frameWidth),
            self.logTargetTimeView.topAnchor.constraint(equalTo: self.themeColorDirection.bottomAnchor, constant: 32),
            self.logTargetTimeView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        self.view.addSubview(self.monthTargetButton)
        NSLayoutConstraint.activate([
            self.monthTargetButton.widthAnchor.constraint(equalToConstant: self.frameWidth - 32),
            self.monthTargetButton.topAnchor.constraint(equalTo: self.logTargetTimeView.bottomAnchor, constant: 16),
            self.monthTargetButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        self.view.addSubview(self.weekTargetButton)
        NSLayoutConstraint.activate([
            self.weekTargetButton.widthAnchor.constraint(equalToConstant: self.frameWidth - 32),
            self.weekTargetButton.topAnchor.constraint(equalTo: self.monthTargetButton.bottomAnchor, constant: 8),
            self.weekTargetButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    private func configureTargetButtons() {
        self.monthTargetButton.addAction(UIAction(handler: { [weak self] _ in
            print("select")
        }), for: .touchUpInside)
        
        self.weekTargetButton.addAction(UIAction(handler: { [weak self] _ in
            print("select")
        }), for: .touchUpInside)
    }
}

extension LogSettingVC: LogUpdateable {
    func update() {
        self.themeColorDirection.updateColor()
        self.delegate?.update()
    }
}
