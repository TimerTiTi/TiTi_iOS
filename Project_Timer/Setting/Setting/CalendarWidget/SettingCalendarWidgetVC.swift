//
//  SettingCalendarWidgetVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/05/24.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit
import SwiftUI

final class SettingCalendarWidgetVC: UIViewController {
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.text = "Widget shows the top 5 tasks and the recording time by date.".localizedForWidget()
        label.textColor = .lightGray
        label.numberOfLines = 0
        return label
    }()
    private var widgetFrameView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 29
        view.layer.cornerCurve = .continuous
        // MARK: iPhone 13 Pro 기준 사이즈 표시
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 338),
            view.heightAnchor.constraint(equalToConstant: 158)
        ])
        return view
    }()
    private var bottomSettingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 25
        view.layer.cornerCurve = .continuous
        return view
    }()
    private lazy var contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.layer.cornerRadius = 14
        scrollView.layer.cornerCurve = .continuous
        scrollView.clipsToBounds = true
        scrollView.showsVerticalScrollIndicator = false
        NSLayoutConstraint.activate([
            scrollView.widthAnchor.constraint(equalToConstant: self.frameWidth - 32)
        ])
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
        return min(windowWidth, 439)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.configureWidget()
    }
}

extension SettingCalendarWidgetVC {
    private func configureUI() {
        self.title = "Calendar widget".localizedForWidget()
        self.view.backgroundColor = .systemGroupedBackground
        
        self.view.addSubview(self.descriptionLabel)
        NSLayoutConstraint.activate([
            self.descriptionLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            self.descriptionLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            self.descriptionLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.descriptionLabel.textAlignment = .left
        } else {
            self.descriptionLabel.textAlignment = .center
        }
        
        self.view.addSubview(self.widgetFrameView)
        NSLayoutConstraint.activate([
            self.widgetFrameView.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 16),
            self.widgetFrameView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        self.view.addSubview(self.bottomSettingView)
        NSLayoutConstraint.activate([
            self.bottomSettingView.topAnchor.constraint(equalTo: self.widgetFrameView.bottomAnchor, constant: 16),
            self.bottomSettingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.bottomSettingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.bottomSettingView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        self.bottomSettingView.addSubview(self.contentScrollView)
        NSLayoutConstraint.activate([
            self.contentScrollView.topAnchor.constraint(equalTo: self.bottomSettingView.topAnchor, constant: 16),
            self.contentScrollView.centerXAnchor.constraint(equalTo: self.bottomSettingView.centerXAnchor),
            self.contentScrollView.bottomAnchor.constraint(equalTo: self.bottomSettingView.bottomAnchor, constant: -16)
        ])
        
        self.contentScrollView.addSubview(self.contentView)
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.contentScrollView.topAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.contentScrollView.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.contentScrollView.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.contentScrollView.bottomAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.contentScrollView.widthAnchor, multiplier: 1),
            self.contentView.heightAnchor.constraint(equalToConstant: 1000)
        ])
    }
    
    private func configureWidget() {
        self.widgetFrameView.subviews.forEach { $0.removeFromSuperview() }
        guard let calendarWidgetData = Storage.retrive(CalendarWidgetData.fileName, from: .sharedContainer, as: CalendarWidgetData.self) else { return }
        let hostingVC = UIHostingController(rootView: CalendarWidgetView(calendarWidgetData, backgroundColor: Color(UIColor.secondarySystemGroupedBackground)))
        self.addChild(hostingVC)
        hostingVC.didMove(toParent: self)
        
        self.widgetFrameView.addSubview(hostingVC.view)
        hostingVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingVC.view.topAnchor.constraint(equalTo: self.widgetFrameView.topAnchor),
            hostingVC.view.leadingAnchor.constraint(equalTo: self.widgetFrameView.leadingAnchor),
            hostingVC.view.trailingAnchor.constraint(equalTo: self.widgetFrameView.trailingAnchor),
            hostingVC.view.bottomAnchor.constraint(equalTo: self.widgetFrameView.bottomAnchor)
        ])
        hostingVC.view.layer.cornerRadius = 29
        hostingVC.view.layer.cornerCurve = .continuous
        hostingVC.view.clipsToBounds = true
    }
}
