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
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var monthSmallView: UIView!
    @IBOutlet weak var weekSmallView: UIView!
    @IBOutlet weak var weekView: UIView!
    @IBOutlet weak var dailyView: UIView!
    // layers
    @IBOutlet weak var totalLayer: UIStackView!
    @IBOutlet weak var monthWeekLayer: UIStackView!
    @IBOutlet weak var weekLayer: UIStackView!
    @IBOutlet weak var dailyLayer: UIStackView!
    
    private var viewModel: LogHomeVM?
    private var cancellables: Set<AnyCancellable> = []
    private var colors: [UIColor] = []
    private var progressWidth: CGFloat = 0
    private var progressHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewModel()
        self.configureMonthSmall()
        self.bindAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: LogVC.changePageIndex, object: nil, userInfo: ["pageIndex" : 0])
        self.showMonthTime()
        self.configureWeeksGraph()
        self.viewModel?.loadDaily()
        self.viewModel?.updateDailys()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.configureShadows(self.totalView, self.monthSmallView, self.weekSmallView, self.weekView, self.dailyView)
        self.viewModel?.updateColor()
//        self.configureWeeksGraph()
//
//        guard let subjectTimes = self.viewModel?.subjectTimes,
//              self.colors.isEmpty == false else { return }
//        let sumTime = subjectTimes.reduce(0, +)
//        self.configureTodaysTime(sumTime)
//        self.makeProgress(subjectTimes, sumTime)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
    
    private func configureMonthSmall() {
        guard let monthSmallVM = self.viewModel?.monthSmallVM else { return }
        let hostingVC = UIHostingController(rootView: MonthSmallView(viewModel: monthSmallVM))
        self.addChild(hostingVC)
        hostingVC.didMove(toParent: self)
        
        self.addHostingVC(frameView: self.monthSmallView, view: hostingVC.view)
    }
    
    private func addHostingVC(frameView: UIView, view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = CGFloat(25)
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

// MARK: ShowGraph
extension LogHomeVC {
    private func configureWeeksGraph() {
//        let hostingController = UIHostingController(rootView: ContentView())
//        hostingController.view.translatesAutoresizingMaskIntoConstraints = true
//        hostingController.view.frame = self.graphViewOfWeeks.bounds
//
//        self.addChild(hostingController)
//        self.graphViewOfWeeks.addSubview(hostingController.view)
    }
    
    private func showMonthTime() {
//        DispatchQueue.global().async {
//            RecordController.shared.dailys.totalStudyTimeOfMonth { totalTime in
//                DispatchQueue.main.async {
//                    self.monthTimeLabel.text = totalTime.toTimeString
//                }
//            }
//        }
    }
    
    private func showStatistics() {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: DailysVC.identifier) else { return }
        viewController.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
        viewController.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
        self.present(viewController, animated: true, completion: nil)
    }
}

// MARK: Binding
extension LogHomeVC {
    private func bindAll() {
        self.bindDaily()
        self.bindSubjectTimes()
        self.bindSubjectNameTimes()
    }
    
    private func bindDaily() {
        self.viewModel?.$daily
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] daily in
                guard daily.tasks != [:] else {
                    print("no data error")
                    return
                }
                self?.configureTodayDateLabel(daily: daily)
                self?.configureTimesticksGraph(daily: daily)
            })
            .store(in: &self.cancellables)
    }
    
    private func bindSubjectTimes() {
        self.viewModel?.$subjectTimes
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] subjectTimes in
                let sumTime = subjectTimes.reduce(0, +)
                self?.configureTodaysTime(sumTime)
                self?.makeProgress(subjectTimes, sumTime)
            })
            .store(in: &self.cancellables)
    }
    
    private func bindSubjectNameTimes() {
        self.viewModel?.$subjectNameTimes
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] subjects in
                guard subjects.isEmpty == false else { return }
                let count = subjects.count
                self?.configureColors(count: count)
                self?.setHeight(count: count)
//                self?.subjects.reloadData()
            })
            .store(in: &self.cancellables)
    }
}

extension LogHomeVC {
    private func configureTodayDateLabel(daily: Daily) {
//        self.todayDateLabel.text = daily.day.MDstyleString
    }
    
    private func configureTimesticksGraph(daily: Daily) {
//        for i in 0..<24 {
//            self.fillColor(time: daily.timeline[i], view: self.timeSticks[i] as UIView)
//        }
    }
    
    private func fillColor(time: Int, view: UIView) {
        if time == 0 {
            view.backgroundColor = UIColor(named: "Empty")
            view.alpha = 1.0
            return
        }
        view.backgroundColor = UIColor(named: "D2")
        if(time < 600) { //0 ~ 10
            view.alpha = 0.2
        } else if(time < 1200) { //10 ~ 20
            view.alpha = 0.35
        } else if(time < 1800) { //20 ~ 30
            view.alpha = 0.5
        } else if(time < 2400) { //30 ~ 40
            view.alpha = 0.65
        } else if(time < 3000) { //40 ~ 50
            view.alpha = 0.8
        } else { //50 ~ 60
            view.alpha = 1.0
        }
    }
    
    private func configureColors(count: Int) {
        self.colors = []
        var i = count % 12 == 0 ? 12 : count % 12
        
        for _ in 1...count {
            self.colors.append(UIColor(named: "D\(i)")!)
            i = i-1 == 0 ? 12 : i-1
        }
    }
    
    private func setHeight(count: Int) {
//        self.subjectsHeight.constant = CGFloat(20*min(8, count))
    }
    
    private func configureTodaysTime(_ time: Int) {
//        self.todaySumtimeLabel.text = time.toTimeString
    }
}

extension LogHomeVC {
    private func makeProgress(_ subjectTimes: [Int], _ sumTime: Int) {
//        self.configureEmptyView()
//        var sumWithSeperator: Float = Float(sumTime)
//
//        //그래프 간 구별선 추가
//        sumWithSeperator += Float(0.003)*Float(subjectTimes.count)
//        var progressPosition: Float = 1
//
//        progressPosition -= self.addBlock(value: progressPosition)
//        for i in 0..<subjectTimes.count {
//            let prog = StaticCircularProgressView(frame: CGRect(x: 0, y: 0, width: self.progressWidth, height: self.progressHeight))
//            prog.trackColor = UIColor.clear
//            prog.progressColor = self.colors[i % self.colors.count]
//            prog.setProgressWithAnimation(duration: 1, value: progressPosition, from: 0)
//            self.todayProgressView.addSubview(prog)
//
//            progressPosition -= Float(subjectTimes[i])/Float(sumWithSeperator)
//            if i != subjectTimes.count-1 {
//                progressPosition -= self.addBlock(value: progressPosition)
//            }
//        }
    }
    
    private func configureEmptyView() {
//        for view in self.todayProgressView.subviews {
//            view.removeFromSuperview()
//        }
    }
    
    private func addBlock(value: Float) -> Float {
//        let block = StaticCircularProgressView(frame: CGRect(x: 0, y: 0, width: self.progressWidth, height: self.progressHeight))
//        block.trackColor = UIColor.clear
//        block.progressColor = UIColor.systemBackground
//        block.setProgressWithAnimation(duration: 1, value: value, from: 0)
//        self.todayProgressView.addSubview(block)
//
        return Float(0.003)
    }
}

extension LogHomeVC: UICollectionViewDataSource {
    //몇개 표시 할까?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.subjectNameTimes.count ?? 0
    }
    //셀 어떻게 표시 할까?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubjectCell.identifier, for: indexPath) as? SubjectCell else {
            return UICollectionViewCell()
        }
        guard let count = self.viewModel?.subjectNameTimes.count else { return cell }
        guard let nameAndTime = self.viewModel?.subjectNameTimes[count - indexPath.item - 1] else { return cell }
        guard self.colors.isEmpty == false else { return cell }
        
        let color = self.colors[count - indexPath.item - 1]
        cell.configure(color: color, nameAndTime: nameAndTime)
        
        return cell
    }
}
