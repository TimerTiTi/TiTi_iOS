//
//  UIApplication+Extension.swift
//  Project_Timer
//
//  Created by Ryeong on 10/10/24.
//  Copyright © 2024 FDEE. All rights reserved.
//

import UIKit

extension UIApplication {
    
    var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first
    }
    
    var safeAreaTopInset: CGFloat {
        return keyWindow?.safeAreaInsets.top ?? 0
    }
}
