//
//  UITextField+Extension.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/10/01.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit

extension UITextField {
    /// placeholder 컬러 설정 (placeholder가 설정된 이후 호출)
    /// https://cozzin.tistory.com/27
    func setPlaceholderColor(_ placeholderColor: UIColor) {
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [
                .foregroundColor: placeholderColor,
                .font: font
            ].compactMapValues { $0 }
        )
    }
}
