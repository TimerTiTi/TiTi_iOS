//
//  HowToUseWidgetVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/05/26.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit

final class HowToUseWidgetVC: UIViewController {
    private weak var delegate: Closeable?
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = TiTiFont.HGGGothicssiP80g(size: 17)
        label.textColor = .black
        label.text = "About Widget".localized()
        return label
    }()
    private var closeButton : CloseButton = {
        let button = CloseButton()
        button.tintColor = .black
        return button
    }()
    private let url: String
    
    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.configureCloseButton()
    }
    
    func configureDelegate(to delegate: Closeable) {
        self.delegate = delegate
    }
}

extension HowToUseWidgetVC {
    private func configureUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 16),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        self.view.addSubview(self.closeButton)
        NSLayoutConstraint.activate([
            self.closeButton.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
            self.closeButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureCloseButton() {
        self.closeButton.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.close()
        }), for: .touchUpInside)
    }
}
