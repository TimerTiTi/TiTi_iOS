//
//  TimerViewController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/04/30.
//  Copyright © 2021 FDEE. All rights reserved.
//

import UIKit
import Combine
import AudioToolbox
import AVFoundation
import SwiftUI

class TimerViewController: UIViewController {
    static let identifier = "TimerViewController"

    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var warningRecordDate: UIButton!
    @IBOutlet weak var colorSelector: UIButton!
    @IBOutlet weak var colorSelectorBorderView: UIImageView!
    @IBOutlet weak var taskButton: UIButton!
    @IBOutlet weak var darkerModeButton: UIButton!
    @IBOutlet weak var useageButton: UIButton!
    
    @IBOutlet weak var innerProgress: CircularProgressView!
    @IBOutlet weak var outterProgress: CircularProgressView!
    @IBOutlet weak var sumTimeLabel: UILabel!
    @IBOutlet weak var TIMEofSumFrameView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var TIMEofTimerFrameView: UIView!
    @IBOutlet weak var targetTimeLabel: UILabel!
    @IBOutlet weak var TIMEofTargetFrameView: UIView!
    @IBOutlet weak var finishTimeLabel: UILabel!
    
    @IBOutlet weak var settingBT: UIButton!
    @IBOutlet weak var startStopBT: UIButton!
    @IBOutlet weak var startStopBTLabel: UILabel!
    @IBOutlet weak var setTimerBT: UIButton!
    
    @IBOutlet var todayTopConstraint: NSLayoutConstraint! // 16
    private var taskBottomConstraint: NSLayoutConstraint? // 50
    private var startStopBTTopConstraint: NSLayoutConstraint? // 50
    private var taskTopConstraint: NSLayoutConstraint?
    private var startStopBTBottomConstraint: NSLayoutConstraint?
    
    private var lastViewSize: CGSize?
    private var isBiggerUI: Bool = false
    
    private lazy var blackView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .black
        return view
    }()
    
    private var backgroundColor = TiTiColor.background
    private var textColor = UIColor.white
    private var secondTextColor = UIColor.black.withAlphaComponent(0.7)
    let RED = TiTiColor.text
    let INNER = TiTiColor.innerColor
    let startButtonColor = TiTiColor.startButton
    private var cancellables: Set<AnyCancellable> = []
    private var viewModel: TimerVM?
    
    var progressPer: Float = 0.0
    var progressPeriod: Int = 0
    var innerProgressPer: Float = 0.0
    var isLandcape: Bool = false
    private var isScreenDim: Bool = false
    private var darkerMode: Bool = false {
        didSet {
            self.view.alpha = darkerMode ? 0.5 : 1
            self.darkerModeButton.isSelected = darkerMode
            self.viewModel?.darkerMode = darkerMode
            self.darkerAnimation = true
            if UIDevice.current.userInterfaceIdiom == .phone {
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    private var darkerAnimation: Bool = false
    
    override var prefersStatusBarHidden: Bool {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return self.darkerMode || self.isScreenDim
        } else {
            return self.isScreenDim
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureLayout()
        self.checkUseage()
        self.configureLocalizable()
        self.configureRendering()
        self.configureShadow()
        self.configureProgress()
        self.configureObservation()
        self.setButtonsEnabledTrue()
        self.configureViewModel()
        self.fetchColor()
        self.configureTimeOfTimer()
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
        self.checkBigUI()
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
        guard UIDevice.current.userInterfaceIdiom == .pad,
              self.lastViewSize != self.view.bounds.size,
              UserDefaultsManager.get(forKey: .bigUI) as? Bool ?? true else { return }
        self.updateProgressSize()
    }

    @IBAction func taskSelect(_ sender: Any) {
        self.showTaskSelectVC()
    }
    
    @IBAction func timerStartStopAction(_ sender: Any) {
        self.startOrStopTimer()
    }
    
    @IBAction func setting(_ sender: Any) {
        self.showSettingTargetTime()
    }
    // MARK: 차기 업데이트시 viewModel?.timerReset 으로 수정 예정
    @IBAction func reset(_ sender: Any) {
        self.showSettingTimerTime()
    }
    
    @IBAction func colorSelect(_ sender: Any) {
        self.showColorSelector()
    }
    
    @IBAction func showRecordDateAlert(_ sender: Any) {
        self.showRecordDateWarning(title: "Check the date of recording".localized(), text: "Do you want to start the New record?".localized()) { [weak self] in
            self?.showSettingTargetTime()
        }
    }
    
    @IBAction func toggleDarker(_ sender: Any) {
        self.darkerMode.toggle()
    }
    
    @IBAction func showUseageAlert(_ sender: Any) {
        let alert = UIAlertController(title: "See how to use the *".localizedForNewFeatures(input: "Timer"), message: "The new * feature added.".localizedForNewFeatures(input: "Sleep Mode"), preferredStyle: .alert)
        let cancle = UIAlertAction(title: "Pass", style: .default, handler: { [weak self] _ in
            self?.showAlertWithOK(title: "You can see anytime in Setting -> TiTi Functions".localized(), text: "")
            UserDefaultsManager.set(to: String.currentVersion, forKey: .timerCheckVer)
            self?.useageButton.isHidden = true
        })
        let ok = UIAlertAction(title: "Show", style: .destructive, handler: { [weak self] _ in
            let url = NetworkURL.Useage.timer
            if let url = URL(string: url) {
                UIApplication.shared.open(url, options: [:])
                UserDefaultsManager.set(to: String.currentVersion, forKey: .timerCheckVer)
                self?.useageButton.isHidden = true
            }
        })
        
        alert.addAction(cancle)
        alert.addAction(ok)
        present(alert,animated: true,completion: nil)
    }
}

// MARK: - Device UI Configure
extension TimerViewController {
    private func configureLayout() {
        self.taskButton.translatesAutoresizingMaskIntoConstraints = false
        self.startStopBT.translatesAutoresizingMaskIntoConstraints = false
        
        let bigUI = UserDefaultsManager.get(forKey: .bigUI) as? Bool ?? true
        if (UIDevice.current.userInterfaceIdiom == .pad && bigUI) {
            self.configurePadLayout()
        } else {
            self.configurePhoneLayout()
        }
    }
    
    private func configurePhoneLayout() {
        self.taskBottomConstraint = self.taskButton.bottomAnchor.constraint(equalTo: self.outterProgress.topAnchor, constant: -50)
        self.taskBottomConstraint?.isActive = true
        
        self.startStopBTTopConstraint = self.startStopBT.topAnchor.constraint(equalTo: self.outterProgress.bottomAnchor, constant: 50)
        self.startStopBTTopConstraint?.isActive = true
        [self.colorSelector, self.colorSelectorBorderView, self.darkerModeButton, self.useageButton].forEach { target in
            target?.transform = CGAffineTransform.identity
        }
        self.isBiggerUI = false
    }
    
    private func configurePadLayout() {
        self.taskBottomConstraint?.isActive = false
        if let taskBottomConstraint = self.taskBottomConstraint {
            self.taskButton.removeConstraint(taskBottomConstraint)
        }
        self.taskTopConstraint = self.taskButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 32)
        self.taskTopConstraint?.isActive = true
        
        self.startStopBTTopConstraint?.isActive = false
        if let startStopBTTopConstraint = self.startStopBTTopConstraint {
            self.startStopBT.removeConstraint(startStopBTTopConstraint)
        }
        self.startStopBTBottomConstraint = self.startStopBT.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -81)
        self.startStopBTBottomConstraint?.isActive = true
        #if targetEnvironment(macCatalyst)
        #else
        [self.colorSelector, self.colorSelectorBorderView, self.darkerModeButton, self.useageButton].forEach { target in
            target?.transform = CGAffineTransform(translationX: 0, y: 29)
        }
        #endif
        self.isBiggerUI = true
    }
    
    /// viewWillAppear 시 setting: bigUI 값 변화 체크 후 반영
    private func checkBigUI() {
        guard UIDevice.current.userInterfaceIdiom == .pad else { return }
        
        let bigUI = UserDefaultsManager.get(forKey: .bigUI) as? Bool ?? true
        if (bigUI == true && isBiggerUI == false) {
            // change to bigUI
            self.updateProgressSize()
        } else if (bigUI == false && isBiggerUI == true) {
            // change to smallUI
            self.minimizeProgress()
        }
    }
    
    /// 화면회전, 화면크기조절시 비율 조정
    private func updateProgressSize() {
        self.lastViewSize = self.view.bounds.size
        #if targetEnvironment(macCatalyst)
        self.updateProgressSizeForMac()
        #else
        self.updateProgressSizeForipad()
        #endif
    }
    
    private func updateProgressSizeForMac() {
        let minWidth: CGFloat = 669
        let minHeight: CGFloat = 800
        let width: CGFloat = self.view.bounds.width
        let height: CGFloat = self.view.bounds.height
        let minLength: CGFloat = max(min(width, height), minHeight)
        let biggerUI = (width >= minWidth && height >= minHeight)
        let multipleScale = 1.55
        
        if (biggerUI) {
            if (isBiggerUI == false) {
                self.configurePadLayout()
            }
            let scale = (minLength/minHeight)*multipleScale
            self.outterProgress.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.setBiggerLandscapeUIforMac(scale: scale)
        } else {
            if (isBiggerUI) {
                self.minimizeProgress()
            }
        }
    }
    
    private func updateProgressSizeForipad() {
        let minWidth: CGFloat = 744
        let minLength: CGFloat = min(self.view.bounds.width, self.view.bounds.height)
        let biggerUI = (minLength >= minWidth)
        let multipleScale = 1.6
        
        if (biggerUI) {
            if (isBiggerUI == false) {
                self.configurePadLayout()
            }
            let scale = (minLength/minWidth)*multipleScale
            self.outterProgress.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.setBiggerLandscapeUIforiPad(scale: minLength/minWidth)
        } else {
            if (isBiggerUI) {
                self.minimizeProgress()
            }
        }
    }
    
    private func minimizeProgress() {
        self.outterProgress.transform = .identity
        self.resetBiggerUI()
        self.setPortrait()
    }
    
    private func setBiggerLandscapeUIforMac(scale: CGFloat) {
        self.taskTopConstraint?.constant = 36*scale
        self.startStopBTBottomConstraint?.constant = -12*scale*2-36
    }
    
    private func setBiggerLandscapeUIforiPad(scale: CGFloat) {
        self.todayTopConstraint.constant = -12
        self.taskTopConstraint?.constant = 24*(scale*1.8-0.8)
        self.startStopBTBottomConstraint?.constant = -68+(scale*35-35)
    }
    
    private func resetBiggerUI() {
        self.todayTopConstraint.constant = 16
        self.taskTopConstraint?.isActive = false
        if let taskTopConstraint = self.taskTopConstraint {
            self.taskButton.removeConstraint(taskTopConstraint)
        }
        
        self.startStopBTBottomConstraint?.isActive = false
        if let startStopBTBottomConstraint = self.startStopBTBottomConstraint {
            self.startStopBT.removeConstraint(startStopBTBottomConstraint)
        }
        
        self.configurePhoneLayout()
    }
}

// MARK: - Configure
extension TimerViewController {
    private func checkUseage() {
        let todolistCheckVer: String = UserDefaultsManager.get(forKey: .timerCheckVer) as? String ?? "7.12"
        let currentVer = String.currentVersion
        if currentVer.compare(todolistCheckVer, options: .numeric) == .orderedDescending {
            self.useageButton.isHidden = false
        }
    }
    private func configureLocalizable() {
        self.sumTimeLabel.text = "Sum Time".localized()
        self.timerLabel.text = "Timer".localized()
        self.targetTimeLabel.text = "Target Time".localized()
    }
    private func configureRendering() {
        self.settingBT.setImage(UIImage.init(systemName: "calendar.badge.plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.setTimerBT.setImage(UIImage.init(systemName: "clock.arrow.circlepath")?.withRenderingMode(.alwaysTemplate), for: .normal)
    }
    private func configureShadow() {
        self.setTimerBT.configureShadow(opacity: 0.5, radius: 4)
        self.settingBT.configureShadow(opacity: 0.5, radius: 4)
        self.TIMEofSumFrameView.configureShadow(opacity: 0.6, radius: 2)
        self.TIMEofTimerFrameView.configureShadow(opacity: 0.6, radius: 2)
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
        self.viewModel = TimerVM()
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
    private func configureTimeOfTimer() {
        guard let timeOfTimerViewModel = self.viewModel?.timeOfTimerViewModel else { return }
        
        let hostingController = UIHostingController(rootView: TimerTimeLabelView(viewModel: timeOfTimerViewModel))
        hostingController.view.translatesAutoresizingMaskIntoConstraints = true
        hostingController.view.backgroundColor = .clear
        hostingController.view.frame = TIMEofTimerFrameView.bounds
        
        addChild(hostingController)
        TIMEofTimerFrameView.addSubview(hostingController.view)
    }
    private func configureTimeOfTarget() {
        guard let timeOfTargetViewModel = self.viewModel?.timeOfTargetViewModel else { return }
        
        let hostingController = UIHostingController(rootView: CountdownTimeLabelView(viewModel: timeOfTargetViewModel))
        hostingController.view.translatesAutoresizingMaskIntoConstraints = true
        hostingController.view.backgroundColor = .clear
        hostingController.view.frame = TIMEofTargetFrameView.bounds
        
        addChild(hostingController)
        TIMEofTargetFrameView.addSubview(hostingController.view)
    }
}

// MARK: - IBAction
extension TimerViewController {
    private func showTaskSelectVC() {
        guard let setVC = storyboard?.instantiateViewController(withIdentifier: taskSelectViewController.identifier) as? taskSelectViewController else { return }
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
extension TimerViewController {
    private func bindAll() {
        self.bindTimes()
        self.bindDaily()
        self.bindTask()
        self.bindUI()
        self.bindSound()
        self.bindWaringNewDate()
    }
    private func bindTimes() {
        self.viewModel?.$times
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] times in
                self?.updateEndTime(goalTime: RecordController.shared.isTaskGargetOn ? times.remainingTaskTime : times.goal)
                self?.updateProgress(times: times)
                self?.updateRunningColor(times: times)
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
                    self?.useageButton.alpha = 0
                } else {
                    self?.setStopColor()
                    self?.setButtonsEnabledTrue()
                    self?.enableIdleTimer()
                    self?.useageButton.alpha = 1
                }
            })
            .store(in: &self.cancellables)
    }
    private func bindSound() {
        self.viewModel?.$soundAlert
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] alert in
                guard alert else { return }
                self?.playSound()
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
extension TimerViewController {
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
        self.timerLabel.textColor = .white
        self.targetTimeLabel.textColor = .white
        self.finishTimeLabel.textColor = .white
        self.colorSelector.backgroundColor = .black
        //예상종료시간 숨기기, stop 버튼 센터로 이동
        UIView.animate(withDuration: 0.3, animations: {
            self.settingBT.alpha = 0
            self.setTimerBT.alpha = 0
            self.taskButton.layer.borderColor = UIColor.clear.cgColor
            self.startStopBTLabel.textColor = self.RED!
            self.startStopBT.layer.borderColor = UIColor.clear.cgColor
            self.startStopBTLabel.text = "◼︎"
            self.colorSelectorBorderView.alpha = 0
            self.tabBarController?.tabBar.isHidden = true
            self.todayLabel.alpha = 0
            self.darkerModeButton.alpha = 1
        })
    }
    
    private func setButtonsEnabledFalse() {
        self.settingBT.isUserInteractionEnabled = false
        self.setTimerBT.isUserInteractionEnabled = false
        self.taskButton.isUserInteractionEnabled = false
        self.colorSelector.isUserInteractionEnabled = false
    }
    
    private func setStopColor() {
        self.view.backgroundColor = self.backgroundColor
        self.outterProgress.progressColor = self.textColor
        self.innerProgress.progressColor = self.secondTextColor
        self.startStopBT.backgroundColor = self.startButtonColor!
        self.taskButton.setTitleColor(self.textColor, for: .normal)
        self.sumTimeLabel.textColor = self.textColor
        self.timerLabel.textColor = self.textColor
        self.targetTimeLabel.textColor = self.textColor
        self.finishTimeLabel.textColor = self.textColor
        self.settingBT.tintColor = self.textColor
        self.setTimerBT.tintColor = self.textColor
        self.colorSelector.backgroundColor = self.backgroundColor
        self.darkerModeButton.alpha = 0
        //예상종료시간 보이기, stop 버튼 제자리로 이동
        UIView.animate(withDuration: 0.3, animations: {
            self.settingBT.alpha = 1
            self.setTimerBT.alpha = 1
            self.taskButton.layer.borderColor = self.textColor.cgColor
            self.startStopBTLabel.textColor = self.textColor
            self.startStopBT.layer.borderColor = self.startButtonColor?.cgColor
            self.startStopBTLabel.text = "▶︎"
            self.colorSelectorBorderView.alpha = 1
            self.tabBarController?.tabBar.isHidden = false
        })
        //animation test
        if(!isLandcape) {
            UIView.animate(withDuration: 0.5, animations: {
                self.taskButton.alpha = 1
                self.todayLabel.textColor = self.textColor
                self.todayLabel.alpha = 1
            })
        }
    }
    
    private func setButtonsEnabledTrue() {
        self.settingBT.isUserInteractionEnabled = true
        self.setTimerBT.isUserInteractionEnabled = true
        self.taskButton.isUserInteractionEnabled = true
        self.colorSelector.isUserInteractionEnabled = true
        self.darkerMode = false
    }
    
    private func updateProgress(times: Times) {
        let timerPeriod = self.viewModel?.settedTimerTime ?? 2400
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
        let duration: TimeInterval = self.darkerAnimation ? 0 : 1.0
        let timer = self.darkerMode ? times.timerForDarker : times.timer
        let newProgressPer = Float(max(0, timerPeriod - timer)) / Float(timerPeriod-1)
        self.outterProgress.setProgress(duration: duration, value: newProgressPer, from: self.progressPer)
        self.progressPer = newProgressPer
        
        let newInnerProgressPer = Float(innerSum) / Float(goalPeriod)
        self.innerProgress.setProgress(duration: duration, value: newInnerProgressPer, from: self.innerProgressPer)
        self.innerProgressPer = newInnerProgressPer
        self.darkerAnimation = false
    }
    
    private func updateRunningColor(times: Times) {
        guard self.viewModel?.runningUI == true,
              times.timer <= 60 else { return }
        self.outterProgress.progressColor = RED!
    }
    
    private func playSound() {
        print("play sound")
        guard let url = Bundle.main.url(forResource: "timer", withExtension: "mp3") else {
            print("error to get the mp3 file")
            return
        }
        let player = AVPlayer(url: url)
        player.play()
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
extension TimerViewController {
    @objc func deviceRotated(){
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
                self.settingBT.alpha = 0
                self.startStopBT.alpha = 0
                self.startStopBTLabel.alpha = 0
                self.setTimerBT.alpha = 0
            }
        }
        self.isLandcape = true
    }
    
    private func setPortrait() {
        if self.viewModel?.runningUI ?? false == false {
            UIView.animate(withDuration: 0.3) {
                self.taskButton.alpha = 1
                self.todayLabel.alpha = 1
                self.settingBT.alpha = 1
                self.startStopBT.alpha = 1
                self.startStopBTLabel.alpha = 1
                self.setTimerBT.alpha = 1
            }
        }
        self.isLandcape = false
    }
}

// MARK: - Device Motion Detection
extension TimerViewController {
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
extension TimerViewController {
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

extension TimerViewController: NewRecordCreatable {
    func newRecord() {
        self.viewModel?.newRecord()
        NotificationCenter.default.post(name: .removeNewRecordWarning, object: nil)
    }
}

extension TimerViewController: TaskChangeable {
    func selectTask(to task: String) {
        self.viewModel?.changeTask(to: task)
    }
}
// MARK: 추후 Setting 에서 수시로 수정시 사용될 부분
extension TimerViewController: TimerTimeSettable {
    func updateTimerTime(to timer: Int) {
        self.viewModel?.updateTimerTime(to: timer)
    }
}

extension TimerViewController {
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
}

extension TimerViewController: ColorUpdateable {
    private func showColorSelector() {
        guard let colorSelector = storyboard?.instantiateViewController(withIdentifier: ColorSelectorVC.identifier) as? ColorSelectorVC else { return }
        colorSelector.configure(target: .timer, delegate: self)
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.setValue(colorSelector, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func fetchColor() {
        if let color = UserDefaults.standard.colorForKey(key: .timerBackground) {
            self.backgroundColor = color
        }
        let isWhite = UserDefaultsManager.get(forKey: .timerTextIsWhite) as? Bool ?? false
        self.textColor = isWhite ? .white : .black.withAlphaComponent(0.55)
        self.secondTextColor = isWhite ? .black.withAlphaComponent(0.6) : .white.withAlphaComponent(0.7)
        self.setStopColor()
        self.viewModel?.updateTextColor(isWhite: isWhite)
        self.view.layoutSubviews()
        self.tabBarController?.updateTabbarColor(backgroundColor: .clear, tintColor: self.textColor, normalColor: TiTiColor.tabbarNonSelect!)
    }
}

// MARK: popupVC
extension TimerViewController {
    private func showSettingTargetTime() {
        guard let targetTimeSettingVC = storyboard?.instantiateViewController(withIdentifier: TargetTimeSettingPopupVC.identifier) as? TargetTimeSettingPopupVC else { return }
        let info = TargetTimeSettingInfo(title: "Setting New Record".localized(),
                                         subTitle: "\(Date().YYYYMMDDstyleString) " + "setting TargetTime".localized(),
                                         targetTime: RecordController.shared.recordTimes.settedGoalTime)
        targetTimeSettingVC.configure(info: info)
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.setValue(targetTimeSettingVC, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { [weak self] _ in
            guard let targetTime = targetTimeSettingVC.settedTargetTime else { return }
            RecordController.shared.recordTimes.updateGoalTime(to: targetTime)
            UserDefaultsManager.set(to: targetTime, forKey: .goalTimeOfDaily)
            self?.newRecord()
        }))
        
        present(alert, animated: true)
    }
    
    private func showSettingTimerTime() {
        guard let targetTimeSettingVC = storyboard?.instantiateViewController(withIdentifier: TargetTimeSettingPopupVC.identifier) as? TargetTimeSettingPopupVC else { return }
        let timerTime = RecordController.shared.recordTimes.settedTimerTime
        let info = TargetTimeSettingInfo(title: "Setting Timer Time".localized(),
                                         subTitle: "End Time".localized() + ": " + timerTime.endTimeFromNow(),
                                         targetTime: timerTime)
        targetTimeSettingVC.configure(info: info) {
            guard let updatedTimerTime = targetTimeSettingVC.settedTargetTime else { return }
            targetTimeSettingVC.updateSubTitle(to: "End Time".localized() + ": " + updatedTimerTime.endTimeFromNow())
        }
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.setValue(targetTimeSettingVC, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { [weak self] _ in
            guard let timerTime = targetTimeSettingVC.settedTargetTime else { return }
            self?.updateTimerTime(to: timerTime)
        }))
        
        present(alert, animated: true)
    }
}
