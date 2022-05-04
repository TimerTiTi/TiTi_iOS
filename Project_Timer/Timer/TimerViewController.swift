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

class TimerViewController: UIViewController {
    static let identifier = "TimerViewController"

    @IBOutlet var taskButton: UIButton!
    @IBOutlet var innerProgress: CircularProgressView!
    @IBOutlet var outterProgress: CircularProgressView!
    
    @IBOutlet var sumTimeLabel: UILabel!
    @IBOutlet var TIMEofSum: UILabel!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var TIMEofTimer: UILabel!
    @IBOutlet var targetTimeLabel: UILabel!
    @IBOutlet var TIMEofTarget: UILabel!
    @IBOutlet var finishTimeLabel: UILabel!
    
    @IBOutlet var startStopBT: UIButton!
    @IBOutlet var startStopBTLabel: UILabel!
    @IBOutlet var setTimerBT: UIButton!
    @IBOutlet var settingBT: UIButton!
    @IBOutlet weak var todayLabel: UILabel!
    
    let BLUE = UIColor(named: "Blue")
    let RED = UIColor(named: "Text")
    let INNER = UIColor(named: "innerColor")
    let startButtonColor = UIColor(named: "startButtonColor")
    private var cancellables: Set<AnyCancellable> = []
    private var viewModel: TimerVM?
    
    var audioPlayer: AVPlayer?
    var progressPer: Float = 0.0
    var progressPeriod: Int = 0
    var innerProgressPer: Float = 0.0
    var isLandcape: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureLocalizable()
        self.configureShadow()
        self.configureProgress()
        self.configureObservation()
        self.configureSound()
        self.setStopColor()
        self.setButtonsEnabledTrue()
        self.configureViewModel()
        self.bindAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel?.updateTask()
        self.viewModel?.updateModeNum()
        self.viewModel?.updateTimes()
        self.viewModel?.updateDaily()
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
        self.viewModel?.timerReset()
    }
}

// MARK: - Configure
extension TimerViewController {
    private func configureLocalizable() {
        self.sumTimeLabel.text = "Sum Time".localized()
        self.timerLabel.text = "Timer".localized()
        self.targetTimeLabel.text = "Target Time".localized()
    }
    private func configureShadow() {
        self.setTimerBT.configureShadow(opacity: 0.5, radius: 4)
        self.settingBT.configureShadow(opacity: 0.5, radius: 4)
        self.TIMEofSum.configureShadow(opacity: 0.6, radius: 2)
        self.TIMEofTimer.configureShadow(opacity: 0.6, radius: 2)
        self.TIMEofTarget.configureShadow(opacity: 0.6, radius: 2)
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
    }
    private func configureSound() {
        guard let url = Bundle.main.url(forResource: "timer", withExtension: "mp3") else {
            print("error to get the mp3 file")
            return
        }
        self.audioPlayer = AVPlayer(url: url)
    }
    private func configureViewModel() {
        self.viewModel = TimerVM()
    }
}

// MARK: - IBAction
extension TimerViewController {
    private func showTaskSelectVC() {
        guard let setVC = storyboard?.instantiateViewController(withIdentifier: taskSelectViewController.identifier) as? taskSelectViewController else { return }
        setVC.delegate = self
        present(setVC,animated: true,completion: nil)
    }
    private func showSettingView() {
        guard let setVC = storyboard?.instantiateViewController(withIdentifier: SetViewController.identifier) as? SetViewController else { return }
        setVC.setViewControllerDelegate = self
        present(setVC,animated: true,completion: nil)
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
    }
    private func bindTimes() {
        self.viewModel?.$times
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] times in
                self?.updateTIMELabels(times: times)
                self?.updateEndTime(goalTime: times.goal)
                self?.updateProgress(times: times)
                self?.updateRunningColor(times: times)
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
                    self?.setStartColor()
                    self?.setButtonsEnabledFalse()
                } else {
                    self?.setStopColor()
                    self?.setButtonsEnabledTrue()
                }
            })
            .store(in: &self.cancellables)
    }
    private func bindSound() {
        self.viewModel?.$soundAlert
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] alert in
                guard alert else { return }
                self?.audioPlayer?.play()
            })
            .store(in: &self.cancellables)
    }
}

// MARK: - logic
extension TimerViewController {
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
        self.taskButton.setTitleColor(UIColor.systemPink, for: .normal)
        self.taskButton.layer.borderColor = UIColor.systemPink.cgColor
    }
    
    private func setTaskWhiteColor() {
        self.taskButton.setTitleColor(UIColor.white, for: .normal)
        self.taskButton.layer.borderColor = UIColor.white.cgColor
    }
    
    private func updateTIMELabels(times: Times) {
        self.TIMEofSum.text = times.sum.toTimeString
        self.TIMEofTimer.text = times.timer.toTimeString
        self.TIMEofTarget.text = times.goal.toTimeString
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
        outterProgress.progressColor = BLUE!
        innerProgress.progressColor = UIColor.white
        startStopBT.backgroundColor = UIColor.clear
        TIMEofTimer.textColor = BLUE
        //예상종료시간 숨기기, stop 버튼 센터로 이동
        UIView.animate(withDuration: 0.3, animations: {
            self.setTimerBT.alpha = 0
            self.settingBT.alpha = 0
            self.taskButton.layer.borderColor = UIColor.clear.cgColor
            self.startStopBTLabel.textColor = self.RED!
            self.startStopBT.layer.borderColor = UIColor.clear.cgColor
            self.startStopBTLabel.text = "◼︎"
            self.tabBarController?.tabBar.isHidden = true
            self.todayLabel.alpha = 0
        })
    }
    
    private func setButtonsEnabledFalse() {
        self.settingBT.isUserInteractionEnabled = false
        self.setTimerBT.isUserInteractionEnabled = false
        self.taskButton.isUserInteractionEnabled = false
    }
    
    private func setStopColor() {
        self.view.backgroundColor = BLUE
        outterProgress.progressColor = UIColor.white
        innerProgress.progressColor = INNER!
        startStopBT.backgroundColor = startButtonColor!
        TIMEofTimer.textColor = UIColor.white
        //예상종료시간 보이기, stop 버튼 제자리로 이동
        UIView.animate(withDuration: 0.3, animations: {
            self.setTimerBT.alpha = 1
            self.settingBT.alpha = 1
            self.taskButton.layer.borderColor = UIColor.white.cgColor
            self.startStopBTLabel.textColor = UIColor.white
            self.startStopBT.layer.borderColor = self.startButtonColor?.cgColor
            self.startStopBTLabel.text = "▶︎"
            self.tabBarController?.tabBar.isHidden = false
        })
        //animation test
        if(!isLandcape) {
            UIView.animate(withDuration: 0.5, animations: {
                self.taskButton.alpha = 1
                self.todayLabel.alpha = 1
            })
        }
    }
    
    private func setButtonsEnabledTrue() {
        self.settingBT.isUserInteractionEnabled = true
        self.setTimerBT.isUserInteractionEnabled = true
        self.taskButton.isUserInteractionEnabled = true
    }
    
    private func updateProgress(times: Times) {
        let timerPeriod = self.viewModel?.settedTimerTime ?? 2400
        let goalPeriod = self.viewModel?.settedGoalTime ?? 21600
        
        let newProgressPer = Float(timerPeriod - times.timer) / Float(timerPeriod)
        self.outterProgress.setProgress(duration: 1.0, value: newProgressPer, from: self.progressPer)
        self.progressPer = newProgressPer
        
        let newInnerProgressPer = Float(times.sum) / Float(goalPeriod)
        self.innerProgress.setProgress(duration: 1.0, value: newInnerProgressPer, from: self.innerProgressPer)
        self.innerProgressPer = newInnerProgressPer
    }
    
    private func printTimes(with times: Times) {
        print("sum: \(times.sum.toTimeString)")
        print("timer: \(times.timer.toTimeString)")
        print("goal: \(times.goal.toTimeString)")
    }
    
    private func updateRunningColor(times: Times) {
        guard times.timer < 60 else { return }
        self.TIMEofTimer.textColor = RED
        self.outterProgress.progressColor = RED!
    }
}

// MARK: - Rotation
extension TimerViewController {
    @objc func deviceRotated(){
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
        self.isLandcape = true
    }
    
    private func setPortrait() {
        if self.viewModel?.runningUI ?? false == false {
            UIView.animate(withDuration: 0.3) {
                self.taskButton.alpha = 1
                self.todayLabel.alpha = 1
            }
        }
        self.isLandcape = false
    }
}

// MARK: Background
extension TimerViewController {
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

extension TimerViewController: NewRecordCreatable {
    func newRecord() {
        self.viewModel?.newRecord()
    }
}

extension TimerViewController: TaskChangeable {
    func selectTask(to task: String) {
        self.viewModel?.changeTask(to: task)
    }
}

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

extension TimerViewController {
    private func timerStartSetting() {
        self.setStartColor()
        timerStopped = false
        checkReset()
        // MARK: init 은 정상적일 경우에만 하도록 개선 예정
        self.time = RecordTimes(goal: self.currentGoalTime, sum: self.currentSumTime, timer: self.currentTimerTime)
        self.startTimer()
        self.setButtonsEnabledFalse()
        finishTimeLabel.text = updateEndTime()
        if(isFirst) {
            firstStop()
            isFirst = false
        }
        daily.recordStartSetting(taskName: task) //하루 그래프 데이터 생성
    }
    
    func algoOfStop() {
        timerStopped = true
        timerStopped = true
        realTime.invalidate()
        
        saveLogData()
        setTimes()
        
        setStopColor()
        setButtonsEnabledTrue()
        daily.save() //하루 그래프 데이터 계산
        //dailys 저장
        dailyViewModel.addDaily(daily)
    }
    
    func algoOfRestart() {
        resetTimer()
        resetProgress()
        finishTimeLabel.text = updateEndTime()
    }
}
