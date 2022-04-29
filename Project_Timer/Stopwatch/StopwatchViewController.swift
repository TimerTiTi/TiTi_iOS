//
//  StopwatchViewController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/04/30.
//  Copyright © 2021 FDEE. All rights reserved.
//

import UIKit

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
    
    var timerStopped = true
    var realTime = Timer()
    var currentSumTime: Int = 0
    var currentStopwatchTime: Int = 0
    var currentGoalTime: Int = 0
    var diffHrs = 0
    var diffMins = 0
    var diffSecs = 0
    var firstRecordStart = false
    var progressPer: Float = 0.0
    let progressPeriod: Int = 3600
    var fixedBreak: Int = 300
    var beforePer: Float = 0.0
    var array_day = [String](repeating: "", count: 7)
    var array_time = [String](repeating: "", count: 7)
    var totalTime: Int = 0
    var beforePer2: Float = 0.0
    var task: String = ""
    var time: RecordTimes!
    //하루 그래프를 위한 구조
    var daily = Daily()
    var isLandscape: Bool = false
    
    let dailyViewModel = DailyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLocalizable()
        self.setColor()
        self.setShadow()
        self.stopColor()
        self.setButtonsEnabledTrue()
        self.setBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        self.setVCNum()
        self.daily.load()
        self.setTask()
        self.updateSumGoalTime()
        self.configureTimes()
        self.updateTIMELabels()
        self.finishTimeLabel.text = self.getFutureTime()
        self.checkFirstRecordStart()
        self.setFirstProgress()
        self.dailyViewModel.loadDailys()
        self.configureToday()
    }

    override func viewWillDisappear(_ animated: Bool) {
        print("disappear in stopwatch")
        UserDefaultsManager.set(to: self.currentStopwatchTime, forKey: .sumTime_temp)
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    @objc func deviceRotated(){
        if UIDevice.current.orientation.isLandscape {
            //Code here
            print("Landscape")
            setLandscape()
        } else {
            //Code here
            print("Portrait")
            setPortrait()
        }
    }
    
    private func startTimer() {
        self.realTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerLogic), userInfo: nil, repeats: true)
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

extension StopwatchViewController : ChangeViewController2 {
    
    func changeGoalTime() {
        firstRecordStart = true
        UserDefaults.standard.set(nil, forKey: "startTime")
        setColor()
        currentGoalTime = UserDefaults.standard.value(forKey: "allTime") as? Int ?? 0
        let timerTime = UserDefaults.standard.value(forKey: "second") as? Int ?? 2400
        currentSumTime = 0
        currentStopwatchTime = 0
        
        UserDefaults.standard.set(currentGoalTime, forKey: "allTime2")
        UserDefaults.standard.set(currentSumTime, forKey: "sum2")
        
        resetProgress()
        updateTIMELabels()
        finishTimeLabel.text = getFutureTime()
        
        stopColor()
        setButtonsEnabledTrue()
        daily.reset(currentGoalTime, timerTime) //하루 그래프 초기화
        resetCurrentStopwatchTime()
        self.configureToday()
    }
    
    func changeTask() {
        setTask()
        daily.load()
        resetCurrentStopwatchTime()
    }
    
    func reload() {
        self.viewDidLoad()
        self.view.layoutIfNeeded()
    }
}


extension StopwatchViewController {
    private func configureToday() {
        self.todayLabel.text = self.daily.day.YYYYMMDDstyleString
    }
    
    func setLandscape() {
        if self.timerStopped {
            UIView.animate(withDuration: 0.3) {
                self.taskButton.alpha = 0
                self.todayLabel.alpha = 0
            }
        }
        isLandscape = true
    }
    
    func setPortrait() {
        if self.timerStopped {
            UIView.animate(withDuration: 0.3) {
                self.taskButton.alpha = 1
                self.todayLabel.alpha = 1
            }
        }
        isLandscape = false
    }
    
    func setBackground() {
        NotificationCenter.default.addObserver(self, selector: #selector(pauseWhenBackground(noti:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(noti:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func pauseWhenBackground(noti: Notification) {
        print("background")
        UserDefaultsManager.set(to: self.currentStopwatchTime, forKey: .sumTime_temp)
        if self.timerStopped == false {
            self.realTime.invalidate()
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
    
    func setShadow() {
        resetBT.layer.shadowColor = UIColor.gray.cgColor
        resetBT.layer.shadowOpacity = 0.5
        resetBT.layer.shadowOffset = CGSize.zero
        resetBT.layer.shadowRadius = 4
        
        settingBT.layer.shadowColor = UIColor.gray.cgColor
        settingBT.layer.shadowOpacity = 0.5
        settingBT.layer.shadowOffset = CGSize.zero
        settingBT.layer.shadowRadius = 4
        
        TIMEofSum.layer.shadowColor = UIColor.gray.cgColor
        TIMEofSum.layer.shadowOpacity = 0.6
        TIMEofSum.layer.shadowOffset = CGSize.zero
        TIMEofSum.layer.shadowRadius = 2
        
        TIMEofStopwatch.layer.shadowColor = UIColor.gray.cgColor
        TIMEofStopwatch.layer.shadowOpacity = 0.6
        TIMEofStopwatch.layer.shadowOffset = CGSize.zero
        TIMEofStopwatch.layer.shadowRadius = 2
        
        TIMEofTarget.layer.shadowColor = UIColor.gray.cgColor
        TIMEofTarget.layer.shadowOpacity = 0.6
        TIMEofTarget.layer.shadowOffset = CGSize.zero
        TIMEofTarget.layer.shadowRadius = 2
    }
    
    private func configureTimes() {
        self.currentSumTime = UserDefaults.standard.value(forKey: "sum2") as? Int ?? 0
        self.currentStopwatchTime = UserDefaultsManager.get(forKey: .sumTime_temp) as? Int ?? 0
        self.currentGoalTime = UserDefaults.standard.value(forKey: "allTime2") as? Int ?? 21600
        self.totalTime = UserDefaults.standard.value(forKey: "allTime") as? Int ?? 21600
    }
    
    private func checkFirstRecordStart() {
        self.firstRecordStart = UserDefaultsManager.get(forKey: .startTime) as? Date? == nil
    }

    func resetProgress() {
        outterProgress.setProgressWithAnimation(duration: 1.0, value: 0.0, from: beforePer)
        beforePer = 0.0
        //circle2
        totalTime = UserDefaults.standard.value(forKey: "allTime") as? Int ?? 21600
        innerProgress.setProgressWithAnimation(duration: 1.0, value: 0.0, from: beforePer2)
        beforePer2 = 0.0
    }
    
    private func setFirstProgress() {
        outterProgress.progressWidth = 20.0
        outterProgress.trackColor = UIColor.darkGray
        progressPer = Float(currentStopwatchTime%progressPeriod) / Float(progressPeriod)
        beforePer = progressPer
        outterProgress.setProgressWithAnimation(duration: 1.0, value: progressPer, from: 0.0)
        //circle2
        innerProgress.progressWidth = 8.0
        innerProgress.trackColor = UIColor.clear
        beforePer2 = Float(currentSumTime)/Float(totalTime)
        innerProgress.setProgressWithAnimation(duration: 1.0, value: beforePer2, from: 0.0)
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
    
    func updateTIMELabels() {
        self.TIMEofSum.text = self.currentSumTime.toTimeString
        self.TIMEofStopwatch.text = self.currentStopwatchTime.toTimeString
        self.TIMEofTarget.text = self.currentGoalTime.toTimeString
    }
    
    func updateProgress() {
        progressPer = Float(currentStopwatchTime%progressPeriod) / Float(progressPeriod)
        outterProgress.setProgressWithAnimation(duration: 1.0, value: progressPer, from: beforePer)
        beforePer = progressPer
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
    
    func saveLogData() {
        UserDefaults.standard.set(currentSumTime.toTimeString, forKey: "time1")
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
    
    func getFutureTime() -> String {
        let now = Date()
        let future = now.addingTimeInterval(TimeInterval(currentGoalTime))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "hh:mm a"
        let today = dateFormatter.string(from: future)
        return today
    }
    
    func stopColor() {
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
    
    func setColorsOfStart() {
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
    
    private func setButtonsEnabledTrue() {
        self.settingBT.isUserInteractionEnabled = true
        self.taskButton.isUserInteractionEnabled = true
        self.resetBT.isUserInteractionEnabled = true
    }
    
    private func setButtonsEnabledFalse() {
        self.settingBT.isUserInteractionEnabled = false
        self.taskButton.isUserInteractionEnabled = false
        self.resetBT.isUserInteractionEnabled = false
    }
    
    func goToViewController(where: String) {
        let vcName = self.storyboard?.instantiateViewController(withIdentifier: `where`)
        vcName?.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
        vcName?.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
        self.present(vcName!, animated: true, completion: nil)
    }
    
    func setColor() {
        if let color = UserDefaultsManager.get(forKey: .color) as? UIColor {
            self.COLOR = color
        } else {
            self.COLOR = UIColor(named: "Background2")
        }
    }
    
    func setVCNum() {
        UserDefaults.standard.set(2, forKey: "VCNum")
    }
    
    func setLocalizable() {
        sumTimeLabel.text = "Sum Time".localized()
        stopWatchLabel.text = "Stopwatch".localized()
        targetTimeLabel.text = "Target Time".localized()
    }
    
    func setTask() {
        task = UserDefaults.standard.value(forKey: "task") as? String ?? "Enter a new subject".localized()
        if(task == "Enter a new subject".localized()) {
            setFirstStart()
        } else {
            taskButton.setTitleColor(UIColor.white, for: .normal)
            taskButton.layer.borderColor = UIColor.white.cgColor
        }
        taskButton.setTitle(task, for: .normal)
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
    
    private func updateSumGoalTime() {
        guard self.daily.tasks != [:] else { return }
        
        self.currentSumTime = self.daily.tasks.values.reduce(0, +)
        self.currentGoalTime = UserDefaults.standard.value(forKey: "allTime") as? Int ?? 21600 - self.currentSumTime
        
        UserDefaults.standard.set(self.currentSumTime, forKey: "sum2")
        UserDefaults.standard.set(self.currentGoalTime, forKey: "allTime2")
        self.saveLogData()
    }
}


extension StopwatchViewController {
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    private func timerStartSetting() {
        self.setColorsOfStart()
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
        self.realTime.invalidate()
        self.timerStopped = true
        
        saveLogData()
        updateTIMELabels()
        
        stopColor()
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
