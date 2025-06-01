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
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        let homeVC = UINavigationController(rootViewController: HomeViewController()).then {
            $0.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        }
        let settingsVC = UINavigationController(rootViewController: SettingsViewController()).then {
            $0.tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape.fill"))
        }
        // 필요시 추가 탭
        viewControllers = [homeVC, settingsVC]
        tabBar.isTranslucent = false
    }
}

// MARK: - 샘플 뷰컨트롤러 (실제 구현에 맞게 교체)
class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let label = UILabel().then {
            $0.text = "홈 화면"
            $0.font = .boldSystemFont(ofSize: 24)
            $0.textAlignment = .center
        }
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

class SettingsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let label = UILabel().then {
            $0.text = "설정 화면"
            $0.font = .boldSystemFont(ofSize: 24)
            $0.textAlignment = .center
        }
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
