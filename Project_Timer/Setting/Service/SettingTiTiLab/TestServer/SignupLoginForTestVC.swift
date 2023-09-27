//
//  SignupLoginForTestVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/09/27.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit

class SignupLoginForTestVC: UIViewController {
    private var viewModel: SignupLoginVM
    
    init(viewModel: SignupLoginVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TiTiColor.loginBackground
        print(self.viewModel.isLogin)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.adjustUI(type: size.deviceDetailType)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.adjustUI(type: self.view.bounds.size.deviceDetailType)
    }
}

extension SignupLoginForTestVC {
    private func adjustUI(type: CGSize.DeviceDetailType) {
        print(type, type.rawValue)
    }
}
