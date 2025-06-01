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
import SnapKit
import Then
import RxSwift
import RxCocoa

final class LogHomeVC: UIViewController {
    static let identifier = "LogHomeVC"
    private var scrollView: UIScrollView!
    // contentViews
    private var contentView: UIView!
    private var monthNavigationLayer: UIView!
    private var previousMonthButton: UIButton!
    private var currentMonthLabel: UILabel!
    private var nextMonthButton: UIButton!
    private var stackView: UIStackView!
    private var totalView: UIView!
    private var monthSmallView: UIView!
    private var weekSmallView: UIView!
    private var monthView: UIView!
    private var weekView: UIView!
    private var dailyView: UIView!
    // layers
    private var totalLayer: UIStackView!
    private var monthWeekLayer: UIStackView!
    private var monthLayer: UIStackView!
    private var weekLayer: UIStackView!
    private var dailyLayer: UIStackView!
    
    private var viewModel: LogHomeVM?
    private var cancellables: Set<AnyCancellable> = []
    private var colors: [UIColor] = []
    private var progressWidth: CGFloat = 0
    private var progressHeight: CGFloat = 0

    private let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindActions()
        self.bindStatuses()
        self.configureViewModel()
        self.configureTotal()
        self.configureMonthSmall()
        self.configureWeekSmall()
        self.configureMonth()
        self.configureWeek()
        self.configureDaily()
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
    private func configureUI() {
        scrollView = UIScrollView().then {
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        contentView = UIView().then {
            scrollView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.width.equalToSuperview()
            }
        }
        
        monthNavigationLayer = UIView().then { monthNavigationLayer in
            contentView.addSubview(monthNavigationLayer)
            monthNavigationLayer.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(8)
                make.centerX.equalToSuperview()
                make.height.equalTo(30)
            }
            
            previousMonthButton = UIButton(type: .system).then {
                $0.setTitle("<", for: .normal)
                $0.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
                $0.setTitleColor(UIColor.gray, for: .normal)
                monthNavigationLayer.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.leading.equalToSuperview()
                    make.centerY.equalToSuperview()
                }
            }
            
            currentMonthLabel = UILabel().then {
                $0.text = "YYYY.MM"
                $0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
                $0.textColor = UIColor.darkGray
                monthNavigationLayer.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.leading.equalTo(previousMonthButton.snp.trailing).offset(15)
                    make.centerY.equalToSuperview()
                }
            }
            
            nextMonthButton = UIButton(type: .system).then {
                $0.setTitle(">", for: .normal)
                $0.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
                $0.setTitleColor(UIColor.gray, for: .normal)
                monthNavigationLayer.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.leading.equalTo(currentMonthLabel.snp.trailing).offset(15)
                    make.trailing.equalToSuperview()
                    make.centerY.equalToSuperview()
                }
            }
        }
        
        stackView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 17
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(monthNavigationLayer.snp.bottom).offset(10)
                make.bottom.equalToSuperview().inset(8)
                make.centerX.equalToSuperview()
            }
        }
        
        totalLayer = UIStackView().then { totalLayer in
            totalLayer.axis = .vertical
            totalLayer.spacing = 8
            totalLayer.alignment = .center
            stackView.addArrangedSubview(totalLayer)
            
            totalView = UIView().then {
                $0.backgroundColor = .secondarySystemBackground
                $0.layer.cornerRadius = 25
                totalLayer.addArrangedSubview($0)
                $0.snp.makeConstraints { make in
                    make.width.equalTo(339)
                    make.height.equalTo(158)
                }
            }
            
            _ = UILabel().then {
                $0.text = "Total"
                $0.font = Fonts.HGGGothicssiP60g(size: 12)
                $0.textAlignment = .center
                totalLayer.addArrangedSubview($0)
            }
        }
        
        monthWeekLayer = UIStackView().then { monthWeekLayer in
            monthWeekLayer.axis = .horizontal
            monthWeekLayer.spacing = 23
            stackView.addArrangedSubview(monthWeekLayer)
            
            // Month
            _ = UIStackView().then { monthSmallLayer in
                monthSmallLayer.axis = .vertical
                monthSmallLayer.spacing = 8
                monthSmallLayer.alignment = .center
                monthWeekLayer.addArrangedSubview(monthSmallLayer)
                
                monthSmallView = UIView().then {
                    $0.backgroundColor = .secondarySystemBackground
                    $0.layer.cornerRadius = 25
                    monthSmallLayer.addArrangedSubview($0)
                    $0.snp.makeConstraints { make in
                        make.width.equalTo(158)
                        make.height.equalTo(158)
                    }
                }
                
                _ = UILabel().then {
                    $0.text = "Month"
                    $0.font = Fonts.HGGGothicssiP60g(size: 12)
                    $0.textAlignment = .center
                    monthSmallLayer.addArrangedSubview($0)
                }
            }
            
            // Week
            _ = UIStackView().then { weekSmallLayer in
                weekSmallLayer.axis = .vertical
                weekSmallLayer.spacing = 8
                weekSmallLayer.alignment = .center
                monthWeekLayer.addArrangedSubview(weekSmallLayer)
                
                weekSmallView = UIView().then {
                    $0.backgroundColor = .secondarySystemBackground
                    $0.layer.cornerRadius = 25
                    weekSmallLayer.addArrangedSubview($0)
                    $0.snp.makeConstraints { make in
                        make.width.equalTo(158)
                        make.height.equalTo(158)
                    }
                }
                
                _ = UILabel().then {
                    $0.text = "Week"
                    $0.font = Fonts.HGGGothicssiP60g(size: 12)
                    $0.textAlignment = .center
                    weekSmallLayer.addArrangedSubview($0)
                }
            }
        }
        
        monthLayer = UIStackView().then { monthLayer in
            monthLayer.axis = .vertical
            monthLayer.spacing = 8
            monthLayer.alignment = .center
            stackView.addArrangedSubview(monthLayer)
            
            monthView = UIView().then {
                $0.backgroundColor = .secondarySystemBackground
                $0.layer.cornerRadius = 25
                monthLayer.addArrangedSubview($0)
                $0.snp.makeConstraints { make in
                    make.width.equalTo(339)
                    make.height.equalTo(158)
                }
            }
            
            _ = UILabel().then {
                $0.text = "Month"
                $0.font = Fonts.HGGGothicssiP60g(size: 12)
                $0.textAlignment = .center
                monthLayer.addArrangedSubview($0)
            }
        }
        
        weekLayer = UIStackView().then { weekLayer in
            weekLayer.axis = .vertical
            weekLayer.spacing = 8
            weekLayer.alignment = .center
            stackView.addArrangedSubview(weekLayer)
            
            weekView = UIView().then {
                $0.backgroundColor = .secondarySystemBackground
                $0.layer.cornerRadius = 25
                weekLayer.addArrangedSubview($0)
                $0.snp.makeConstraints { make in
                    make.width.equalTo(339)
                    make.height.equalTo(158)
                }
            }
            
            _ = UILabel().then {
                $0.text = "Week"
                $0.font = Fonts.HGGGothicssiP60g(size: 12)
                $0.textAlignment = .center
                weekLayer.addArrangedSubview($0)
            }
        }
        
        dailyLayer = UIStackView().then { dailyLayer in
            dailyLayer.axis = .vertical
            dailyLayer.spacing = 8
            dailyLayer.alignment = .center
            stackView.addArrangedSubview(dailyLayer)
            
            dailyView = UIView().then {
                $0.backgroundColor = .secondarySystemBackground
                $0.layer.cornerRadius = 25
                dailyLayer.addArrangedSubview($0)
                $0.snp.makeConstraints { make in
                    make.width.equalTo(339)
                    make.height.equalTo(158)
                }
            }
            
            _ = UILabel().then {
                $0.text = "Daily"
                $0.font = Fonts.HGGGothicssiP60g(size: 12)
                $0.textAlignment = .center
                dailyLayer.addArrangedSubview($0)
            }
        }
    }
    
    private func configureBiggerUI() {
        guard UIDevice.current.userInterfaceIdiom == .pad else { return }
        #if targetEnvironment(macCatalyst)
        let height: CGFloat = self.contentView.bounds.height
        let scale: CGFloat = 1.25
        let inset = 8 + ((scale-1)/2*height)
        
        stackView.snp.updateConstraints { make in
            make.verticalEdges.equalToSuperview().inset(inset)
        }
        
        contentView.transform = CGAffineTransform(scaleX: scale, y: scale)
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
    private func bindActions() {
        previousMonthButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                self?.viewModel?.goToPreviousMonth()
            }
            .disposed(by: disposeBag)
            
        nextMonthButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance) 
            .bind { [weak self] in
                self?.viewModel?.goToNextMonth()
            }
            .disposed(by: disposeBag)
    }

    private func bindStatuses() {    
        viewModel?.$daily
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] daily in
                guard let self = self else { return }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YYYY.MM"
                let monthString = dateFormatter.string(from: daily.day.zeroDate.localDate)
                self.currentMonthLabel.text = monthString
            })
            .store(in: &self.cancellables)
    }
}

extension LogHomeVC: Updateable {
    func update() {
        self.viewModel?.loadDaily()
        self.viewModel?.updateDailys()
    }
}
