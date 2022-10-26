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
    @IBOutlet weak var colorSelectorBorderView: UIImageView!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var warningRecordDate: UIButton!
    
    private lazy var blackView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .black
        return view
    }()
    
    private var backgroundColor = TiTiColor.background2
    private var textColor = UIColor.white
    private var secondTextColor = UIColor.black.withAlphaComponent(0.7)
    let RED = TiTiColor.text
    let INNER = TiTiColor.innerColor
    let startButtonColor = TiTiColor.startButton
    private var cancellables: Set<AnyCancellable> = []
    private var viewModel: StopwatchVM?
    
    var progressPer: Float = 0.0
    var innerProgressPer: Float = 0.0
    let progressPeriod: Int = 3600
    var isLandscape: Bool = false
    private var isScreenDim: Bool = false
    
    override var prefersStatusBarHidden: Bool {
        return self.isScreenDim
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureLocalizable()
        self.configureRendering()
        self.configureShadow()
        self.configureProgress()
        self.configureObservation()
        self.setButtonsEnabledTrue()
        self.configureViewModel()
        self.fetchColor()
        self.configureTimeOfStopwatch()
        self.configureTimeOfSum()
        self.configureTimeOfTarget()
        self.bindAll()
        self.viewModel?.updateTask()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.updateTabbarColor(backgroundColor: .clear, tintColor: self.textColor, normalColor: TiTiColor.tabbarNonSelect!)
        self.viewModel?.updateTask()
        self.viewModel?.updateModeNum()
        self.viewModel?.updateTimes()
        self.viewModel?.updateDaily()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.startMotionDetection()
        self.configureApplicationActiveStateObserver()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopMotionDetection()
        self.removeApplicationActiveStateObserver()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tabBarController?.updateTabbarColor(backgroundColor: .clear, tintColor: self.textColor, normalColor: TiTiColor.tabbarNonSelect!)
    }
    
    @IBAction func taskSelect(_ sender: Any) {
        self.showTaskSelectVC()
    }
    
    @IBAction func timerStartStopAction(_ sender: Any) {
        self.startOrStopTimer()
    }
    
    @IBAction func setting(_ sender: Any) {
        self.showSettingView()
    }
    
    @IBAction func reset(_ sender: Any) {
        self.viewModel?.stopwatchReset()
    }
    
    @IBAction func colorSelect(_ sender: Any) {
        self.showColorSelector()
    }
    
    @IBAction func showRecordDateAlert(_ sender: Any) {
        self.showRecordDateWarning(title: "Check the date of recording".localized(), text: "Do you want to start the New record?".localized()) { [weak self] in
            self?.showSettingView()
        }
    }
}

// MARK: - Configure
extension StopwatchViewController {
    private func configureLocalizable() {
        self.sumTimeLabel.text = "Sum Time".localized()
        self.stopWatchLabel.text = "Stopwatch".localized()
        self.targetTimeLabel.text = "Target Time".localized()
    }
    private func configureRendering() {
        self.settingBT.setImage(UIImage.init(systemName: "calendar.badge.plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.resetBT.setImage(UIImage.init(systemName: "clock.arrow.2.circlepath")?.withRenderingMode(.alwaysTemplate), for: .normal)
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
    private func configureTimeOfSum() {
        guard let timeOfSumViewModel = self.viewModel?.timeOfSumViewModel else { return }
        
        let hostingController = UIHostingController(rootView: NormalTimeLabelView(viewModel: timeOfSumViewModel))
        hostingController.view.translatesAutoresizingMaskIntoConstraints = true
        hostingController.view.backgroundColor = .clear
        hostingController.view.frame = TIMEofSumFrameView.bounds
        
        addChild(hostingController)
        TIMEofSumFrameView.addSubview(hostingController.view)
    }
    private func configureTimeOfStopwatch() {
        guard let timeOfStopwatchViewModel = self.viewModel?.timeOfStopwatchViewModel else { return }
        
        let hostingController = UIHostingController(rootView: StopwatchTimeLabelView(viewModel: timeOfStopwatchViewModel))
        hostingController.view.translatesAutoresizingMaskIntoConstraints = true
        hostingController.view.backgroundColor = .clear
        hostingController.view.frame = TIMEofStopwatchFrameView.bounds
        
        addChild(hostingController)
        TIMEofStopwatchFrameView.addSubview(hostingController.view)
    }
    private func configureTimeOfTarget() {
        guard let timeOfTargetViewModel = self.viewModel?.timeOfTargetViewModel else { return }
        
        let hostingController = UIHostingController(rootView: CountdownTimeLabelView(viewModel: timeOfTargetViewModel).foregroundColor(.white))
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
    
    private func startOrStopTimer() {
        guard self.viewModel?.taskName ?? "none" != "none" else {
            self.showTaskWarningAlert()
            return
        }
        self.viewModel?.timerAction()
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
                self?.updateEndTime(goalTime: RecordController.shared.isTaskGargetOn ? times.remainingTaskTime : times.goal)
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
        self.viewModel?.$taskName
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
                    self?.disableIdleTimer()
                } else {
                    self?.setStopColor()
                    self?.setButtonsEnabledTrue()
                    self?.enableIdleTimer()
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
            self.taskButton.setTitle("Create a new task".localized(), for: .normal)
            self.setTaskWarningColor()
        } else {
            self.taskButton.setTitle(task, for: .normal)
            if self.viewModel?.runningUI == false {
                self.setTaskWhiteColor()
            }
        }
    }
    
    private func setTaskWarningColor() {
        self.taskButton.setTitleColor(TiTiColor.lightpink, for: .normal)
        self.taskButton.layer.borderColor = TiTiColor.lightpink?.cgColor
    }
    
    private func setTaskWhiteColor() {
        self.taskButton.setTitleColor(self.textColor, for: .normal)
        self.taskButton.layer.borderColor = self.textColor.cgColor
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
        self.view.backgroundColor = .black
        self.outterProgress.progressColor = self.backgroundColor!
        self.innerProgress.progressColor = .white
        self.startStopBT.backgroundColor = .clear
        self.taskButton.setTitleColor(.white, for: .normal)
        self.sumTimeLabel.textColor = .white
        self.stopWatchLabel.textColor = .white
        self.targetTimeLabel.textColor = .white
        self.finishTimeLabel.textColor = .white
        self.colorSelector.backgroundColor = .black
        //예상종료시간 숨기기, stop 버튼 센터로 이동
        UIView.animate(withDuration: 0.3, animations: {
            self.settingBT.alpha = 0
            self.resetBT.alpha = 0
            self.taskButton.layer.borderColor = UIColor.clear.cgColor
            self.startStopBTLabel.textColor = self.RED!
            self.startStopBT.layer.borderColor = UIColor.clear.cgColor
            self.startStopBTLabel.text = "◼︎"
            self.colorSelectorBorderView.alpha = 0
            self.tabBarController?.tabBar.isHidden = true
            self.todayLabel.alpha = 0
        })
    }
    
    private func setButtonsEnabledFalse() {
        self.settingBT.isUserInteractionEnabled = false
        self.taskButton.isUserInteractionEnabled = false
        self.resetBT.isUserInteractionEnabled = false
        self.colorSelector.isUserInteractionEnabled = false
    }
    
    private func setStopColor() {
        self.view.backgroundColor = self.backgroundColor
        self.outterProgress.progressColor = self.textColor
        self.innerProgress.progressColor = self.secondTextColor
        self.startStopBT.backgroundColor = self.startButtonColor!
        self.taskButton.setTitleColor(self.textColor, for: .normal)
        self.sumTimeLabel.textColor = self.textColor
        self.stopWatchLabel.textColor = self.textColor
        self.targetTimeLabel.textColor = self.textColor
        self.finishTimeLabel.textColor = self.textColor
        self.settingBT.tintColor = self.textColor
        self.resetBT.tintColor = self.textColor
        self.colorSelector.backgroundColor = self.backgroundColor
        //예상종료시간 보이기, stop 버튼 제자리로 이동
        UIView.animate(withDuration: 0.3, animations: {
            self.settingBT.alpha = 1
            self.resetBT.alpha = 1
            self.taskButton.layer.borderColor = self.textColor.cgColor
            self.startStopBTLabel.textColor = self.textColor
            self.startStopBT.layer.borderColor = self.startButtonColor?.cgColor
            self.startStopBTLabel.text = "▶︎"
            self.colorSelectorBorderView.alpha = 1
            self.tabBarController?.tabBar.isHidden = false
        })
        //animation test
        if(!self.isLandscape) {
            UIView.animate(withDuration: 0.5, animations: {
                self.taskButton.alpha = 1
                self.todayLabel.textColor = self.textColor
                self.todayLabel.alpha = 1
            })
        }
    }
    
    private func setButtonsEnabledTrue() {
        self.settingBT.isUserInteractionEnabled = true
        self.taskButton.isUserInteractionEnabled = true
        self.resetBT.isUserInteractionEnabled = true
        self.colorSelector.isUserInteractionEnabled = true
    }
    
    private func updateProgress(times: Times) {
        let goalPeriod: Int
        let innerSum: Int
        if RecordController.shared.isTaskGargetOn {
            goalPeriod = RecordController.shared.currentTask?.taskTargetTime ?? 3600
            innerSum = goalPeriod - times.remainingTaskTime
            self.targetTimeLabel.text = "Task Target Time".localized()
        } else {
            goalPeriod = self.viewModel?.settedGoalTime ?? 21600
            innerSum = times.sum
            self.targetTimeLabel.text = "Target Time".localized()
        }
        
        let newProgressPer = Float(times.stopwatch % self.progressPeriod) / Float(self.progressPeriod)
        self.outterProgress.setProgress(duration: 1.0, value: newProgressPer, from: self.progressPer)
        self.progressPer = newProgressPer
        
        let newInnerProgressPer = Float(innerSum) / Float(goalPeriod)
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
            self.todayLabel.textColor = self.textColor
        }
    }
    
    private func disableIdleTimer() {
        let keepTheScreenOn = UserDefaultsManager.get(forKey: .keepTheScreenOn) as? Bool ?? true
        if keepTheScreenOn {
            UIApplication.shared.isIdleTimerDisabled = true
        }
    }
    
    private func enableIdleTimer() {
        UIApplication.shared.isIdleTimerDisabled = false
    }
}

// MARK: - Rotation
extension StopwatchViewController {
    @objc func deviceRotated() {
        guard UIDevice.current.userInterfaceIdiom == .phone else { return }
        self.blackView.frame = UIScreen.main.bounds
        switch UIDevice.current.orientation {
        case .portrait, .portraitUpsideDown:
            self.setPortrait()
        case .landscapeLeft, .landscapeRight:
            self.setLandscape()
        default:
            return
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

// MARK: - Device Motion Detection
extension StopwatchViewController {
    /// viewDidAppear 시점에 noti 수신 설정
    private func configureApplicationActiveStateObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(stopMotionDetection), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startMotionDetection), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    /// viewDidDisappear 시점에 noti 수신 해제
    private func removeApplicationActiveStateObserver() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    /// didAppear, active 상태일 경우 실시간으로 감지를 시작하기 위한 함수
    @objc private func startMotionDetection() {
        guard MotionDetector.shared.isDetecting == false,
              UserDefaultsManager.get(forKey: .flipToStartRecording) as? Bool ?? true else { return }
        
        print("start motion detection")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(orientationDidChangeToFaceDown),
                                               name: MotionDetector.orientationDidChangeToFaceDownNotification,
                                               object: MotionDetector.shared)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(orientationDidChangeToFaceUp),
                                               name: MotionDetector.orientationDidChangeToFaceUpNotification,
                                               object: MotionDetector.shared)
        MotionDetector.shared.beginGeneratingMotionNotification()
    }
    /// inactive, didDisappear 상태가 될 경우 감지 해제
    @objc private func stopMotionDetection() {
        guard MotionDetector.shared.isDetecting == true else { return }
        
        print("stop motion detection")
        MotionDetector.shared.stopGeneratingMotionNotification()
        NotificationCenter.default.removeObserver(self,
                                                  name: MotionDetector.orientationDidChangeToFaceDownNotification,
                                                  object: MotionDetector.shared)
        NotificationCenter.default.removeObserver(self,
                                                  name: MotionDetector.orientationDidChangeToFaceUpNotification,
                                                  object: MotionDetector.shared)
    }
    
    private func dimTheScreen() {
        guard isScreenDim == false,
              let keyWindow = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }
        
        self.isScreenDim = true
        self.setNeedsStatusBarAppearanceUpdate()
        keyWindow.addSubview(self.blackView)
        UIDevice.current.isProximityMonitoringEnabled = true
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    private func brightenTheScreen() {
        guard isScreenDim == true else { return }
        
        self.isScreenDim = false
        self.setNeedsStatusBarAppearanceUpdate()
        self.blackView.removeFromSuperview()
        UIDevice.current.isProximityMonitoringEnabled = false
        UIApplication.shared.isIdleTimerDisabled = false
    }
    /// FaceDown noti 를 받아 동작제어 로직 실행
    @objc func orientationDidChangeToFaceDown() {
        print("Device Face Down")
        DispatchQueue.main.async { [weak self] in
            guard let viewModel = self?.viewModel else { return }
            
            if viewModel.runningUI == false {
                self?.startOrStopTimer()
                guard viewModel.runningUI == true else { return }
                self?.viewModel?.sendRecordingStartNotification()
            }
            self?.dimTheScreen()
            self?.enterBackground()
        }
    }
    /// FaceUp noti 를 받아 foreground 로직 실행
    @objc func orientationDidChangeToFaceUp() {
        print("Device Face Up")
        DispatchQueue.main.async { [weak self] in
            self?.enterForeground()
            self?.brightenTheScreen()
        }
    }
}

// MARK: Background
extension StopwatchViewController {
    private func enterBackground() {
        guard let running = self.viewModel?.runningUI,
              running == true else { return }
        self.viewModel?.enterBackground()
    }
    
    private func enterForeground() {
        guard let running = self.viewModel?.runningUI,
              running == true else { return }
        self.viewModel?.enterForground()
    }
    
    @objc func pauseWhenBackground(noti: Notification) {
        self.enterBackground()
    }
    
    @objc func willEnterForeground(noti: Notification) {
        self.enterForeground()
    }
}

extension StopwatchViewController: NewRecordCreatable {
    func newRecord() {
        self.fetchColor()
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

extension StopwatchViewController: ColorUpdateable {
    private func showColorSelector() {
        guard let colorSelector = storyboard?.instantiateViewController(withIdentifier: ColorSelectorVC.identifier) as? ColorSelectorVC else { return }
        colorSelector.configure(target: .stopwatcch, delegate: self)
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.setValue(colorSelector, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func fetchColor() {
        if let color = UserDefaults.standard.colorForKey(key: .stopwatchBackground) {
            self.backgroundColor = color
        } else if let color = UserDefaults.standard.colorForKey(key: .color) {
            self.backgroundColor = color
        }
        let isWhite = UserDefaultsManager.get(forKey: .stopwatchTextIsWhite) as? Bool ?? true
        self.textColor = isWhite ? .white : .black.withAlphaComponent(0.55)
        self.secondTextColor = isWhite ? .black.withAlphaComponent(0.6) : .white.withAlphaComponent(0.7)
        self.setStopColor()
        self.viewModel?.updateTextColor(isWhite: isWhite)
        self.view.layoutSubviews()
        self.tabBarController?.updateTabbarColor(backgroundColor: .clear, tintColor: self.textColor, normalColor: TiTiColor.tabbarNonSelect!)
    }
}
