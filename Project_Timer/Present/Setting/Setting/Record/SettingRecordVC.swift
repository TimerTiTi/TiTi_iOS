//
//  SettingRecordVC.swift
//  Project_Timer
//
//  Created by Minsang on 5/3/25.
//  Copyright © 2025 FDEE. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

final class SettingRecordVC: UIViewController {
    
    private let viewModel: SettingRecordViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        self.viewModel = SettingRecordViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Localized.string(.Settings_Button_Record)
        view.backgroundColor = .systemGroupedBackground
        
        configureHostingVC()
        bind()
    }
    
}

extension SettingRecordVC {
    
    private func configureHostingVC() {
        let hostingVC = UIHostingController(rootView: SettingRecordListView(viewModel: viewModel))
        self.addChild(hostingVC)
        hostingVC.didMove(toParent: self)
        
        hostingVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingVC.view)
        NSLayoutConstraint.activate([
            hostingVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hostingVC.view.backgroundColor = .systemGroupedBackground
    }
    
    private func bind() {
        
        viewModel.$showPopup
            .filter { $0 }
            .sink { [weak self] _ in
                guard let self else { return }
                showAlertWithNumInput(title: Localized.string(.SettingRecord_Text_RecordResetTimeTitle), text: Localized.string(.SettingRecord_Popup_InputRecordResetTime), placeHolder: "\(viewModel.resetHour)") { [weak self] hour in
                    guard (0...23).contains(hour) else { return }
                    self?.viewModel.action(.changeResetHour(to: hour))
                }
            }
            .store(in: &cancellables)
    }
    
}
