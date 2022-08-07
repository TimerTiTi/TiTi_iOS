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
            let tabBarItemAppearance = UITabBarItemAppearance()
            if UIDevice.current.userInterfaceIdiom == .pad {
                tabBarItemAppearance.normal.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 13), .foregroundColor: normalColor]
                tabBarItemAppearance.selected.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 13), .foregroundColor: tintColor]
            } else {
                tabBarItemAppearance.normal.titleTextAttributes = [.foregroundColor: normalColor]
                tabBarItemAppearance.selected.titleTextAttributes = [.foregroundColor: tintColor]
            }
            
            tabBarItemAppearance.normal.iconColor = normalColor
            tabBarItemAppearance.selected.iconColor = tintColor
            
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = backgroundColor
            appearance.shadowColor = .clear
            
            appearance.compactInlineLayoutAppearance = tabBarItemAppearance
            appearance.inlineLayoutAppearance = tabBarItemAppearance
            appearance.stackedLayoutAppearance = tabBarItemAppearance
            
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
