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
    private var pageIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configurePageViewController()
        self.configureChildViewControllers()
    }
    
}

extension LogVC {
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
    
}

extension LogVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        self.pageIndex -= 1
        return self.childVCs[self.pageIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        self.pageIndex += 1
        return self.childVCs[self.pageIndex]
    }
}
