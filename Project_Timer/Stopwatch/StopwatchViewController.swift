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
        self.viewModel?.updateModeNum()
        self.viewModel?.updateTimes()
        self.updateTask()
    }
    
    private func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerLogic), userInfo: nil, repeats: true)
        self.timerStopped = false
        print("stopwatch start")
    }
    
    @objc func timerLogic() {
        let seconds = RecordTimes.seconds(from: self.time.startDate, to: Date()) // 기록 시작점 ~ 현재까지 지난 초
        self.updateTimes(interval: seconds)
        self.daily.updateCurrentTaskTime(interval: seconds)
        self.daily.updateMaxTime(with: seconds)
        
        updateTIMELabels()
        updateProgress()
        printLogs()
        saveTimes()
    }
    
    private func updateTimes(interval: Int) {
        // time 값을 기준으로 interval 만큼 지난 시간을 계산하여 표시
        self.currentSumTime = self.time.savedSumTime + interval
        self.currentStopwatchTime = self.time.savedStopwatchTime + interval
        self.currentGoalTime = self.time.goalTime - interval
    }
    
    @IBAction func taskBTAction(_ sender: Any) {
        showTaskView()
    }
    
    @IBAction func startStopBTAction(_ sender: Any) {
        if(task == "Enter a new subject".localized()) {
            showFirstAlert()
        } else {
            //start action
            if(self.timerStopped == true) {
                timerStartSetting()
            }
            //stop action
            else {
                algoOfStop()
            }
        }
    }
    
    @IBAction func settingBTAction(_ sender: Any) {
        showSettingView()
    }
    
    @IBAction func resetBTAction(_ sender: Any) {
        resetCurrentStopwatchTime()
    }
    
    @IBAction func colorSelect(_ sender: Any) {
        if #available(iOS 14.0, *) {
            let picker = UIColorPickerViewController()
            picker.selectedColor = COLOR!
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
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
    private func configureObservation() {
        NotificationCenter.default.addObserver(self, selector: #selector(pauseWhenBackground(noti:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(noti:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    private func configureViewModel() {
        self.viewModel = StopwatchVM()
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

// MARK: - viewWillAppear logic
extension StopwatchViewController {
    private func updateTask() {
        let task = self.viewModel?.task ?? "none"
        if task == "none" {
            self.taskButton.setTitle("Enter a new subject".localized(), for: .normal)
            self.setFirstStart()
        } else {
            self.taskButton.setTitle(task, for: .normal)
        }
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




extension StopwatchViewController : ChangeViewController2 {
    
    func changeGoalTime() {
        firstRecordStart = true
        UserDefaults.standard.set(nil, forKey: "startTime")
        configureColor()
        currentGoalTime = UserDefaults.standard.value(forKey: "allTime") as? Int ?? 0
        let timerTime = UserDefaults.standard.value(forKey: "second") as? Int ?? 2400
        currentSumTime = 0
        currentStopwatchTime = 0
        
        UserDefaults.standard.set(currentGoalTime, forKey: "allTime2")
        UserDefaults.standard.set(currentSumTime, forKey: "sum2")
        
        resetProgress()
        updateTIMELabels()
        finishTimeLabel.text = getFutureTime()
        
        setStopColor()
        setButtonsEnabledTrue()
        daily.reset(currentGoalTime, timerTime) //하루 그래프 초기화
        resetCurrentStopwatchTime()
        self.updateToday()
    }
    
    func changeTask() {
        updateTask()
        daily.load()
        resetCurrentStopwatchTime()
    }
    
    func reload() {
        self.viewDidLoad()
        self.view.layoutIfNeeded()
    }
}


extension StopwatchViewController {
    
    
    
    
    
    
    @objc func pauseWhenBackground(noti: Notification) {
        print("background")
        UserDefaultsManager.set(to: self.currentStopwatchTime, forKey: .sumTime_temp)
        if self.timerStopped == false {
            self.timer.invalidate()
            let shared = UserDefaults.standard
            shared.set(Date(), forKey: "savedTime") // 나가는 시점의 시간 저장
        }
    }
    
    @objc func willEnterForeground(noti: Notification) {
        print("Enter")
        if self.timerStopped == false {
            if let savedDate = UserDefaults.standard.object(forKey: "savedTime") as? Date {
                (diffHrs, diffMins, diffSecs) = StopwatchViewController.getTimeDifference(startDate: savedDate)
                refresh(hours: diffHrs, mins: diffMins, secs: diffSecs, start: savedDate)
                removeSavedDate()
            }
            finishTimeLabel.text = getFutureTime()
        }
    }
    
    static func getTimeDifference(startDate: Date) -> (Int, Int, Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: startDate, to: Date())
        return(components.hour!, components.minute!, components.second!)
    }
    
    func refresh (hours: Int, mins: Int, secs: Int, start: Date) {
        print("refresh")
        let seconds = RecordTimes.seconds(from: self.time.startDate, to: Date())
        self.updateTimes(interval: seconds)
        self.daily.updateCurrentTaskTimeOfBackground(startAt: self.time.startDate, interval: seconds)
        self.daily.updateMaxTime(with: seconds)
        
        updateTIMELabels()
        updateProgress()
        printLogs()
        saveTimes()
        
        self.startTimer()
    }
    
    func removeSavedDate() {
        if (UserDefaults.standard.object(forKey: "savedTime") as? Date) != nil {
            UserDefaults.standard.removeObject(forKey: "savedTime")
        }
    }

    func resetProgress() {
        outterProgress.setProgress(duration: 1.0, value: 0.0, from: beforePer)
        beforePer = 0.0
        //circle2
        totalTime = UserDefaults.standard.value(forKey: "allTime") as? Int ?? 21600
        innerProgress.setProgress(duration: 1.0, value: 0.0, from: beforePer2)
        beforePer2 = 0.0
    }
    
    private func configureProgress() {
        self.outterProgress.progressWidth = 20.0
        self.outterProgress.trackColor = UIColor.darkGray
        self.innerProgress.progressWidth = 8.0
        self.innerProgress.trackColor = UIColor.clear
    }
    
    private func updateWeekly() {
        UserDefaultsManager.set(to: Date(), forKey: .startTime)
        self.appendDateToWeekly()
        self.firstRecordStart = false
    }
    
    func showSettingView() {
        let setVC = storyboard?.instantiateViewController(withIdentifier: "SetTimerViewController2") as! SetTimerViewController2
            setVC.SetTimerViewControllerDelegate = self
            present(setVC,animated: true,completion: nil)
    }
    
    func showTaskView() {
        let setVC = storyboard?.instantiateViewController(withIdentifier: "taskSelectViewController") as! taskSelectViewController
            setVC.SetTimerViewControllerDelegate = self
            present(setVC,animated: true,completion: nil)
    }
    
    func showLog() {
        let setVC = storyboard?.instantiateViewController(withIdentifier: "GraphViewController2") as! LogViewController
            setVC.logViewControllerDelegate = self
            present(setVC,animated: true,completion: nil)
    }
    
    
    
    func updateProgress(times: Times) {
        let newProgressPer = Float(times.stopwatch%progressPeriod) / Float(progressPeriod)
        self.outterProgress.setProgress(duration: 1.0, value: newProgressPer, from: self.progressPer)
        self.progressPer = newProgressPer
        
        //circle2
        let temp = Float(currentSumTime)/Float(totalTime)
        innerProgress.setProgressWithAnimation(duration: 1.0, value: temp, from: beforePer2)
        beforePer2 = temp
    }
    
    func printLogs() {
        print("sum : " + String(currentSumTime))
        print("stopwatch : \(currentStopwatchTime)")
        print("target : " + String(currentGoalTime))
    }
    
    func saveTimes() {
        UserDefaults.standard.set(currentSumTime, forKey: "sum2")
        UserDefaults.standard.set(currentGoalTime, forKey: "allTime2")
    }
    
    func appendDateToWeekly() {
        for i in stride(from: 0, to: 7, by: 1) {
            array_day[i] = UserDefaults.standard.value(forKey: "day"+String(i+1)) as? String ?? "NO DATA"
            array_time[i] = UserDefaults.standard.value(forKey: "time"+String(i+1)) as? String ?? "NO DATA"
        }
        //값 옮기기, 값 저장하기
        for i in stride(from: 6, to: 0, by: -1) {
            array_day[i] = array_day[i-1]
            UserDefaults.standard.set(array_day[i], forKey: "day"+String(i+1))
            array_time[i] = array_time[i-1]
            UserDefaults.standard.set(array_time[i], forKey: "time"+String(i+1))
        }
        //log 날짜 설정
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월 d일"
        let today = dateFormatter.string(from: now)
        UserDefaults.standard.set(today, forKey: "day1")
    }
    
    
    
    
    
    func goToViewController(where: String) {
        let vcName = self.storyboard?.instantiateViewController(withIdentifier: `where`)
        vcName?.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
        vcName?.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
        self.present(vcName!, animated: true, completion: nil)
    }
    
    
    
    
    
    func resetCurrentStopwatchTime() {
        self.currentStopwatchTime = 0
        UserDefaultsManager.set(to: 0, forKey: .sumTime_temp)
        self.updateTIMELabels()
        self.updateProgress()
    }
    
    func setFirstStart() {
        taskButton.setTitleColor(UIColor.systemPink, for: .normal)
        taskButton.layer.borderColor = UIColor.systemPink.cgColor
    }
    
    func showFirstAlert() {
        //1. 경고창 내용 만들기
        let alert = UIAlertController(title:"Enter a new subject".localized(),
            message: "",
            preferredStyle: UIAlertController.Style.alert)
        //2. 확인 버튼 만들기
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        //3. 확인 버튼을 경고창에 추가하기
        alert.addAction(ok)
        //4. 경고창 보이기
        present(alert,animated: true,completion: nil)
    }
}


extension StopwatchViewController {
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    private func timerStartSetting() {
        self.setStartColor()
        self.updateProgress()
        // MARK: - init 은 정상적일 경우에만 하도록 개선 예정
        self.time = RecordTimes(goal: self.currentGoalTime, sum: self.currentSumTime, stopwatch: self.currentStopwatchTime)
        self.startTimer()
        self.setButtonsEnabledFalse()
        self.finishTimeLabel.text = getFutureTime()
        if self.firstRecordStart {
            self.updateWeekly()
        }
        self.daily.recordStartSetting(taskName: self.task) // 현재 task에 대한 기록 설정
    }
    
    func algoOfStop() {
        self.timer.invalidate()
        self.timerStopped = true
        
        saveLogData()
        updateTIMELabels()
        
        setStopColor()
        setButtonsEnabledTrue()
        time.savedStopwatchTime = currentStopwatchTime //기준시간 저장
        daily.save() //하루 그래프 데이터 계산
        //dailys 저장
        dailyViewModel.addDaily(daily)
        UserDefaultsManager.set(to: self.currentStopwatchTime, forKey: .sumTime_temp)
    }
}

extension StopwatchViewController {
    private func changeColor(color: UIColor) {
        UserDefaults.standard.setColor(color: COLOR, forKey: "color")
        self.COLOR = color
        self.view.backgroundColor = self.COLOR
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
}
