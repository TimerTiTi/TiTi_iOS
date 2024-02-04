//
//  HowToAddWidgetVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/05/26.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit

final class HowToAddWidgetVC: UIViewController {
    private weak var delegate: Closeable?
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Typographys.uifont(.bold_5, size: 17)
        label.textColor = .black
        label.text = Localized.string(.WidgetSetting_Button_AddMethod)
        return label
    }()
    private var closeButton : CloseButton = {
        let button = CloseButton()
        button.tintColor = .black
        return button
    }()
    private lazy var contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.clipsToBounds = true
        return scrollView
    }()
    private var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private var frameWidth: CGFloat {
        let windowWidth: CGFloat = min(SceneDelegate.sharedWindow?.bounds.width ?? 390, SceneDelegate.sharedWindow?.bounds.height ?? 844)
        return min(windowWidth, 439) - 16
    }
    private var languageCode: String {
        return Language.current == .ko ? "kor" : "eng"
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

extension HowToAddWidgetVC {
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
        
        self.view.addSubview(self.contentScrollView)
        NSLayoutConstraint.activate([
            self.contentScrollView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 16),
            self.contentScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.contentScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.contentScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        self.contentScrollView.addSubview(self.contentView)
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.contentScrollView.topAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.contentScrollView.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.contentScrollView.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.contentScrollView.bottomAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.contentScrollView.widthAnchor, multiplier: 1),
        ])
        
        // MARK: Content
        
        let content1 = HowToAddWidgetContentView(step: 1, description: Localized.string(.WidgetSetting_Text_WidgetDesc1), imageName: "howToAdd_\(1)_\(languageCode)")
        self.contentView.addSubview(content1)
        NSLayoutConstraint.activate([
            content1.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            content1.widthAnchor.constraint(equalToConstant: self.frameWidth),
            content1.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
        
        let content2 = HowToAddWidgetContentView(step: 2, description: Localized.string(.WidgetSetting_Text_WidgetDesc2), imageName: "howToAdd_\(2)_\(languageCode)")
        self.contentView.addSubview(content2)
        NSLayoutConstraint.activate([
            content2.topAnchor.constraint(equalTo: content1.bottomAnchor, constant: 32),
            content2.widthAnchor.constraint(equalToConstant: self.frameWidth),
            content2.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
        
        let content3 = HowToAddWidgetContentView(step: 3, description: Localized.string(.WidgetSetting_Text_WidgetDesc3), imageName: "howToAdd_\(3)_\(languageCode)")
        self.contentView.addSubview(content3)
        NSLayoutConstraint.activate([
            content3.topAnchor.constraint(equalTo: content2.bottomAnchor, constant: 32),
            content3.widthAnchor.constraint(equalToConstant: self.frameWidth),
            content3.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
        
        let content4 = HowToAddWidgetContentView(step: 4, description: Localized.string(.WidgetSetting_Text_WidgetDesc4), imageName: "howToAdd_\(4)_\(languageCode)")
        self.contentView.addSubview(content4)
        NSLayoutConstraint.activate([
            content4.topAnchor.constraint(equalTo: content3.bottomAnchor, constant: 32),
            content4.widthAnchor.constraint(equalToConstant: self.frameWidth),
            content4.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
        
        let content5 = HowToAddWidgetContentView(step: 5, description: Localized.string(.WidgetSetting_Text_WidgetDesc5), imageName: "howToAdd_\(5)_\(languageCode)")
        self.contentView.addSubview(content5)
        NSLayoutConstraint.activate([
            content5.topAnchor.constraint(equalTo: content4.bottomAnchor, constant: 32),
            content5.widthAnchor.constraint(equalToConstant: self.frameWidth),
            content5.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            content5.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -32)
        ])
    }
    
    private func configureCloseButton() {
        self.closeButton.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.close()
        }), for: .touchUpInside)
    }
}
