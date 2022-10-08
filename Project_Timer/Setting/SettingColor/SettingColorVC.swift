//
//  SettingColorVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/10/08.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class SettingColorVC: UIViewController {
    static let identifier = "SettingColorVC"
    
    @IBOutlet weak var colorOrderingLabel: UILabel!
    @IBOutlet weak var colorOrderingSubLabel: UILabel!
    @IBOutlet weak var themeColorLabel: UILabel!
    @IBOutlet weak var themeColorSubLabel: UILabel!
    @IBOutlet weak var colorDirectionControl: UISegmentedControl!
    @IBOutlet weak var colorSampleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.colorSampleView.layer.cornerCurve = .continuous
        self.configureLocalized()
        self.configureDirection()
        self.updateColor()
    }
    
    @IBAction func switchDirection(_ sender: UISegmentedControl) {
        let isReverseColor = sender.selectedSegmentIndex == 1
        UserDefaultsManager.set(to: isReverseColor, forKey: .reverseColor)
        self.updateColor()
    }
    
    @IBAction func selectColor(_ sender: UIButton) {
        UserDefaultsManager.set(to: sender.tag, forKey: .startColor)
        self.updateColor()
    }
}

extension SettingColorVC {
    private func configureLocalized() {
        self.title = "Theme color".localized()
        self.colorOrderingLabel.text = "Color ordering".localized()
        self.colorOrderingSubLabel.text = "Setting the order of graph's color".localized()
        self.themeColorLabel.text = "Theme color".localized()
        self.themeColorSubLabel.text = "Setting Graph's theme color".localized()
    }
    
    private func configureDirection() {
        self.colorDirectionControl.layer.cornerRadius = 32
        let isReverseColor = UserDefaultsManager.get(forKey: .reverseColor) as? Bool ?? false
        self.colorDirectionControl.selectedSegmentIndex = isReverseColor ? 1 : 0
    }
    
    private func updateColor() {
        let startColorNum = UserDefaultsManager.get(forKey: .startColor) as? Int ?? 1
        let themeColor = UIColor(named: "D\(startColorNum)") ?? .blue
        self.colorDirectionControl.selectedSegmentTintColor = themeColor
        
        let isReverseColor = UserDefaultsManager.get(forKey: .reverseColor) as? Bool ?? false
        var secondColorNum = isReverseColor ? (startColorNum+12-1)%12 : (startColorNum+1)%12
        if secondColorNum == 0 { secondColorNum = 12 }
        let secondColor = UIColor(named: "D\(secondColorNum)") ?? .green
        self.setGradient(view: self.colorSampleView, color1: themeColor, color2: secondColor)
    }
    
    private func setGradient(view: UIView, color1: UIColor, color2: UIColor) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
    }
}
