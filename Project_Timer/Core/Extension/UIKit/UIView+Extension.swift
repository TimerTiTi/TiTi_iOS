//
//  UIView+Extension.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/03/12.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

/// tapGesture 클로저들을 담은 딕셔너리가 저장되는 고유 식별 키 (Associated Object의 메모리 주소 역할)
private var TapGestureDictKey: UInt8 = 0

extension UIView {
    @IBInspectable
    public var cornerRadius: CGFloat
    {
        set (radius) {
            self.layer.cornerRadius = radius
        }

        get {
            return self.layer.cornerRadius
        }
    }

    @IBInspectable
    public var borderWidth: CGFloat
    {
        set (borderWidth) {
            self.layer.borderWidth = borderWidth
        }

        get {
            return self.layer.borderWidth
        }
    }

    @IBInspectable
    public var borderColor:UIColor?
    {
        set (color) {
            self.layer.borderColor = color?.cgColor
        }

        get {
            if let color = self.layer.borderColor
            {
                return UIColor(cgColor: color)
            } else {
                return nil
            }
        }
    }
    
    func configureShadow() {
        self.layer.shadowColor = Colors.shadow?.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 5
    }
    
    func configureShadow(opacity: Float, radius: CGFloat) {
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = radius
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }) { _ in
            self.isHidden = true
        }
    }
    
    func fadeIn() {
        self.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
    
    func tapGesture(identifier: String = UUID().uuidString, _ tapAction: @escaping () -> Void) {
        isUserInteractionEnabled = true
        
        // 현재 뷰(self)에 연결된 클로저 딕셔너리를 가져오거나 새로 생성
        var actions = objc_getAssociatedObject(self, &TapGestureDictKey) as? [String: () -> Void] ?? [:]
        actions[identifier] = tapAction
        
        // TapGestureDictKey의 주소를 포인터 키로 사용해 갱신된 딕셔너리를 Associated Object에 저장
        objc_setAssociatedObject(self, &TapGestureDictKey, actions, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        // 단일 제스처만 추가 (여러 번 등록되지 않도록)
        if !(gestureRecognizers?.contains(where: { $0 is UITapGestureRecognizer }) ?? false) {
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
            addGestureRecognizer(tap)
        }
    }
    
    @objc private func handleTapGesture() {
        // 저장된 모든 클로저를 순차적으로 실행
        if let actions = objc_getAssociatedObject(self, &TapGestureDictKey) as? [String: () -> Void] {
            for (_, action) in actions {
                action()
            }
        }
    }
}
