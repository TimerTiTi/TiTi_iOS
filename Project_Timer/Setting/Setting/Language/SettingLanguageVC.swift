//
//  SettingLanguageVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/12.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

final class SettingLanguageVC: UIViewController {
    static let identifier = "SettingLanguageVC"
    
    private let viewModel: SettingLanguageVM
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        self.viewModel = SettingLanguageVM()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Localized.string(.Settings_Button_LanguageOption)
        self.view.backgroundColor = .systemGroupedBackground
        
        self.configureHostingVC()
        self.bindViewModel()
    }
}

extension SettingLanguageVC {
    private func configureHostingVC() {
        let hostingVC = UIHostingController(rootView: SettingLanguageListView(viewModel: self.viewModel))
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
        
        hostingVC.view.backgroundColor = .systemGroupedBackground
    }
}

extension SettingLanguageVC {
    private func bindViewModel() {
        self.viewModel.$selected
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] selected in
                self?.showAlertWithOKAfterHandler(
                    title: Localized.string(.Language_Popup_LanguageChangeTitle),
                    text: Localized.string(.Language_Popup_LanguageChangeDesc),
                    completion: {
                        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            exit(0)
                        }
                    })
            }
            .store(in: &cancellables)
    }
}
