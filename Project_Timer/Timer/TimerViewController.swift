//
//  TimerViewController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/04/30.
//  Copyright © 2021 FDEE. All rights reserved.
//

import UIKit
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
    
    var audioPlayer : AVPlayer!
    var timerStopped = true
    var realTime = Timer()
    var currentTimerTime : Int = 0
    var currentSumTime : Int = 0
    var currentGoalTime : Int = 0
    var diffHrs = 0
    var diffMins = 0
    var diffSecs = 0
    var isFirst = false
    var progressPer: Float = 0.0
    var progressPeriod: Int = 0
    var currentProgressPosition: Float = 0.0
    var showAverage: Int = 0
    var array_day = [String](repeating: "", count: 7)
    var array_time = [String](repeating: "", count: 7)
    var totalTime: Int = 0
    var beforePer2: Float = 0.0
    var time: Time!
    var task: String = ""
    //하루 그래프를 위한 구조
    var daily = Daily()
    var isLandcape: Bool = false
    
    let dailyViewModel = DailyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLocalizable()
        self.setShadow()
        self.stopColor()
        self.stopEnable()
        self.setBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        self.setVCNum()
        self.daily.load()
        self.setTask()
        self.updateSumGoalTime()
        self.getDatas()
        self.setTimes()
        self.checkIsFirst()
        self.setProgress()
        self.dailyViewModel.loadDailys()
        self.configureToday()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("disappear in timer")
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
    
    func checkTimeTrigger() {
        realTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerLogic), userInfo: nil, repeats: true)
        timerStopped = false
    }
    
    @objc func timerLogic() {
        guard self.currentTimerTime > 60 else {
            self.TIMEofTimer.textColor = RED
            self.outterProgress.progressColor = RED!
            
            if self.currentTimerTime < 1 {
                algoOfStop()
                TIMEofTimer.text = "FINISH".localized()
                playAudioFromProject()
                saveTimes()
            }
            return
        }
        
        let seconds = Time.seconds(from: self.time.startDate, to: Date())
        self.updateTimes(interval: seconds)
        self.daily.updateCurrentTaskTime(interval: seconds)
        self.daily.updateMaxTime(with: seconds)
        
        updateTIMELabes()
        updateProgress()
        printLogs()
        saveTimes()
    }
    
    private func updateTimes(interval: Int) {
        // time 값을 기준으로 interval 만큼 지난 시간을 계산하여 표시
        self.currentSumTime = self.time.fromSumTime + interval
        self.currentTimerTime = self.time.fromTimerTime - interval
        self.currentGoalTime = self.time.fromGoalTime - interval
    }

    @IBAction func taskBTAction(_ sender: Any) {
        showTaskView()
    }
    
    @IBAction func startStopBTAction(_ sender: Any) {
        if(task == "Enter a new subject".localized()) {
            showFirstAlert()
        } else {
            //start action
            if(timerStopped == true) {
                algoOfStart()
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
    
    @IBAction func settingTimerBTAction(_ sender: Any) {
        showTimerView()
    }
}

extension TimerViewController : ChangeViewController {
    
    func updateViewController() {
        stopColor()
        stopEnable()
        
        timerStopped = true
        realTime.invalidate()
        timerStopped = true
        getTimeData()
        currentSumTime = 0
        print("reset Button complite")
        
        UserDefaults.standard.set(currentTimerTime, forKey: "second2")
        UserDefaults.standard.set(currentGoalTime, forKey: "allTime2")
        UserDefaults.standard.set(currentSumTime, forKey: "sum2")
        UserDefaults.standard.set(0, forKey: "breakTime")
        UserDefaults.standard.set(nil, forKey: "startTime")
        
        self.TIMEofSum.text = self.currentSumTime.toTimeString
        self.TIMEofTimer.text = self.currentTimerTime.toTimeString
        self.TIMEofTarget.text = self.currentGoalTime.toTimeString
        
        persentReset()
 
        //종료 예상시간 보이기
        finishTimeLabel.text = getFutureTime()
        daily.reset(currentGoalTime, currentTimerTime) //하루 그래프 초기화
        self.configureToday()
    }
    
    func changeTimer() {
        self.currentTimerTime = UserDefaults.standard.value(forKey: "second") as? Int ?? 2400
        self.progressPeriod = self.currentTimerTime
        UserDefaults.standard.set(self.currentTimerTime, forKey: "second2")
        self.TIMEofTimer.text = self.currentTimerTime.toTimeString
        self.finishTimeLabel.text = getFutureTime()
        self.outterProgress.setProgressWithAnimation(duration: 1.0, value: 0.0, from: currentProgressPosition)
        self.currentProgressPosition = 0.0
    }
}

extension TimerViewController: ChangeViewController2 {
    func changeGoalTime() {}
    
    func changeTask() {
        setTask()
        daily.load()
    }
    
    func reload() {
        self.viewDidLoad()
        self.view.layoutIfNeeded()
    }
}

extension TimerViewController {
    private func configureToday() {
        self.todayLabel.text = self.daily.day.YYYYMMDDstyleString
    }
    
    func setLandscape() {
        if(timerStopped) {
            UIView.animate(withDuration: 0.3) {
                self.taskButton.alpha = 0
                self.todayLabel.alpha = 0
            }
        }
        isLandcape = true
    }
    
    func setPortrait() {
        if(timerStopped) {
            UIView.animate(withDuration: 0.3) {
                self.taskButton.alpha = 1
                self.todayLabel.alpha = 1
            }
        }
        isLandcape = false
    }
    
    func setBackground() {
        NotificationCenter.default.addObserver(self, selector: #selector(pauseWhenBackground(noti:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(noti:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func pauseWhenBackground(noti: Notification) {
        print("background")
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
                (diffHrs, diffMins, diffSecs) = TimerViewController.getTimeDifference(startDate: savedDate)
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
        let seconds = Time.seconds(from: self.time.startDate, to: Date())
        self.updateTimes(interval: seconds)
        self.daily.updateCurrentTaskTimeOfBackground(startAt: self.time.startDate, interval: seconds)
        self.daily.updateMaxTime(with: seconds)
        
        updateTIMELabes()
        updateProgress()
        printLogs()
        saveTimes()
        
        startAction() // MARK: startTimer 로직처럼 수정 예정
    }
    
    func removeSavedDate() {
        if (UserDefaults.standard.object(forKey: "savedTime") as? Date) != nil {
            UserDefaults.standard.removeObject(forKey: "savedTime")
        }
    }
    
    func checkIsFirst() {
        if (UserDefaults.standard.object(forKey: "startTime") == nil) {
            isFirst = true
        }
    }
    
    func setShadow() {
        setTimerBT.layer.shadowColor = UIColor.gray.cgColor
        setTimerBT.layer.shadowOpacity = 0.5
        setTimerBT.layer.shadowOffset = CGSize.zero
        setTimerBT.layer.shadowRadius = 4
        
        settingBT.layer.shadowColor = UIColor.gray.cgColor
        settingBT.layer.shadowOpacity = 0.5
        settingBT.layer.shadowOffset = CGSize.zero
        settingBT.layer.shadowRadius = 4
        
        TIMEofSum.layer.shadowColor = UIColor.gray.cgColor
        TIMEofSum.layer.shadowOpacity = 0.6
        TIMEofSum.layer.shadowOffset = CGSize.zero
        TIMEofSum.layer.shadowRadius = 2
        
        TIMEofTimer.layer.shadowColor = UIColor.gray.cgColor
        TIMEofTimer.layer.shadowOpacity = 0.6
        TIMEofTimer.layer.shadowOffset = CGSize.zero
        TIMEofTimer.layer.shadowRadius = 2
        
        TIMEofTarget.layer.shadowColor = UIColor.gray.cgColor
        TIMEofTarget.layer.shadowOpacity = 0.6
        TIMEofTarget.layer.shadowOffset = CGSize.zero
        TIMEofTarget.layer.shadowRadius = 2
    }
    
    func getDatas() {
        currentSumTime = UserDefaults.standard.value(forKey: "sum2") as? Int ?? 0
        currentGoalTime = UserDefaults.standard.value(forKey: "allTime2") as? Int ?? 21600
        currentTimerTime = UserDefaults.standard.value(forKey: "second2") as? Int ?? 2400
        showAverage = UserDefaults.standard.value(forKey: "showPersent") as? Int ?? 0
        progressPeriod = UserDefaults.standard.value(forKey: "second") as? Int ?? 2400
        totalTime = UserDefaults.standard.value(forKey: "allTime") as? Int ?? 21600
    }
    
    func goToViewController(where: String) {
        let vcName = self.storyboard?.instantiateViewController(withIdentifier: `where`)
        vcName?.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
        vcName?.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
        self.present(vcName!, animated: true, completion: nil)
    }
    
    private func setVCNum() {
        UserDefaultsManager.set(to: 1, forKey: .VCNum)
    }
    
    func setProgress() {
        outterProgress.progressWidth = 20.0
        outterProgress.trackColor = UIColor.darkGray
        progressPer = Float(progressPeriod - currentTimerTime) / Float(progressPeriod)
        currentProgressPosition = progressPer
        outterProgress.setProgressWithAnimation(duration: 1.0, value: progressPer, from: 0.0)
        //circle2
        innerProgress.progressWidth = 8.0
        innerProgress.trackColor = UIColor.clear
        beforePer2 = Float(currentSumTime)/Float(totalTime)
        innerProgress.setProgressWithAnimation(duration: 1.0, value: beforePer2, from: 0.0)
    }
    
    func setTimes() {
        self.updateTIMELabes()
        self.finishTimeLabel.text = getFutureTime()
    }
    
    func firstStop() {
        let startTime = UserDefaults.standard
        startTime.set(Date(), forKey: "startTime")
        print("startTime SAVE")
        setLogData()
    }
    
    func resetTimer() {
        self.currentTimerTime = UserDefaults.standard.value(forKey: "second") as? Int ?? 2400
        UserDefaults.standard.set(self.currentTimerTime, forKey: "second2")
        self.TIMEofTimer.text = self.currentTimerTime.toTimeString
        print("reset Timer complete")
    }
    
    func resetProgress() {
        outterProgress.setProgressWithAnimation(duration: 1.0, value: 0.0, from: currentProgressPosition)
        currentProgressPosition = 0.0
    }
    
    func showSettingView() {
        let setVC = storyboard?.instantiateViewController(withIdentifier: "SetViewController") as! SetViewController
            setVC.setViewControllerDelegate = self
            present(setVC,animated: true,completion: nil)
    }
    
    func showTimerView() {
        let setVC = storyboard?.instantiateViewController(withIdentifier: "SetTimerViewController") as! SetTimerViewController
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
    
    func getTimeData(){
        currentTimerTime = UserDefaults.standard.value(forKey: "second") as? Int ?? 2400
        print("timerTime get complite")
        currentGoalTime = UserDefaults.standard.value(forKey: "allTime") as? Int ?? 21600
        print("goalTime get complite")
        showAverage = UserDefaults.standard.value(forKey: "showPersent") as? Int ?? 0
        print("showAverage get complite")
    }
    
    func startAction() {
        if timerStopped { checkTimeTrigger() }
        startEnable()
        print("Start")
    }
    
    func updateTIMELabes() {
        self.TIMEofSum.text = self.currentSumTime.toTimeString
        self.TIMEofTimer.text = self.currentTimerTime.toTimeString
        self.TIMEofTarget.text = self.currentGoalTime.toTimeString
    }
    
    func saveTimes() {
        UserDefaults.standard.set(currentSumTime, forKey: "sum2")
        UserDefaults.standard.set(currentTimerTime, forKey: "second2")
        UserDefaults.standard.set(currentGoalTime, forKey: "allTime2")
    }
    
    func printLogs() {
        print("timer : " + String(currentTimerTime))
        print("goalTime : " + String(currentGoalTime))
    }
    
    func updateProgress() {
        progressPer = Float(progressPeriod - currentTimerTime) / Float(progressPeriod)
        outterProgress.setProgressWithAnimation(duration: 1.0, value: progressPer, from: currentProgressPosition)
        currentProgressPosition = progressPer
        //circle2
        let temp = Float(currentSumTime)/Float(totalTime)
        innerProgress.setProgressWithAnimation(duration: 1.0, value: temp, from: beforePer2)
        beforePer2 = temp
    }
    
    func persentReset() {
        isFirst = true
        UserDefaults.standard.set(nil, forKey: "startTime")
//        AverageLabel.textColor = UIColor.white
        progressPeriod = UserDefaults.standard.value(forKey: "second") as? Int ?? 2400
        outterProgress.setProgressWithAnimation(duration: 1.0, value: 0.0, from: currentProgressPosition)
        currentProgressPosition = 0.0
        //circle2
        totalTime = UserDefaults.standard.value(forKey: "allTime") as? Int ?? 21600
        innerProgress.setProgressWithAnimation(duration: 1.0, value: 0.0, from: currentProgressPosition)
        beforePer2 = 0.0
    }
    
    func saveLogData() {
        UserDefaults.standard.set(self.currentSumTime.toTimeString, forKey: "time1")
    }
    
    func setLogData() {
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
    
    private func playAudioFromProject() {
        guard let url = Bundle.main.url(forResource: "timer", withExtension: "mp3") else {
            print("error to get the mp3 file")
            return
        }
        do {
            audioPlayer = try AVPlayer(url: url)
        } catch {
            print("audio file error")
        }
        audioPlayer?.play()
    }
    
    func getFutureTime() -> String {
        let now = Date()
        let future = now.addingTimeInterval(TimeInterval(currentTimerTime))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "hh:mm a"
        let today = dateFormatter.string(from: future)
        return today
    }
    
    func stopColor() {
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
    
    func startColor() {
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
    
    func stopEnable() {
        settingBT.isUserInteractionEnabled = true
        setTimerBT.isUserInteractionEnabled = true
        taskButton.isUserInteractionEnabled = true
    }
    
    func startEnable() {
        settingBT.isUserInteractionEnabled = false
        setTimerBT.isUserInteractionEnabled = false
        taskButton.isUserInteractionEnabled = false
    }
    
    func setLocalizable() {
        sumTimeLabel.text = "Sum Time".localized()
        timerLabel.text = "Timer".localized()
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
    
    func checkReset() {
        if(currentTimerTime <= 0) {
            algoOfRestart()
        }
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
    
    func updateSumGoalTime() {
        guard self.daily.tasks != [:] else { return }
        
        self.currentSumTime = self.daily.tasks.values.reduce(0, +)
        self.currentGoalTime = UserDefaults.standard.value(forKey: "allTime") as? Int ?? 21600 - self.currentSumTime
        
        UserDefaults.standard.set(self.currentSumTime, forKey: "sum2")
        UserDefaults.standard.set(self.currentGoalTime, forKey: "allTime2")
        self.saveLogData()
    }
}

extension TimerViewController {
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    func algoOfStart() {
        timerStopped = false
        startColor()
        checkReset()
        // MARK: init 은 정상적일 경우에만 하도록 개선 예정
        self.time = Time(goal: self.currentGoalTime, sum: self.currentSumTime, timer: self.currentTimerTime)
        startAction()
        finishTimeLabel.text = getFutureTime()
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
        
        stopColor()
        stopEnable()
        daily.save() //하루 그래프 데이터 계산
        //dailys 저장
        dailyViewModel.addDaily(daily)
    }
    
    func algoOfRestart() {
        resetTimer()
        resetProgress()
        finishTimeLabel.text = getFutureTime()
    }
}
