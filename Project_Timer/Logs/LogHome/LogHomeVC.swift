//
//  LogHomeVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/02/23.
//  Copyright © 2021 FDEE. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

final class LogHomeVC: UIViewController {
    static let identifier = "LogHomeVC"
    // contentViews
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var monthSmallView: UIView!
    @IBOutlet weak var weekSmallView: UIView!
    @IBOutlet weak var monthView: UIView!
    @IBOutlet weak var weekView: UIView!
    @IBOutlet weak var dailyView: UIView!
    // layers
    @IBOutlet weak var totalLayer: UIStackView!
    @IBOutlet weak var monthWeekLayer: UIStackView!
    @IBOutlet weak var monthLayer: UIStackView!
    @IBOutlet weak var weekLayer: UIStackView!
    @IBOutlet weak var dailyLayer: UIStackView!
    
    private var viewModel: LogHomeVM?
    private var cancellables: Set<AnyCancellable> = []
    private var colors: [UIColor] = []
    private var progressWidth: CGFloat = 0
    private var progressHeight: CGFloat = 0
    
    @IBOutlet var stackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var stackViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewModel()
        self.configureTotal()
        self.configureMonthSmall()
        self.configureWeekSmall()
        self.configureMonth()
        self.configureWeek()
        self.configureDaily()
        self.bindAll()
        self.configureBiggerUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: LogVC.changePageIndex, object: nil, userInfo: ["pageIndex" : 0])
        self.viewModel?.loadDaily()
        self.viewModel?.updateDailys()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.configureShadows(self.totalView, self.monthSmallView, self.weekSmallView, self.monthView, self.weekView, self.dailyView)
        self.viewModel?.updateColor()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

// MARK: Device UI Configure
extension LogHomeVC {
    private func configureBiggerUI() {
        guard UIDevice.current.userInterfaceIdiom == .pad else { return }
        #if targetEnvironment(macCatalyst)
        let height: CGFloat = self.contentView.bounds.height
        let scale: CGFloat = 1.25
        self.stackViewTopConstraint.constant = 8+((scale-1)/2*height)
        self.stackViewBottomConstraint.constant = 8+((scale-1)/2*height)
        self.contentView.transform = CGAffineTransform.init(scaleX: scale, y: scale)
        #endif
    }
}

// MARK: Configure
extension LogHomeVC {
    private func configureShadows(_ views: UIView...) {
        views.forEach { $0.configureShadow() }
    }
    
    private func configureViewModel() {
        self.viewModel = LogHomeVM()
    }
    
    private func configureTotal() {
        guard let totalVM = self.viewModel?.totalVM else { return }
        let hostingVC = UIHostingController(rootView: TotalView(viewModel: totalVM))
        self.addChild(hostingVC)
        hostingVC.didMove(toParent: self)
        
        self.addHostingVC(frameView: self.totalView, view: hostingVC.view)
    }
    
    private func configureMonthSmall() {
        guard let monthSmallVM = self.viewModel?.monthSmallVM else { return }
        let hostingVC = UIHostingController(rootView: MonthSmallView(viewModel: monthSmallVM))
        self.addChild(hostingVC)
        hostingVC.didMove(toParent: self)
        
        self.addHostingVC(frameView: self.monthSmallView, view: hostingVC.view)
    }
    
    private func configureWeekSmall() {
        guard let weekSmallVM = self.viewModel?.weekSmallVM else { return }
        let hostingVC = UIHostingController(rootView: WeekSmallView(viewModel: weekSmallVM))
        self.addChild(hostingVC)
        hostingVC.didMove(toParent: self)
        
        self.addHostingVC(frameView: self.weekSmallView, view: hostingVC.view)
    }
    
    private func configureMonth() {
        guard let monthVM = self.viewModel?.monthVM else { return }
        let hostingVC = UIHostingController(rootView: MonthView(viewModel: monthVM))
        self.addChild(hostingVC)
        hostingVC.didMove(toParent: self)
        
        self.addHostingVC(frameView: self.monthView, view: hostingVC.view)
    }
    
    private func configureWeek() {
        guard let weekVM = self.viewModel?.weekVM else { return }
        let hostingVC = UIHostingController(rootView: WeekView(viewModel: weekVM))
        self.addChild(hostingVC)
        hostingVC.didMove(toParent: self)
        
        self.addHostingVC(frameView: self.weekView, view: hostingVC.view)
    }
    
    private func configureDaily() {
        guard let dailyVM = self.viewModel?.dailyVM else { return }
        let hostingVC = UIHostingController(rootView: DailyView(viewModel: dailyVM))
        self.addChild(hostingVC)
        hostingVC.didMove(toParent: self)
        
        self.addHostingVC(frameView: self.dailyView, view: hostingVC.view)
    }
    
    private func addHostingVC(frameView: UIView, view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = CGFloat(25)
        view.clipsToBounds = true
        view.backgroundColor = UIColor(named: "Background_second")
        frameView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: frameView.topAnchor),
            view.leadingAnchor.constraint(equalTo: frameView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: frameView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: frameView.bottomAnchor),
        ])
    }
}

// MARK: Binding
extension LogHomeVC {
    private func bindAll() {
        self.bindDaily()
    }
    
    private func bindDaily() {
        self.viewModel?.$daily
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { daily in
                guard daily.tasks != [:] else {
                    print("no data error")
                    return
                }
                print("selected daily: \(daily.day.zeroDate.localDate.YYYYMMDDstyleString)")
            })
            .store(in: &self.cancellables)
    }
}

extension LogHomeVC: LogUpdateable {
    func update() {
        self.viewModel?.loadDaily()
        self.viewModel?.updateDailys()
    }
}
