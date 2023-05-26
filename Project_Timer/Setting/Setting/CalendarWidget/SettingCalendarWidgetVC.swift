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
    private let informationButton = NavigationBarInformationButton()
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
        scrollView.layer.cornerRadius = 25
        scrollView.layer.cornerCurve = .continuous
        scrollView.clipsToBounds = true
        NSLayoutConstraint.activate([
            scrollView.widthAnchor.constraint(equalToConstant: self.frameWidth)
        ])
        return scrollView
    }()
    private var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private var colorSelector: ThemeColorSelectorView!
    private var colorDirection: ThemeColorDirectionView!
    private var targetTimeView: TargetTimeView!
    private let dailyTargetButton = TargetTimeButton(key: .calendarWidgetTargetTime)
    private var frameWidth: CGFloat {
        let windowWidth: CGFloat = min(SceneDelegate.sharedWindow?.bounds.width ?? 390, SceneDelegate.sharedWindow?.bounds.height ?? 844)
        return min(windowWidth, 439)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.colorSelector = ThemeColorSelectorView(delegate: self, key: .calendarWidgetColor)
        self.colorDirection = ThemeColorDirectionView(delegate: self, colorKey: .calendarWidgetColor, directionKey: .calendarWidgetColorIsReverse)
        self.targetTimeView = TargetTimeView(text: "Setting the target time for color density display based on total time by date".localized())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationBar()
        self.configureUI()
        self.configureWidget()
        self.configureTargetButton()
    }
}

extension SettingCalendarWidgetVC {
    private func configureNavigationBar() {
        self.informationButton.showsMenuAsPrimaryAction = true
        self.informationButton.menu = UIMenu(title: "Calendar widget".localizedForWidget(), image: nil, children: [
            UIAction(title: "About Widget".localized(), image: nil) { [weak self] _ in
                self?.showHowToUseWidgetVC(url: NetworkURL.WidgetInfo.calendarWidget)
            },
            UIAction(title: "How to add Widget".localized(), image: nil) { [weak self] _ in
                self?.showHowToAddWidgetVC()
            }]
        )
        
        let rightItem = UIBarButtonItem(customView: self.informationButton)
        self.navigationItem.setRightBarButton(rightItem, animated: true)
    }
    
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
            self.contentScrollView.topAnchor.constraint(equalTo: self.bottomSettingView.topAnchor),
            self.contentScrollView.centerXAnchor.constraint(equalTo: self.bottomSettingView.centerXAnchor),
            self.contentScrollView.bottomAnchor.constraint(equalTo: self.bottomSettingView.bottomAnchor)
        ])
        
        self.contentScrollView.addSubview(self.contentView)
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.contentScrollView.topAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.contentScrollView.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.contentScrollView.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.contentScrollView.bottomAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.contentScrollView.widthAnchor, multiplier: 1)
        ])
        
        self.contentView.addSubview(self.colorSelector)
        NSLayoutConstraint.activate([
            self.colorSelector.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            self.colorSelector.widthAnchor.constraint(equalToConstant: self.frameWidth),
            self.colorSelector.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
        
        self.contentView.addSubview(self.colorDirection)
        NSLayoutConstraint.activate([
            self.colorDirection.topAnchor.constraint(equalTo: self.colorSelector.bottomAnchor, constant: 48),
            self.colorDirection.widthAnchor.constraint(equalToConstant: self.frameWidth),
            self.colorDirection.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
        
        self.contentView.addSubview(self.targetTimeView)
        NSLayoutConstraint.activate([
            self.targetTimeView.topAnchor.constraint(equalTo: self.colorDirection.bottomAnchor, constant: 48),
            self.targetTimeView.widthAnchor.constraint(equalToConstant: self.frameWidth),
            self.targetTimeView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
        
        self.contentView.addSubview(self.dailyTargetButton)
        NSLayoutConstraint.activate([
            self.dailyTargetButton.topAnchor.constraint(equalTo: self.targetTimeView.bottomAnchor, constant: 16),
            self.dailyTargetButton.widthAnchor.constraint(equalToConstant: self.frameWidth - 32),
            self.dailyTargetButton.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.dailyTargetButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16)
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
    
    private func configureTargetButton() {
        self.dailyTargetButton.addAction(UIAction(handler: { [weak self] _ in
            guard let dailyTargetButton = self?.dailyTargetButton else { return }
            
            self?.showAlertWithTextField(title: "Target time".localized(), text: "Input Daily's Target time (Hour)".localized(), placeHolder: "\(dailyTargetButton.settedHour/3600)") { [weak self] hour in
                UserDefaultsManager.set(to: hour*3600, forKey: dailyTargetButton.key)
                self?.update()
            }
        }), for: .touchUpInside)
    }
}

extension SettingCalendarWidgetVC: Updateable {
    func update() {
        RecordsManager.shared.dailyManager.saveCalendarWidgetData()
        self.configureWidget()
        self.colorDirection.updateColor()
        self.dailyTargetButton.updateTime()
    }
}

extension SettingCalendarWidgetVC {
    private func showAlertWithTextField(title: String, text: String, placeHolder: String, handler: @escaping ((Int) -> Void)) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.font = TiTiFont.HGGGothicssiP60g(size: 14)
            textField.textColor = .label
            textField.placeholder = placeHolder
            textField.textAlignment = .center
            textField.keyboardType = .numberPad
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        let update = UIAlertAction(title: "Done", style: .destructive) { _ in
            guard let text = alert.textFields?.first?.text,
                  let hour = Int(text) else { return }
            handler(hour)
        }
        alert.addAction(cancel)
        alert.addAction(update)
        
        self.present(alert, animated: true)
    }
    
    private func showHowToUseWidgetVC(url: String) {
        let contentViewController = HowToUseWidgetVC(url: url)
        let bottomSheetViewController = BottomSheetViewController(contentViewController: contentViewController, defaultHeight: 1500, cornerRadius: 25, isPannedable: false)
        contentViewController.configureDelegate(to: bottomSheetViewController)
        
        self.present(bottomSheetViewController, animated: true)
    }
    
    private func showHowToAddWidgetVC() {
        
    }
}
