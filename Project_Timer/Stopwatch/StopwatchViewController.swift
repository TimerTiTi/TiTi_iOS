//
//  StopwatchViewController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/04/30.
//  Copyright © 2021 FDEE. All rights reserved.
//

import UIKit
import Combine

final class StopwatchViewController: UIViewController {
    static let identifier = "StopwatchViewController"

    @IBOutlet var taskButton: UIButton!
    @IBOutlet var innerProgress: CircularProgressView!
    @IBOutlet var outterProgress: CircularProgressView!
    
    @IBOutlet var sumTimeLabel: UILabel!
    @IBOutlet var TIMEofSum: UILabel!
    @IBOutlet var stopWatchLabel: UILabel!
    @IBOutlet var TIMEofStopwatch: UILabel!
    @IBOutlet var targetTimeLabel: UILabel!
    @IBOutlet var TIMEofTarget: UILabel!
    @IBOutlet var finishTimeLabel: UILabel!
    
    @IBOutlet var startStopBT: UIButton!
    @IBOutlet var startStopBTLabel: UILabel!
    @IBOutlet var resetBT: UIButton!
    @IBOutlet var settingBT: UIButton!
    @IBOutlet weak var colorSelector: UIButton!
    @IBOutlet weak var todayLabel: UILabel!
    
    var COLOR = UIColor(named: "Background2")
    let RED = UIColor(named: "Text")
    let INNER = UIColor(named: "innerColor")
    let startButtonColor = UIColor(named: "startButtonColor")
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
        self.bindAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel?.updateTask()
        self.viewModel?.updateModeNum()
        self.viewModel?.updateTimes()
    }
    
    @IBAction func taskSelect(_ sender: Any) {
        self.showTaskSelectVC()
    }
    
    @IBAction func timerStartStopAction(_ sender: Any) {
        guard self.viewModel?.task ?? "none" != "none" else {
            self.showTaskWarningAlert()
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
}

// MARK: - Configure
extension StopwatchViewController {
    private func configureLocalizable() {
        self.sumTimeLabel.text = "Sum Time".localized()
        self.stopWatchLabel.text = "Stopwatch".localized()
        self.targetTimeLabel.text = "Target Time".localized()
    }
    private func configureColor() {
        self.COLOR = UserDefaultsManager.get(forKey: .color) as? UIColor ?? UIColor(named: "Background2")
    }
    private func configureShadow() {
        self.resetBT.configureShadow(opacity: 0.5, radius: 4)
        self.settingBT.configureShadow(opacity: 0.5, radius: 4)
        self.TIMEofSum.configureShadow(opacity: 0.6, radius: 2)
        self.TIMEofStopwatch.configureShadow(opacity: 0.6, radius: 2)
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
    private func configureViewModel() {
        self.viewModel = StopwatchVM()
    }
}

// MARK: - IBAction
extension StopwatchViewController {
    private func showTaskSelectVC() {
        guard let setVC = storyboard?.instantiateViewController(withIdentifier: taskSelectViewController.identifier) as? taskSelectViewController else { return }
        setVC.SetTimerViewControllerDelegate = self
        present(setVC,animated: true,completion: nil)
    }
    
    private func showSettingView() {
        guard let setVC = storyboard?.instantiateViewController(withIdentifier: SetTimerViewController2.identifier) as? SetTimerViewController2 else { return }
        setVC.delegate = self
        present(setVC,animated: true,completion: nil)
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
        self.bindUI()
    }
    private func bindTimes() {
        self.viewModel?.$times
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] times in
                self?.updateTIMELabels(times: times)
                self?.updateEndTime(goalTime: times.goal)
                self?.updateProgress(times: times)
                self?.printTimes(with: times)
            })
            .store(in: &self.cancellables)
    }
    private func bindDaily() {
        self.viewModel?.$daily
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] daily in
                self?.updateToday(to: daily.day)
            })
            .store(in: &self.cancellables)
    }
    private func bindTask() {
        self.viewModel?.$task
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] task in
                self?.updateTask(to: task)
            })
            .store(in: &self.cancellables)
    }
    private func bindUI() {
        self.viewModel?.$runningUI
            .receive(on: DispatchQueue.main)
            .dropFirst()
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
}

// MARK: - logic
extension StopwatchViewController {
    private func updateTask(to task: String) {
        if task == "none" {
            self.taskButton.setTitle("Enter a new subject".localized(), for: .normal)
            self.setTaskWarningColor()
        } else {
            self.taskButton.setTitle(task, for: .normal)
        }
    }
    
    private func setTaskWarningColor() {
        self.taskButton.setTitleColor(UIColor.systemPink, for: .normal)
        self.taskButton.layer.borderColor = UIColor.systemPink.cgColor
    }
    
    private func updateTIMELabels(times: Times) {
        self.TIMEofSum.text = times.sum.toTimeString
        self.TIMEofStopwatch.text = times.stopwatch.toTimeString
        self.TIMEofTarget.text = times.goal.toTimeString
    }
    
    private func updateEndTime(goalTime: Int) {
        let endAt = Date().addingTimeInterval(TimeInterval(goalTime))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "TO hh:mm a"
        let endTime = dateFormatter.string(from: endAt)
        self.finishTimeLabel.text = endTime
    }
    
    private func updateToday(to date: Date) {
        self.todayLabel.text = date.YYYYMMDDstyleString
    }
    
    private func setStartColor() {
        self.view.backgroundColor = UIColor.black
        outterProgress.progressColor = COLOR!
        innerProgress.progressColor = UIColor.white
        startStopBT.backgroundColor = UIColor.clear
        TIMEofStopwatch.textColor = COLOR
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
        TIMEofStopwatch.textColor = UIColor.white
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
        let newProgressPer = Float(times.stopwatch % self.progressPeriod) / Float(self.progressPeriod)
        self.outterProgress.setProgress(duration: 1.0, value: newProgressPer, from: self.progressPer)
        self.progressPer = newProgressPer
        
        let newInnerProgressPer = Float(times.sum) / Float(self.viewModel?.setttedGoalTime ?? 21600)
        self.innerProgress.setProgress(duration: 1.0, value: newInnerProgressPer, from: self.innerProgressPer)
        self.innerProgressPer = newInnerProgressPer
    }
    
    private func printTimes(with times: Times) {
        print("sum: \(times.sum.toTimeString)")
        print("stopwatch: \(times.stopwatch.toTimeString)")
        print("goal: \(times.goal.toTimeString)")
    }
}

// MARK: - Rotation
extension StopwatchViewController {
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
        UserDefaults.standard.setColor(color: COLOR, forKey: "color")
        self.COLOR = color
        self.view.backgroundColor = self.COLOR
    }
}
