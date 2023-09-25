//
//  LoginSignupVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/09/25.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit

final class LoginSignupVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
        
        let button = UIButton(configuration: .filled())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("close", for: .normal)
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.dismiss(animated: true)
        }), for: .touchUpInside)
        
        self.view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
}
