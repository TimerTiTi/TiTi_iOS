//
//  LogVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/07/24.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class LogVC: UIViewController {
    static let changePageIndex = Notification.Name("changePageIndex")
    @IBOutlet weak var pageSegmentedControl: UISegmentedControl!
    @IBOutlet weak var frameView: UIView!
    private lazy var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        return pageViewController
    }()
    private var childVCs: [UIViewController] = []
    private var currentPage: Int = 0 {
        didSet {
            self.pageSegmentedControl.selectedSegmentIndex = self.currentPage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureObservation()
        self.configurePageViewController()
        self.configureChildViewControllers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateTabbarColor()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.updateTabbarColor()
    }
    
    @IBAction func changePage(_ sender: UISegmentedControl) {
        self.changeVC(oldValue: self.currentPage, newValue: sender.selectedSegmentIndex)
    }
}

extension LogVC {
    private func updateTabbarColor() {
        if #available(iOS 15.0, *){
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = TiTiColor.tabbarBackground
            
            appearance.compactInlineLayoutAppearance.normal.iconColor = .lightGray
            appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor : UIColor.lightGray]
            
            appearance.inlineLayoutAppearance.normal.iconColor = .lightGray
            appearance.inlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor : UIColor.lightGray]
            
            appearance.stackedLayoutAppearance.normal.iconColor = .lightGray
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor : UIColor.lightGray]
            
            self.tabBarController?.tabBar.standardAppearance = appearance
            self.tabBarController?.tabBar.scrollEdgeAppearance = appearance
            self.tabBarController?.tabBar.tintColor = .label
            
        } else {
            self.tabBarController?.tabBar.tintColor = .label
            self.tabBarController?.tabBar.unselectedItemTintColor = .lightGray
            self.tabBarController?.tabBar.barTintColor = TiTiColor.tabbarBackground
        }
    }
    
    private func configureObservation() {
        NotificationCenter.default.addObserver(forName: LogVC.changePageIndex, object: nil, queue: .main) { [weak self] noti in
            if let pageIndex = noti.userInfo?["pageIndex"] as? Int {
                self?.currentPage = pageIndex
            }
        }
    }
    
    private func configurePageViewController() {
        self.frameView.addSubview(self.pageViewController.view)
        self.addChild(self.pageViewController)
        self.pageViewController.didMove(toParent: self)
        
        self.pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.pageViewController.view.leadingAnchor.constraint(equalTo: self.frameView.leadingAnchor),
            self.pageViewController.view.topAnchor.constraint(equalTo: self.frameView.topAnchor),
            self.pageViewController.view.trailingAnchor.constraint(equalTo: self.frameView.trailingAnchor),
            self.pageViewController.view.bottomAnchor.constraint(equalTo: self.frameView.bottomAnchor)
        ])
        
        self.pageViewController.dataSource = self
    }
    
    private func configureChildViewControllers() {
        guard let logHomeVC = self.storyboard?.instantiateViewController(withIdentifier: LogHomeVC.identifier),
              let dailysVC = self.storyboard?.instantiateViewController(withIdentifier: DailysVC.identifier),
              let weeksVC = self.storyboard?.instantiateViewController(withIdentifier: WeeksVC.identifier) else { return }
        self.childVCs = [logHomeVC, dailysVC, weeksVC]
        self.pageViewController.setViewControllers([logHomeVC], direction: .forward, animated: true)
    }
    
    private func changeVC(oldValue: Int, newValue: Int) {
        self.currentPage = newValue
        let direction: UIPageViewController.NavigationDirection = oldValue <= newValue ? .forward : .reverse
        self.pageViewController.setViewControllers([self.childVCs[self.currentPage]], direction: direction, animated: true)
    }
}

extension LogVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = self.childVCs.firstIndex(of: viewController), index-1 >= 0 else { return nil }
        return self.childVCs[index-1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = self.childVCs.firstIndex(of: viewController), index+1 < self.childVCs.count else { return nil }
        return self.childVCs[index+1]
    }
}
