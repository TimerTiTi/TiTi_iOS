//
//  LogVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/07/24.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class LogVC: UIViewController {
    static let changePageIndex = Notification.Name("changePageIndex")
    private var pageSegmentedControl: UISegmentedControl!
    private var settingButton: UIButton!
    private var frameView: UIView!
    private var pageViewController: UIPageViewController!
    private var childVCs: [UIViewController] = []
    private var currentPage: Int = 0 {
        didSet {
            self.pageSegmentedControl.selectedSegmentIndex = self.currentPage
            self.checkSettingButton()
        }
    }
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindAction()
        self.configureObservation()
        self.configureChildViewControllers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        #if targetEnvironment(macCatalyst)
        #else
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        #endif
        self.tabBarController?.updateTabbarColor(backgroundColor: Colors.tabbarBackground, tintColor: .label, normalColor: .lightGray)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        #if targetEnvironment(macCatalyst)
        #else
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        #endif
        self.tabBarController?.updateTabbarColor(backgroundColor: Colors.tabbarBackground, tintColor: .label, normalColor: .lightGray)
    }
}

extension LogVC {
    private func configureUI() {
        pageSegmentedControl = UISegmentedControl(items: ["Home", "Daily", "Week"]).then {
            $0.selectedSegmentIndex = 0
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide)
                make.centerX.equalToSuperview()
            }
        }
        
        settingButton = UIButton(type: .system).then {
            $0.setImage(.init(systemName: "gearshape"), for: .normal)
            $0.tintColor = .label
            $0.imageView?.contentMode = .scaleAspectFit
            $0.contentHorizontalAlignment = .fill
            $0.contentVerticalAlignment = .fill
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerY.equalTo(pageSegmentedControl)
                make.right.equalToSuperview().inset(16)
                make.size.equalTo(28)
            }
        }
        
        frameView = UIView().then {
            $0.backgroundColor = .systemBackground
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(pageSegmentedControl.snp.bottom).offset(8)
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalTo(view.safeAreaLayoutGuide)
            }
        }
        
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal).then {
            frameView.addSubview($0.view)
            addChild($0)
            $0.didMove(toParent: self)
            $0.dataSource = self
            $0.view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
    
    private func bindAction() {
        pageSegmentedControl.rx.selectedSegmentIndex
            .skip(1)
            .subscribe(onNext: { [weak self] newIndex in
                guard let self = self else { return }
                self.changeVC(oldValue: self.currentPage, newValue: newIndex)
            })
            .disposed(by: disposeBag)
        
        settingButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance) // 빠른 중복 탭 방지 (선택)
            .bind { [weak self] in
                guard let self = self else { return }
                guard let logVC = self.childVCs[0] as? LogHomeVC else { return }
                let height: CGFloat = self.view.bounds.width <= 375 ? 425 : 500
                let bottomSheetVC = BottomSheetViewController(contentViewController: LogSettingVC(delegate: logVC), defaultHeight: height, cornerRadius: 25, isPannedable: true)
                self.present(bottomSheetVC, animated: false, completion: nil)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureObservation() {
        NotificationCenter.default.addObserver(forName: LogVC.changePageIndex, object: nil, queue: .main) { [weak self] noti in
            if let pageIndex = noti.userInfo?["pageIndex"] as? Int {
                self?.currentPage = pageIndex
            }
        }
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
