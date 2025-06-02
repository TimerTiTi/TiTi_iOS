//
//  MainTabBarController.swift
//  Project_Timer
//
//  Created by Minsang on 6/2/25.
//  Copyright © 2025 FDEE. All rights reserved.
//

import UIKit
import SnapKit
import Then

final class MainTabBarController: UITabBarController {
    enum TabBarItem: Int {
        case timer
        case stopwatch
        case todolist
        case log
        case setting
        
        var title: String {
            switch self {
            case .timer:
                return "Timer"
            case .stopwatch:
                return "Stopwatch"
            case .todolist:
                return "Todo"
            case .log:
                return "Log"
            case .setting:
                return "Setting"
            }
        }
        
        var image: UIImage? {
            switch self {
            case .timer:
                return UIImage(systemName: "timer")
            case .stopwatch:
                return UIImage(systemName: "stopwatch")
            case .todolist:
                return UIImage(systemName: "checklist")
            case .log:
                return UIImage(systemName: "chart.bar")
            case .setting:
                return UIImage(systemName: "gearshape")
            }
        }
        
        var selectedImage: UIImage? {
            switch self {
            case .timer:
                return UIImage(systemName: "timer")
            case .stopwatch:
                return UIImage(systemName: "stopwatch")
            case .todolist:
                return UIImage(systemName: "checklist")
            case .log:
                return UIImage(systemName: "chart.bar")
            case .setting:
                return UIImage(systemName: "gearshape")
            }
        }
        
        var viewController: UIViewController? {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            switch self {
            case .timer:
                return storyboard.instantiateViewController(withIdentifier: TimerVC.identifier) as? TimerVC
            case .stopwatch:
                return storyboard.instantiateViewController(withIdentifier: StopwatchVC.identifier) as? StopwatchVC
            case .todolist:
                return storyboard.instantiateViewController(withIdentifier: TodolistVC.identifier) as? TodolistVC
            case .log:
                return storyboard.instantiateViewController(withIdentifier: LogVC.identifier) as? LogVC
            case .setting:
                return storyboard.instantiateViewController(withIdentifier: SettingVC.identifier) as? SettingVC
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        let tabBarItems: [TabBarItem] = [.timer, .stopwatch, .todolist, .log, .setting]
        var viewControllers: [UIViewController] = []
        
        tabBarItems.forEach { item in
            switch item {
            case .timer, .stopwatch, .todolist:
                if let vc = item.viewController {
                    vc.tabBarItem = UITabBarItem(title: item.title, image: item.image, selectedImage: item.selectedImage)
                    viewControllers.append(vc)
                }
            case .log:
                if let vc = item.viewController {
                    let nav = UINavigationController(rootViewController: vc)
                    nav.tabBarItem = UITabBarItem(title: item.title, image: item.image, selectedImage: item.selectedImage)
                    viewControllers.append(nav)
                }
            case .setting:
                if let vc = item.viewController {
                    let nav = UINavigationController(rootViewController: vc)
                    nav.navigationBar.prefersLargeTitles = true
                    nav.tabBarItem = UITabBarItem(title: item.title, image: item.image, selectedImage: item.selectedImage)
                    viewControllers.append(nav)
                }
            }
        }
        
        // 필요시 추가 탭
        self.viewControllers = viewControllers
        self.tabBar.isTranslucent = true
    }
}

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
