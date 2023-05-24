//
//  LogSettingVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/05/20.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit

final class LogSettingVC: UIViewController {
    static let identifier = "LogSettingVC"
    private weak var delegate: Updateable?
    
    private var themeColorSelector: ThemeColorSelectorView!
    private var themeColorDirection: ThemeColorDirectionView!
    private var logTargetTimeView: TargetTimeView!
    private let monthTargetButton = TargetTimeButton(key: .goalTimeOfMonth)
    private let weekTargetButton = TargetTimeButton(key: .goalTimeOfWeek)
    private var frameWidth: CGFloat {
        let windowWidth: CGFloat = min(SceneDelegate.sharedWindow?.bounds.width ?? 390, SceneDelegate.sharedWindow?.bounds.height ?? 844)
        return min(windowWidth, 439)
    }
    
    init(delegate: Updateable) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        
        self.themeColorSelector = ThemeColorSelectorView(delegate: self, key: .startColor)
        self.themeColorDirection = ThemeColorDirectionView(delegate: self, colorKey: .startColor, directionKey: .reverseColor)
        self.logTargetTimeView = TargetTimeView(text: "Setting the target time of Circular Progress Bar".localized())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureTargetButtons()
    }
}

extension LogSettingVC {
    private func configureUI() {
        self.view.backgroundColor = .secondarySystemGroupedBackground
        
        self.view.addSubview(self.themeColorSelector)
        NSLayoutConstraint.activate([
            self.themeColorSelector.widthAnchor.constraint(equalToConstant: self.frameWidth),
            self.themeColorSelector.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 16),
            self.themeColorSelector.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        self.view.addSubview(self.themeColorDirection)
        NSLayoutConstraint.activate([
            self.themeColorDirection.widthAnchor.constraint(equalToConstant: self.frameWidth),
            self.themeColorDirection.topAnchor.constraint(equalTo: self.themeColorSelector.bottomAnchor, constant: 48),
            self.themeColorDirection.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        self.view.addSubview(self.logTargetTimeView)
        NSLayoutConstraint.activate([
            self.logTargetTimeView.widthAnchor.constraint(equalToConstant: self.frameWidth),
            self.logTargetTimeView.topAnchor.constraint(equalTo: self.themeColorDirection.bottomAnchor, constant: 48),
            self.logTargetTimeView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        self.view.addSubview(self.monthTargetButton)
        NSLayoutConstraint.activate([
            self.monthTargetButton.widthAnchor.constraint(equalToConstant: self.frameWidth - 32),
            self.monthTargetButton.topAnchor.constraint(equalTo: self.logTargetTimeView.bottomAnchor, constant: 16),
            self.monthTargetButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        self.view.addSubview(self.weekTargetButton)
        NSLayoutConstraint.activate([
            self.weekTargetButton.widthAnchor.constraint(equalToConstant: self.frameWidth - 32),
            self.weekTargetButton.topAnchor.constraint(equalTo: self.monthTargetButton.bottomAnchor, constant: 8),
            self.weekTargetButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    private func configureTargetButtons() {
        self.monthTargetButton.addAction(UIAction(handler: { [weak self] _ in
            guard let monthTargetButton = self?.monthTargetButton else { return }
            
            self?.showAlertWithTextField(title: "Target time".localized(), text: "Input Month's Target time (Hour)".localized(), placeHolder: "\(monthTargetButton.settedHour/3600)") { [weak self] hour in
                UserDefaultsManager.set(to: hour*3600, forKey: monthTargetButton.key)
                self?.update()
            }
        }), for: .touchUpInside)
        
        self.weekTargetButton.addAction(UIAction(handler: { [weak self] _ in
            guard let weekTargetButton = self?.weekTargetButton else { return }
            
            self?.showAlertWithTextField(title: "Target time".localized(), text: "Input Week's Target time (Hour)".localized(), placeHolder: "\(weekTargetButton.settedHour/3600)") { [weak self] hour in
                UserDefaultsManager.set(to: hour*3600, forKey: weekTargetButton.key)
                self?.update()
            }
        }), for: .touchUpInside)
    }
}

extension LogSettingVC: Updateable {
    func update() {
        self.themeColorDirection.updateColor()
        self.monthTargetButton.updateTime()
        self.weekTargetButton.updateTime()
        self.delegate?.update()
    }
}

// alert 내에서 textField를 통해 int값을 입력, 0이 아닌경우에만 활성화, 취소, 확인 버튼 추가
extension LogSettingVC {
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
}
