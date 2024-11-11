//
//  UIApplication+Extension.swift
//  Project_Timer
//
//  Created by Ryeong on 10/10/24.
//  Copyright © 2024 FDEE. All rights reserved.
//

import UIKit

extension UIApplication {
    
    var firstWindow: UIWindow? {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        return windowScene?.windows.first
    }
    
    var safeAreaTopInset: CGFloat {
        return firstWindow?.safeAreaInsets.top ?? 0
    }
}
