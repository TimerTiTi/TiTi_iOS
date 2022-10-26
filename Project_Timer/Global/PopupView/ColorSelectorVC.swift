//
//  ColorSelectorVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/10/11.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

protocol ColorUpdateable: AnyObject {
    func fetchColor()
}

final class ColorSelectorVC: UIViewController {
    static let identifier = "ColorSelectorVC"
    enum Target {
        case timer
        case stopwatcch
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundLabel: UILabel!
    @IBOutlet weak var textTintLabel: UILabel!
    
    @IBOutlet weak var backgroundColorButton: UIButton!
    @IBOutlet weak var TextTintColorButton: UIButton!
    
    private var target: Target = .stopwatcch
    private weak var delegate: ColorUpdateable?
    private var backgroundColor: UIColor?
    private var textTintColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureLocalized()
        self.fetchColor()
    }
    
    func configure(target: Target, delegate: ColorUpdateable) {
        self.target = target
        self.delegate = delegate
    }
    
    @IBAction func backgroundSelected(_ sender: Any) {
        self.showColorSelectVC()
    }
    
    @IBAction func tintSelected(_ sender: Any) {
        self.popoverSelectColor() { [weak self] isWhite in
            self?.updateTextColor(isWhite: isWhite)
        }
    }
}

extension ColorSelectorVC {
    private func configureLocalized() {
        self.titleLabel.text = "Custom Color".localized()
        self.backgroundLabel.text = "Background".localized()
        self.textTintLabel.text = "TextColor".localized()
    }
    
    private func fetchColor() {
        self.textTintColor = UIColor.white
        
        switch self.target {
        case .timer:
            self.backgroundColor = TiTiColor.background
            if let color = UserDefaults.standard.colorForKey(key: .timerBackground) {
                self.backgroundColor = color
            }
            let isWhite = UserDefaultsManager.get(forKey: .timerTextIsWhite) as? Bool ?? true
            self.textTintColor = isWhite ? .white : .black
        case .stopwatcch:
            self.backgroundColor = TiTiColor.background2
            if let color = UserDefaults.standard.colorForKey(key: .stopwatchBackground) {
                self.backgroundColor = color
            } else if let color = UserDefaults.standard.colorForKey(key: .color) {
                self.backgroundColor = color
            }
            let isWhite = UserDefaultsManager.get(forKey: .stopwatchTextIsWhite) as? Bool ?? true
            self.textTintColor = isWhite ? .white : .black
        }
        
        self.updateColor()
    }
    
    private func updateColor() {
        self.backgroundColorButton.backgroundColor = self.backgroundColor
        self.TextTintColorButton.backgroundColor = self.textTintColor
        self.delegate?.fetchColor()
    }
    
    private func showColorSelectVC() {
        if #available(iOS 14.0, *) {
            let picker = UIColorPickerViewController()
            picker.selectedColor = self.backgroundColor!
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        } else {
            self.showAlertWithOK(title: "iOS 14.0 이상 기능", text: "업데이트 후 사용해주시기 바랍니다.")
        }
    }
    
    private func updateTextColor(isWhite: Bool) {
        self.textTintColor = isWhite ? .white : .black
        switch self.target {
        case .timer:
            UserDefaultsManager.set(to: isWhite, forKey: .timerTextIsWhite)
        case .stopwatcch:
            UserDefaultsManager.set(to: isWhite, forKey: .stopwatchTextIsWhite)
        }
        self.updateColor()
    }
}

extension ColorSelectorVC: UIColorPickerViewControllerDelegate {
    @available(iOS 14.0, *)
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        self.changeBackgroundColor(to: viewController.selectedColor)
    }
    
    @available(iOS 14.0, *)
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        self.changeBackgroundColor(to: viewController.selectedColor)
    }
    
    private func changeBackgroundColor(to color: UIColor) {
        self.backgroundColor = color
        let key: UserDefaults.Keys = self.target == .timer ? .timerBackground : .stopwatchBackground
        UserDefaults.standard.setColor(color: color, forKey: key)
        self.updateColor()
    }
}

extension ColorSelectorVC: UIPopoverPresentationControllerDelegate {
    func popoverSelectColor(handler: @escaping TextColorHandler) {
        guard let pickerVC = storyboard?.instantiateViewController(withIdentifier: ColorofTextSelectorVC.identifier) as? ColorofTextSelectorVC else { return }
        
        pickerVC.configure(handler: handler)
        pickerVC.modalPresentationStyle = .popover
        pickerVC.popoverPresentationController?.sourceView = self.TextTintColorButton
        pickerVC.popoverPresentationController?.delegate = self
        
        present(pickerVC, animated: true)
    }
    /// iPhone 에서 popover 형식으로 띄우기 위한 로직
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
