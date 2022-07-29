//
//  LogVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/07/24.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class LogVC: UIViewController {
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
            let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ? .forward : .reverse
            self.pageViewController.setViewControllers([self.childVCs[self.currentPage]], direction: direction, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        if self.currentPage != sender.selectedSegmentIndex {
            self.currentPage = sender.selectedSegmentIndex
        }
    }
}

extension LogVC {
    private func updateTabbarColor() {
        self.tabBarController?.tabBar.tintColor = .label
        self.tabBarController?.tabBar.unselectedItemTintColor = .lightGray
        self.tabBarController?.tabBar.barTintColor = TiTiColor.tabbarBackground
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
        
        self.pageViewController.delegate = self
        self.pageViewController.dataSource = self
    }
    
    private func configureChildViewControllers() {
        guard let logHomeVC = self.storyboard?.instantiateViewController(withIdentifier: LogHomeVC.identifier),
              let dailysVC = self.storyboard?.instantiateViewController(withIdentifier: DailysVC.identifier) else { return }
        self.childVCs = [logHomeVC, dailysVC]
        self.pageViewController.setViewControllers([logHomeVC], direction: .forward, animated: true)
    }
}

extension LogVC: UIPageViewControllerDelegate {
    /// 제스처가 완료된 후 호출
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?[0],
              let index = self.childVCs.firstIndex(of: viewController) else { return }
        if self.currentPage != index {
            self.currentPage = index
        }
        self.pageSegmentedControl.selectedSegmentIndex = index
    }
}

extension LogVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = self.childVCs.firstIndex(of: viewController), index-1 >= 0 else { return nil }
        self.currentPage = index-1
        return self.childVCs[index-1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = self.childVCs.firstIndex(of: viewController), index+1 < self.childVCs.count else { return nil }
        self.currentPage = index+1
        return self.childVCs[index+1]
    }
}
