//
//  UITabBarController+Extension.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/08/05.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

extension UITabBarController {
    func updateTabbarColor(backgroundColor: UIColor?, tintColor: UIColor, normalColor: UIColor) {
        if #available(iOS 15.0, *){
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = backgroundColor
            appearance.shadowColor = .clear
            
            appearance.compactInlineLayoutAppearance.normal.iconColor = normalColor
            appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor : normalColor]
            
            appearance.inlineLayoutAppearance.normal.iconColor = normalColor
            appearance.inlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor : normalColor]
            
            appearance.stackedLayoutAppearance.normal.iconColor = normalColor
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor : normalColor]
            
            self.tabBar.standardAppearance = appearance
            self.tabBar.scrollEdgeAppearance = appearance
            self.tabBar.tintColor = tintColor
            
        } else {
            self.tabBar.tintColor = tintColor
            self.tabBar.unselectedItemTintColor = normalColor
            self.tabBar.barTintColor = backgroundColor
        }
    }
}
