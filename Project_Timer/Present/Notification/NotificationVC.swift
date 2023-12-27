//
//  NotificationVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/16.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit
import SwiftUI

final class NotificationVC: PopupVC {
    let noti: NotificationInfo
    let notificationUseCase: NotificationUseCaseInterface
    
    init(noti: NotificationInfo, notificationUseCase: NotificationUseCaseInterface) {
        self.noti = noti
        self.notificationUseCase = notificationUseCase
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureHostingVC()
    }
}

extension NotificationVC {
    private func configureHostingVC() {
        let hostingVC = UIHostingController(rootView: TTNotificationView(info: noti, closeAction: { [weak self] in
            self?.dismiss(animated: true)
        }, passAction: { [weak self] in
            self?.notificationUseCase.setPassDay()
            self?.dismiss(animated: true)
        }))
        self.addChild(hostingVC)
        hostingVC.didMove(toParent: self)
        
        hostingVC.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(hostingVC.view)
        NSLayoutConstraint.activate([
            hostingVC.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            hostingVC.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            hostingVC.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            hostingVC.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        hostingVC.view.backgroundColor = .clear
    }
}
