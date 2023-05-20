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
    @IBOutlet weak var settingButton: UIButton!
    private lazy var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        return pageViewController
    }()
    private var childVCs: [UIViewController] = []
    private var currentPage: Int = 0 {
        didSet {
            self.pageSegmentedControl.selectedSegmentIndex = self.currentPage
            self.checkSettingButton()
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
        #if targetEnvironment(macCatalyst)
        #else
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        #endif
        self.tabBarController?.updateTabbarColor(backgroundColor: TiTiColor.tabbarBackground, tintColor: .label, normalColor: .lightGray)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        #if targetEnvironment(macCatalyst)
        #else
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        #endif
        self.tabBarController?.updateTabbarColor(backgroundColor: TiTiColor.tabbarBackground, tintColor: .label, normalColor: .lightGray)
    }
    
    @IBAction func changePage(_ sender: UISegmentedControl) {
        self.changeVC(oldValue: self.currentPage, newValue: sender.selectedSegmentIndex)
    }
    
    @IBAction func showSettingBottomSheet(_ sender: Any) {
        let height: CGFloat = self.view.bounds.width <= 375 ? 425 : 500
        let bottomSheetVC = BottomSheetViewController(contentViewController: LogSettingVC(), defaultHeight: height, cornerRadius: 25)
        self.present(bottomSheetVC, animated: false, completion: nil)
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
              let logDailyVC = self.storyboard?.instantiateViewController(withIdentifier: LogDailyVC.identifier) as? LogDailyVC,
              let logWeekVC = self.storyboard?.instantiateViewController(withIdentifier: LogWeekVC.identifier) else { return }
        logDailyVC.configureDelegate(to: self)
        
        self.childVCs = [logHomeVC, logDailyVC, logWeekVC]
        self.pageViewController.setViewControllers([logHomeVC], direction: .forward, animated: true)
    }
    
    private func changeVC(oldValue: Int, newValue: Int) {
        self.currentPage = newValue
        let direction: UIPageViewController.NavigationDirection = oldValue <= newValue ? .forward : .reverse
        self.pageViewController.setViewControllers([self.childVCs[self.currentPage]], direction: direction, animated: true)
    }
    
    private func checkSettingButton() {
        if self.currentPage == 0 {
            self.settingButton.fadeIn()
        } else {
            self.settingButton.fadeOut()
        }
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
