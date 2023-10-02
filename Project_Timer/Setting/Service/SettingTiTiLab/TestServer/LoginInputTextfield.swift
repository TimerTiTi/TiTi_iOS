//
//  LoginInputTextfield.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/09/27.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit

class LoginInputTextfield: UIView {
    static let height: CGFloat = CGFloat(58)
    
    enum type: String {
        case nickname = "nickname"
        case email = "email"
        case password = "password"
    }
    
    var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 16, weight: .bold)
        textField.textColor = .black
        textField.placeholder = "placeholder"
        textField.setPlaceholderColor(TiTiColor.placeholderGray!)
        textField.enablesReturnKeyAutomatically = true
        textField.returnKeyType = .done
        return textField
    }()
    var origin: CGPoint {
        return self.frame.origin + self.textField.frame.origin
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(type: LoginInputTextfield.type) {
        self.init(frame: .zero)
        self.textField.placeholder = type.rawValue.localized()
        
        self.configureUI()
    }
    
    private func configureUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
        self.layer.cornerCurve = .continuous
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: Self.height)
        ])
        
        self.addSubview(self.textField)
        NSLayoutConstraint.activate([
            self.textField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
}
