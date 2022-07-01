//
//  StopwatchViewController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/04/30.
//  Copyright © 2021 FDEE. All rights reserved.
//

import UIKit
import Combine
import SwiftUI

final class StopwatchViewController: UIViewController {
    static let identifier = "StopwatchViewController"

    @IBOutlet var taskButton: UIButton!
    @IBOutlet var innerProgress: CircularProgressView!
    @IBOutlet var outterProgress: CircularProgressView!
    
    @IBOutlet var sumTimeLabel: UILabel!
    @IBOutlet var TIMEofSumFrameView: UIView!
    @IBOutlet var stopWatchLabel: UILabel!
    @IBOutlet var TIMEofStopwatchFrameView: UIView!
    @IBOutlet var targetTimeLabel: UILabel!
    @IBOutlet var TIMEofTargetFrameView: UIView!
    @IBOutlet var finishTimeLabel: UILabel!
    
    @IBOutlet var startStopBT: UIButton!
    @IBOutlet var startStopBTLabel: UILabel!
    @IBOutlet var resetBT: UIButton!
    @IBOutlet var settingBT: UIButton!
    @IBOutlet weak var colorSelector: UIButton!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var warningRecordDate: UIButton!
    
    var COLOR = TiTiColor.background2
    let RED = TiTiColor.text
    let INNER = TiTiColor.innerColor
    let startButtonColor = TiTiColor.startButton
    private var cancellables: Set<AnyCancellable> = []
    private var viewModel: StopwatchVM?
    
    var progressPer: Float = 0.0
    var innerProgressPer: Float = 0.0
    let progressPeriod: Int = 3600
    var isLandscape: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureLocalizable()
        self.configureColor()
        self.configureShadow()
        self.configureProgress()
        self.configureObservation()
        self.setStopColor()
        self.setButtonsEnabledTrue()
        self.configureViewModel()
        self.configureTimeOfStopwatch()
        self.configureTimeOfSum()
        self.configureTimeOfTarget()
        self.bindAll()
        self.viewModel?.updateTask()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateTabbarColor()
        self.viewModel?.updateTask()
        self.viewModel?.updateModeNum()
        self.viewModel?.updateTimes()
        self.viewModel?.updateDaily()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.updateTabbarColor()
    }
    
    @IBAction func taskSelect(_ sender: Any) {
        self.showTaskSelectVC()
    }
    
    @IBAction func timerStartStopAction(_ sender: Any) {
        guard self.viewModel?.task ?? "none" != "none" else {
            self.showTaskWarningAlert()
            return
        }
        self.viewModel?.timerAction()
    }
    
    @IBAction func setting(_ sender: Any) {
        self.showSettingView()
    }
    
    @IBAction func reset(_ sender: Any) {
        self.viewModel?.stopwatchReset()
    }
    
    @IBAction func colorSelect(_ sender: Any) {
        self.showColorSelectVC()
    }
    
    @IBAction func showRecordDateAlert(_ sender: Any) {
        self.showRecordDateWarning(title: "Check the date of recording".localized(), text: "Do you want to start the New record?".localized()) { [weak self] in
            self?.showSettingView()
        }
    }
}

// MARK: - Configure
extension StopwatchViewController {
    private func updateTabbarColor() {
        self.tabBarController?.tabBar.tintColor = .white
        self.tabBarController?.tabBar.unselectedItemTintColor = TiTiColor.tabbarNonSelect
        self.tabBarController?.tabBar.barTintColor = .clear
    }
    
    private func configureLocalizable() {
        self.sumTimeLabel.text = "Sum Time".localized()
        self.stopWatchLabel.text = "Stopwatch".localized()
        self.targetTimeLabel.text = "Target Time".localized()
    }
    private func configureColor() {
        guard let color = UserDefaults.standard.colorForKey(key: "color") else { return }
        self.COLOR = color
        self.view.backgroundColor = self.COLOR
    }
    private func configureShadow() {
        self.resetBT.configureShadow(opacity: 0.5, radius: 4)
        self.settingBT.configureShadow(opacity: 0.5, radius: 4)
        self.TIMEofSumFrameView.configureShadow(opacity: 0.6, radius: 2)
        self.TIMEofStopwatchFrameView.configureShadow(opacity: 0.6, radius: 2)
        self.TIMEofTargetFrameView.configureShadow(opacity: 0.6, radius: 2)
    }
    private func configureProgress() {
        self.outterProgress.progressWidth = 20.0
        self.outterProgress.trackColor = UIColor.darkGray
        self.innerProgress.progressWidth = 8.0
        self.innerProgress.trackColor = UIColor.clear
    }
    private func configureObservation() {
        NotificationCenter.default.addObserver(self, selector: #selector(pauseWhenBackground(noti:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(noti:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(forName: .removeNewRecordWarning, object: nil, queue: .main) { [weak self] _ in
            self?.hideWarningRecordDate()
        }
    }
    private func configureViewModel() {
        self.viewModel = StopwatchVM()
    }
    private func configureTimeOfStopwatch() {
        guard let timeOfStopwatchViewModel = self.viewModel?.timeOfStopwatchViewModel else { return }
        
        let hostingController = UIHostingController(rootView: TimeOfStopwatchView(viewModel: timeOfStopwatchViewModel))
        hostingController.view.translatesAutoresizingMaskIntoConstraints = true
        hostingController.view.backgroundColor = .clear
        hostingController.view.frame = TIMEofStopwatchFrameView.bounds
        
        addChild(hostingController)
        TIMEofStopwatchFrameView.addSubview(hostingController.view)
    }
    private func configureTimeOfSum() {
        guard let timeOfSumViewModel = self.viewModel?.timeOfSumViewModel else { return }
        
        let hostingController = UIHostingController(rootView: TimeLabelView(viewModel: timeOfSumViewModel).foregroundColor(.white))
        hostingController.view.translatesAutoresizingMaskIntoConstraints = true
        hostingController.view.backgroundColor = .clear
        hostingController.view.frame = TIMEofSumFrameView.bounds
        
        addChild(hostingController)
        TIMEofSumFrameView.addSubview(hostingController.view)
    }
    private func configureTimeOfTarget() {
        guard let timeOfTargetViewModel = self.viewModel?.timeOfTargetViewModel else { return }
        
        let hostingController = UIHostingController(rootView: TimeLabelView(viewModel: timeOfTargetViewModel).foregroundColor(.white))
        hostingController.view.translatesAutoresizingMaskIntoConstraints = true
        hostingController.view.backgroundColor = .clear
        hostingController.view.frame = TIMEofTargetFrameView.bounds
        
        addChild(hostingController)
        TIMEofTargetFrameView.addSubview(hostingController.view)
    }
}

// MARK: - IBAction
extension StopwatchViewController {
    private func showTaskSelectVC() {
        guard let setVC = storyboard?.instantiateViewController(withIdentifier: taskSelectViewController.identifier) as? taskSelectViewController else { return }
        setVC.delegate = self
        present(setVC, animated: true, completion: nil)
    }
    
    private func showSettingView() {
        guard let setVC = storyboard?.instantiateViewController(withIdentifier: SetTimerViewController2.identifier) as? SetTimerViewController2 else { return }
        setVC.delegate = self
        present(setVC, animated: true, completion: nil)
    }
    
    private func showColorSelectVC() {
        if #available(iOS 14.0, *) {
            let picker = UIColorPickerViewController()
            picker.selectedColor = COLOR!
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        } else {
            self.showAlertWithOK(title: "iOS 14.0 이상 기능", text: "업데이트 후 사용해주시기 바랍니다.")
        }
    }
}

// MARK: - binding
extension StopwatchViewController {
    private func bindAll() {
        self.bindTimes()
        self.bindDaily()
        self.bindTask()
        self.bindUI()
        self.bindWaringNewDate()
    }
    private func bindTimes() {
        self.viewModel?.$times
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] times in
                self?.updateTIMELabels(times: times)
                self?.updateEndTime(goalTime: times.goal)
                self?.updateProgress(times: times)
//                self?.printTimes(with: times)
            })
            .store(in: &self.cancellables)
    }
    private func bindDaily() {
        self.viewModel?.$daily
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] daily in
                self?.updateToday(to: daily.day)
            })
            .store(in: &self.cancellables)
    }
    private func bindTask() {
        self.viewModel?.$task
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] task in
                self?.updateTask(to: task)
            })
            .store(in: &self.cancellables)
    }
    private func bindUI() {
        self.viewModel?.$runningUI
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] runningUI in
                if runningUI {
                    NotificationCenter.default.post(name: .removeNewRecordWarning, object: nil)
                    self?.setStartColor()
                    self?.setButtonsEnabledFalse()
                } else {
                    self?.setStopColor()
                    self?.setButtonsEnabledTrue()
                }
            })
            .store(in: &self.cancellables)
    }
    private func bindWaringNewDate() {
        self.viewModel?.$warningNewDate
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] warning in
                guard warning else { return }
                self?.showWarningRecordDate()
            })
            .store(in: &self.cancellables)
    }
}

// MARK: - logic
extension StopwatchViewController {
    private func updateTask(to task: String) {
        if task == "none" {
            self.taskButton.setTitle("Enter a new subject".localized(), for: .normal)
            self.setTaskWarningColor()
        } else {
            self.taskButton.setTitle(task, for: .normal)
            if self.viewModel?.runningUI == false {
                self.setTaskWhiteColor()
            }
        }
    }
    
    private func setTaskWarningColor() {
        self.taskButton.setTitleColor(TiTiColor.lightPink, for: .normal)
        self.taskButton.layer.borderColor = TiTiColor.lightPink?.cgColor
    }
    
    private func setTaskWhiteColor() {
        self.taskButton.setTitleColor(UIColor.white, for: .normal)
        self.taskButton.layer.borderColor = UIColor.white.cgColor
    }
    
    private func updateTIMELabels(times: Times) {
//        self.TIMEofSum.text = times.sum.toTimeString
//        self.TIMEofStopwatch.text = times.stopwatch.toTimeString
//        self.TIMEofTarget.text = times.goal.toTimeString
    }
    
    private func updateEndTime(goalTime: Int) {
        let endAt = Date().addingTimeInterval(TimeInterval(goalTime))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "hh:mm a"
        let endTime = dateFormatter.string(from: endAt)
        self.finishTimeLabel.text = "To " + endTime
    }
    
    private func updateToday(to date: Date) {
        self.todayLabel.text = date.YYYYMMDDstyleString
    }
    
    private func setStartColor() {
        self.view.backgroundColor = UIColor.black
        outterProgress.progressColor = COLOR!
        innerProgress.progressColor = UIColor.white
        startStopBT.backgroundColor = UIColor.clear
//        TIMEofStopwatch.textColor = COLOR
        //예상종료시간 숨기기, stop 버튼 센터로 이동
        UIView.animate(withDuration: 0.3, animations: {
            self.settingBT.alpha = 0
            self.taskButton.layer.borderColor = UIColor.clear.cgColor
            self.startStopBTLabel.textColor = self.RED!
            self.resetBT.alpha = 0
            self.startStopBT.layer.borderColor = UIColor.clear.cgColor
            self.startStopBTLabel.text = "◼︎"
            self.colorSelector.alpha = 0
            self.tabBarController?.tabBar.isHidden = true
            self.todayLabel.alpha = 0
        })
    }
    
    private func setButtonsEnabledFalse() {
        self.settingBT.isUserInteractionEnabled = false
        self.taskButton.isUserInteractionEnabled = false
        self.resetBT.isUserInteractionEnabled = false
    }
    
    private func setStopColor() {
        self.view.backgroundColor = COLOR
        outterProgress.progressColor = UIColor.white
        innerProgress.progressColor = INNER!
        startStopBT.backgroundColor = startButtonColor!
//        TIMEofStopwatch.textColor = UIColor.white
        //예상종료시간 보이기, stop 버튼 제자리로 이동
        UIView.animate(withDuration: 0.3, animations: {
            self.settingBT.alpha = 1
            self.taskButton.layer.borderColor = UIColor.white.cgColor
            self.startStopBTLabel.textColor = UIColor.white
            self.resetBT.alpha = 1
            self.startStopBT.layer.borderColor = self.startButtonColor?.cgColor
            self.startStopBTLabel.text = "▶︎"
            self.colorSelector.alpha = 0.7
            self.tabBarController?.tabBar.isHidden = false
        })
        //animation test
        if(!self.isLandscape) {
            UIView.animate(withDuration: 0.5, animations: {
                self.taskButton.alpha = 1
                self.todayLabel.alpha = 1
            })
        }
    }
    
    private func setButtonsEnabledTrue() {
        self.settingBT.isUserInteractionEnabled = true
        self.taskButton.isUserInteractionEnabled = true
        self.resetBT.isUserInteractionEnabled = true
    }
    
    private func updateProgress(times: Times) {
        let goalPeriod = self.viewModel?.settedGoalTime ?? 21600
        
        let newProgressPer = Float(times.stopwatch % self.progressPeriod) / Float(self.progressPeriod)
        self.outterProgress.setProgress(duration: 1.0, value: newProgressPer, from: self.progressPer)
        self.progressPer = newProgressPer
        
        let newInnerProgressPer = Float(times.sum) / Float(goalPeriod)
        self.innerProgress.setProgress(duration: 1.0, value: newInnerProgressPer, from: self.innerProgressPer)
        self.innerProgressPer = newInnerProgressPer
    }
    
    private func printTimes(with times: Times) {
        print("sum: \(times.sum.toTimeString)")
        print("stopwatch: \(times.stopwatch.toTimeString)")
        print("goal: \(times.goal.toTimeString)")
    }
    
    private func showWarningRecordDate() {
        UIView.animate(withDuration: 0.15) {
            self.warningRecordDate.alpha = 1
            self.todayLabel.textColor = self.RED!
        }
    }
    
    private func hideWarningRecordDate() {
        UIView.animate(withDuration: 0.15) {
            self.warningRecordDate.alpha = 0
            self.todayLabel.textColor = .white
        }
    }
}

// MARK: - Rotation
extension StopwatchViewController {
    @objc func deviceRotated() {
        guard UIDevice.current.userInterfaceIdiom == .phone else { return }
        if UIDevice.current.orientation.isLandscape {
            self.setLandscape()
        } else {
            self.setPortrait()
        }
    }
    
    private func setLandscape() {
        if self.viewModel?.runningUI ?? false == false {
            UIView.animate(withDuration: 0.3) {
                self.taskButton.alpha = 0
                self.todayLabel.alpha = 0
            }
        }
        self.isLandscape = true
    }
    
    private func setPortrait() {
        if self.viewModel?.runningUI ?? false == false {
            UIView.animate(withDuration: 0.3) {
                self.taskButton.alpha = 1
                self.todayLabel.alpha = 1
            }
        }
        self.isLandscape = false
    }
}

// MARK: Background
extension StopwatchViewController {
    @objc func pauseWhenBackground(noti: Notification) {
        guard let running = self.viewModel?.runningUI,
              running == true else { return }
        self.viewModel?.enterBackground()
    }
    
    @objc func willEnterForeground(noti: Notification) {
        guard let running = self.viewModel?.runningUI,
              running == true else { return }
        self.viewModel?.enterForground()
    }
}

extension StopwatchViewController: NewRecordCreatable {
    func newRecord() {
        self.configureColor()
        self.viewModel?.newRecord()
        NotificationCenter.default.post(name: .removeNewRecordWarning, object: nil)
    }
}

extension StopwatchViewController: TaskChangeable {
    func selectTask(to task: String) {
        self.viewModel?.changeTask(to: task)
    }
}

extension StopwatchViewController {
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
}

extension StopwatchViewController: UIColorPickerViewControllerDelegate {
    @available(iOS 14.0, *)
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        self.changeColor(color: viewController.selectedColor)
    }
    
    @available(iOS 14.0, *)
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        self.changeColor(color: viewController.selectedColor)
    }
    
    private func changeColor(color: UIColor) {
        UserDefaults.standard.setColor(color: color, forKey: "color")
        self.COLOR = color
        self.view.backgroundColor = self.COLOR
    }
}
