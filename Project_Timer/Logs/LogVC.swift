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
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.updateTabbarColor(backgroundColor: TiTiColor.tabbarBackground, tintColor: .label, normalColor: .lightGray)
        // test code
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let activityViewController = UIActivityViewController(activityItems: [path], applicationActivities: nil)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.popoverPresentationController?.sourceRect = pageSegmentedControl.frame
        }
        
        self.present(activityViewController, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.updateTabbarColor(backgroundColor: TiTiColor.tabbarBackground, tintColor: .label, normalColor: .lightGray)
    }
    
    @IBAction func changePage(_ sender: UISegmentedControl) {
        self.changeVC(oldValue: self.currentPage, newValue: sender.selectedSegmentIndex)
    }
}

extension LogVC {
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
              let dailysVC = self.storyboard?.instantiateViewController(withIdentifier: DailysVC.identifier) as? DailysVC,
              let weeksVC = self.storyboard?.instantiateViewController(withIdentifier: WeeksVC.identifier) else { return }
        dailysVC.configureDelegate(to: self)
        
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

extension LogVC: ModifyRecordDelegate {
    func showModifyRecordVC(daily: Daily, isReverseColor: Bool) {
        print(daily.day.YYYYMMDDstyleString)
        guard let modifyRecordVC = self.storyboard?.instantiateViewController(withIdentifier: ModifyRecordVC.identifier) as? ModifyRecordVC else { return }
        modifyRecordVC.configureViewModel(daily: daily, isReverseColor: isReverseColor)
        self.navigationController?.pushViewController(modifyRecordVC, animated: true)
    }
    
    func showCreateRecordVC(date: Date, isReverseColor: Bool) {
        print(date.YYYYMMDDHMSstyleString)
        guard let modifyRecordVC = self.storyboard?.instantiateViewController(withIdentifier: ModifyRecordVC.identifier) as? ModifyRecordVC else { return }
        modifyRecordVC.configureViewModel(date: date, isReverseColor: isReverseColor)
        self.navigationController?.pushViewController(modifyRecordVC, animated: true)
    }
}
