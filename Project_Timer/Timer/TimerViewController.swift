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
    
    var audioPlayer : AVPlayer!
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




extension TimerViewController {
    
    
    func startTimer() {
        self.realTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerLogic), userInfo: nil, repeats: true)
        self.timerStopped = false
        print("timer start")
    }
    
    @objc func timerLogic() {
        if self.currentTimerTime < 1 {
            self.stopTimer()
            return
        }
        
        if self.currentTimerTime < 60 {
            self.TIMEofTimer.textColor = RED
            self.outterProgress.progressColor = RED!
        }
        
//        let seconds = RecordTimes.seconds(from: self.time.startDate, to: Date())
//        self.updateTimes(interval: seconds)
//        self.daily.updateCurrentTaskTime(interval: seconds)
//        self.daily.updateMaxTime(with: seconds)
        
        updateTIMELabes()
        updateProgress()
        printTimes()
        saveTimes()
    }
    
    private func stopTimer() {
        algoOfStop()
        TIMEofTimer.text = "FINISH".localized()
        playAudioFromProject()
        saveTimes()
    }
}

extension TimerViewController : ChangeViewController {
    
    func updateViewController() {
        setStopColor()
        setButtonsEnabledTrue()
        
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
        finishTimeLabel.text = updateEndTime()
//        daily.reset(currentGoalTime, currentTimerTime) //하루 그래프 초기화
        self.configureToday()
    }
    
    func changeTimer() {
        self.currentTimerTime = UserDefaults.standard.value(forKey: "second") as? Int ?? 2400
        self.progressPeriod = self.currentTimerTime
        UserDefaults.standard.set(self.currentTimerTime, forKey: "second2")
        self.TIMEofTimer.text = self.currentTimerTime.toTimeString
        self.finishTimeLabel.text = updateEndTime()
        self.outterProgress.setProgress(duration: 1.0, value: 0.0, from: currentProgressPosition)
        self.currentProgressPosition = 0.0
    }
}

//extension TimerViewController: ChangeViewController2 {
//    func changeGoalTime() {}
//
//    func changeTask() {
//        setTask()
//        daily.load()
//    }
//
//    func reload() {
//        self.viewDidLoad()
//        self.view.layoutIfNeeded()
//    }
//}

extension TimerViewController {
    
    
    
    
    
    
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
//                refresh(hours: diffHrs, mins: diffMins, secs: diffSecs, start: savedDate)
                removeSavedDate()
            }
            finishTimeLabel.text = updateEndTime()
        }
    }
    
    static func getTimeDifference(startDate: Date) -> (Int, Int, Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: startDate, to: Date())
        return(components.hour!, components.minute!, components.second!)
    }
    
//    func refresh (hours: Int, mins: Int, secs: Int, start: Date) {
//        print("refresh")
//        let seconds = RecordTimes.seconds(from: self.time.startDate, to: Date())
//        self.updateTimes(interval: seconds)
//        self.daily.updateCurrentTaskTimeOfBackground(startAt: self.time.startDate, interval: seconds)
//        self.daily.updateMaxTime(with: seconds)
//
//        updateTIMELabes()
//        updateProgress()
//        printLogs()
//        saveTimes()
//
//        self.startTimer()
//    }
    
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
    
    private func configureProgress() {
        self.outterProgress.progressWidth = 20.0
        self.outterProgress.trackColor = UIColor.darkGray
        self.innerProgress.progressWidth = 8.0
        self.innerProgress.trackColor = UIColor.clear
    }
    
    func setTimes() {
        self.updateTIMELabes()
        self.finishTimeLabel.text = updateEndTime()
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
        outterProgress.setProgress(duration: 1.0, value: 0.0, from: currentProgressPosition)
        currentProgressPosition = 0.0
    }
    
    
    
    
    
    func showLog() {
        let setVC = storyboard?.instantiateViewController(withIdentifier: "GraphViewController2") as! LogViewController
//            setVC.logViewControllerDelegate = self
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
    
    
    
    
    
    func persentReset() {
        isFirst = true
        UserDefaults.standard.set(nil, forKey: "startTime")
//        AverageLabel.textColor = UIColor.white
        progressPeriod = UserDefaults.standard.value(forKey: "second") as? Int ?? 2400
        outterProgress.setProgress(duration: 1.0, value: 0.0, from: currentProgressPosition)
        currentProgressPosition = 0.0
        //circle2
        totalTime = UserDefaults.standard.value(forKey: "allTime") as? Int ?? 21600
        innerProgress.setProgress(duration: 1.0, value: 0.0, from: currentProgressPosition)
        innerProgressPer = 0.0
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
    
    private func timerStartSetting() {
        self.setStartColor()
        timerStopped = false
        checkReset()
        // MARK: init 은 정상적일 경우에만 하도록 개선 예정
//        self.time = RecordTimes(goal: self.currentGoalTime, sum: self.currentSumTime, timer: self.currentTimerTime)
        self.startTimer()
        self.setButtonsEnabledFalse()
        finishTimeLabel.text = updateEndTime()
        if(isFirst) {
            firstStop()
            isFirst = false
        }
//        daily.recordStartSetting(taskName: task) //하루 그래프 데이터 생성
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


extension TimerViewController: TaskChangeable {
    func selectTask(to: String) {
        self.viewModel?.changeTask(to: task)
    }
}
