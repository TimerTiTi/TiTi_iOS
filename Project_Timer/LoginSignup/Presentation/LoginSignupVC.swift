//
//  LoginSignupVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/09/25.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit
import Combine
import SwiftUI

final class LoginSignupVC: PortraitVC {
    private var environment: LoginSignupEnvironment?
    private var cancellables: Set<AnyCancellable> = []
    
    override func loadView() {
        super.loadView()
        self.environment = LoginSignupEnvironment(rootVC: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        self.configureHostingVC()
        self.bindListener()
    }
    
    private func configureHostingVC() {
        guard let environment = self.environment else { return }
        let hostingVC = UIHostingController(rootView: LoginSelectView().environmentObject(environment))
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
    }
    
    private func bindListener() {
        self.environment?.$dismiss
            .receive(on: DispatchQueue.main)
            .sink { [weak self] dismiss in
                if dismiss {
                    self?.dismiss(animated: true)
                }
            }
            .store(in: &self.cancellables)
        
        self.environment?.$loginSuccess
            .receive(on: DispatchQueue.main)
            .sink { [weak self] success in
                guard success else { return }
                self?.dismiss(animated: true)
            }
            .store(in: &self.cancellables)
    }
}
