//
//  NotificationBottomSheetVC.swift
//  Project_Timer
//
//  Created by Minsang on 5/11/25.
//  Copyright © 2025 FDEE. All rights reserved.
//

import UIKit
import SwiftUI

final class NotificationBottomSheetVC: BaseBottomSheetVC {
    
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

extension NotificationBottomSheetVC {
    private func configureHostingVC() {
        let notificationView = NotificationBottomSheetView(info: noti) { [weak self] in
            self?.dismissBottomSheet()
        } passWeekAction: { isPass in
            print("isPass: \(isPass)")
        }

        let hostingController = UIHostingController(rootView: notificationView)
        hostingController.view.backgroundColor = .clear
        
        addChild(hostingController)
        hostingController.didMove(toParent: self)
        
        super.addContent(hostingController.view)
    }
}
