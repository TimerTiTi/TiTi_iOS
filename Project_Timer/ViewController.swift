//
//  ViewController.swift
//  Project_Timer
//
//  Created by Min_MacBook Pro on 2020/06/08.
//  Copyright © 2020 FDEE. All rights reserved.
//

//  간단한 타이머 어플 코드입니다
//  1초마다 updateCounter() 실행되며 목표시간인 AllTime은 -1, 누적시간인 sum은 +1, 타이머 시간인 second는 -1됩니다
//  시간이 변경됨과 동시에 저장이 이루어 져 어플을 나갔다 와도 정보가 남아있습니다
//  시작, 정지 버튼과 더불어 타이머시간을 재설정하는 ResetButton, 목표시간과 누적시간을 초기화하는 RESETButton,
//  새로운 목표시간과 타이머 시간을 설정하는 TimeSETButton 이 있습니다
//  setViewController 에서 목표시간과 타이머 시간을 설정할 수 있습니다
//  그외 기능들은 화면색 변경, 소리알림, 시간으로 표시하는 기타기능들 입니다

//  *** 혹시 코드를 수정시에 절때 지우시지 말고 주석으로 지우고, 새로 수정시 주석을 남기시기 바랍니다 ***
//  Copyright © 2020 FDEE.

import UIKit


import AudioToolbox
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet var AllTimeLabel: UILabel!
    @IBOutlet var SumTimeLabel: UILabel!
    @IBOutlet var CountTimeLabel: UILabel!
    @IBOutlet var StartButton: UIButton!
    @IBOutlet var StopButton: UIButton!
    @IBOutlet var ResetButton: UIButton!
    @IBOutlet var RESETButton: UIButton!
    @IBOutlet var TimeSETButton: UIButton!
    @IBOutlet var persentLabel: UILabel!
    @IBOutlet var LogButton: UIButton!
    //종료예정시간 추가
    @IBOutlet var Label_to: UILabel!
    @IBOutlet var Label_toTime: UILabel!
    //사라지기 애니메이션 추가
    @IBOutlet var View_labels: UIView!
    
    
    @IBOutlet var CircleView: CircularProgressView!
    var audioPlayer : AVPlayer!
    
    var timeTrigger = true
    var realTime = Timer()
    
    var second : Int = 0
    var sum : Int = 0
    var allTime : Int = 0
    
    let BACKGROUND = UIColor(named: "Background")
    let BLUE = UIColor(named: "Blue")
    let BUTTON = UIColor(named: "Button")
    let CLICK = UIColor(named: "Click")
    let TEXT = UIColor(named: "Text")
    
    var diffHrs = 0
    var diffMins = 0
    var diffSecs = 0
    
    var isStop = true
    
    //퍼센트 추가!
    var isRESET = false
    var timeForPersent = 0
    
    //프로그래스 퍼센트 추가!
    var progressPer: Float = 0.0
    var fixedSecond: Int = 0
    var fromSecond: Float = 0.0
    
    //빡공률 보이기 설정
    var showPersent: Int = 0
    //날짜 저장
    var array_day = [String](repeating: "", count: 7)
    var array_time = [String](repeating: "", count: 7)
    //스탑회수 저장
    var stopCount: Int = 0
    
    override func viewDidLoad() {
        
        StartButton.layer.cornerRadius = 10
        StopButton.layer.cornerRadius = 10
        ResetButton.layer.cornerRadius = 10

        sum = UserDefaults.standard.value(forKey: "sum2") as? Int ?? 0
        allTime = UserDefaults.standard.value(forKey: "allTime2") as? Int ?? 21600
        second = UserDefaults.standard.value(forKey: "second2") as? Int ?? 2400
        showPersent = UserDefaults.standard.value(forKey: "showPersent") as? Int ?? 0
        stopCount = UserDefaults.standard.value(forKey: "stopCount") as? Int ?? 0

        AllTimeLabel.text = printTime(temp: allTime)
        CountTimeLabel.text = printTime(temp: second)
        SumTimeLabel.text = printTime(temp: sum)
        
        stopColor()
        stopEnable()
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(pauseWhenBackground(noti:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(noti:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        if (UserDefaults.standard.object(forKey: "startTime") == nil)
        {
            isRESET = true
        }
        if(showPersent == 0)
        {
            persentLabel.alpha = 1
            if(stopCount != 0)
            {
                checkPersent()
            }
            else
            {
                persentLabel.text = "STOP : " + String(stopCount) + "\nAVER : 0:00:00"
            }
            persentLabel.textColor = UIColor.white
        }
        else
        {
            persentLabel.alpha = 0
        }
        
        //프로그래스 추가
        CircleView.trackColor = UIColor.darkGray
        fixedSecond = UserDefaults.standard.value(forKey: "second") as? Int ?? 2400
        
        progressPer = Float(fixedSecond - second) / Float(fixedSecond)
        fromSecond = progressPer
        CircleView.setProgressWithAnimation(duration: 1.0, value: progressPer, from: 0.0)
        //종료예상시간 보이기
        Label_toTime.text = getFutureTime()
    }
    
    @IBAction func StartButtonAction(_ sender: UIButton) {
        //persent 추가! RESET 후 시작시 시작하는 시간 저장!
        if(isRESET)
        {
            let startTime = UserDefaults.standard
            startTime.set(Date(), forKey: "startTime")
            print("startTime SAVE")
            isRESET = false
            fixedSecond = UserDefaults.standard.value(forKey: "second") as? Int ?? 2400
            //log 추가
            setLogData()
        }
        startColor()
        startAction()
        isStop = false
    }
    
    @IBAction func StopButtonAction(_ sender: UIButton) {
        isStop = true
        endGame()
        stopColor()
        stopEnable()
    }
    
    @IBAction func ResetButtonAction(_ sender: UIButton) {
        ResetButton.backgroundColor = CLICK
        ResetButton.setTitleColor(UIColor.white, for: .normal)
        ResetButton.isUserInteractionEnabled = false
        
        isStop = true
        second = UserDefaults.standard.value(forKey: "second") as? Int ?? 2400
        print("reset Button complite")
        CountTimeLabel.text = printTime(temp: second)
        SumTimeLabel.text = printTime(temp: sum)
        print("print Time complite")
        
        //프로그래스 추가!
        CircleView.setProgressWithAnimation(duration: 1.0, value: 0.0, from: fromSecond)
        fromSecond = 0.0
        //종료예상시간 보이기
        Label_toTime.text = getFutureTime()
    }
    @IBAction func Reset(_ sender: UIButton) {
        //경고창 추가
        let alert = UIAlertController(title:"RESET 하시겠습니까?",message: "누적시간이 초기화되며 새로운 기록이 시작됩니다!",preferredStyle: UIAlertController.Style.alert)
        let cancel = UIAlertAction(title: "CANCEL", style: .destructive, handler: nil)
        let okAction = UIAlertAction(title: "RESET", style: .default, handler:
                                        {
                                            action in
                                            self.RESET_action()
                                        })
        alert.addAction(cancel)
        alert.addAction(okAction)
        present(alert,animated: true,completion: nil)
    }
    
    @IBAction func TimeSetButton(_ sender: UIButton) {
        let setVC = storyboard?.instantiateViewController(withIdentifier: "SetViewController") as! SetViewController
            setVC.setViewControllerDelegate = self
            present(setVC,animated: true,completion: nil)
    }
    
    
    @objc func updateCounter(){
        if second < 61 {
            CountTimeLabel.textColor = TEXT
            CircleView.progressColor = TEXT!
        }
        if second < 1 {
            endGame()
            stopColor()
            stopEnable()
            CountTimeLabel.text = "종료"
//            AudioServicesPlaySystemSound(1254)
            //오디오 재생 추가
            playAudioFromProject()
            AudioServicesPlaySystemSound(4095)
        }
        else {
            second = second - 1
            sum = sum + 1
            allTime = allTime - 1
            setPerSeconds()
        }
        
    }
    
    func checkTimeTrigger() {
        realTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        timeTrigger = false
    }
    
    func endGame() {
        isStop = true
        realTime.invalidate()
        timeTrigger = true
        //log 저장
        saveLogData()
        //stopCount 증가
        stopCount+=1
        UserDefaults.standard.set(stopCount, forKey: "stopCount")
        checkPersent()
        //종료예상시간 보이기
        Label_toTime.text = getFutureTime()
    }
    
    func printTime(temp : Int) -> String
    {
        var returnString = "";
        var num = temp;
        if(num < 0)
        {
            num = -num;
            returnString += "+";
        }
        let S = num%60
        let H = num/3600
        let M = num/60 - H*60
        
        let stringS = S<10 ? "0"+String(S) : String(S)
        let stringM = M<10 ? "0"+String(M) : String(M)
        
        returnString += String(H) + ":" + stringM + ":" + stringS
        return returnString
    }
    
    //클래스 불러오는 메소드 영역
    func getTimeData(){
        second = UserDefaults.standard.value(forKey: "second") as? Int ?? 2400
        print("second set complite")
        allTime = UserDefaults.standard.value(forKey: "allTime") as? Int ?? 21600
        print("allTime set complite")
        //빡공률 보이기 설정
        showPersent = UserDefaults.standard.value(forKey: "showPersent") as? Int ?? 0
    }
    
    
}

extension ViewController : ChangeViewController {
    
    func updateViewController() {
        stopColor()
        stopEnable()
        ResetButton.backgroundColor = CLICK
        ResetButton.setTitleColor(UIColor.white, for: .normal)
        ResetButton.isUserInteractionEnabled = false
        
        endGame()
        getTimeData()
        sum = 0
        timeTrigger = true
        realTime = Timer()
        print("reset Button complite")
        
        UserDefaults.standard.set(second, forKey: "second2")
        UserDefaults.standard.set(allTime, forKey: "allTime2")
        UserDefaults.standard.set(sum, forKey: "sum2")
        //정지 회수 저장
        stopCount = 0
        UserDefaults.standard.set(0, forKey: "stopCount")
        persentLabel.text = "STOP : " + String(stopCount) + "\nAVER : 0:00:00"
        
        AllTimeLabel.text = printTime(temp: allTime)
        SumTimeLabel.text = printTime(temp: sum)
        CountTimeLabel.text = printTime(temp: second)
        
        persentReset()
        //빡공률 보이기 설정
        if(showPersent == 0)
        {
            persentLabel.alpha = 1
        }
        else
        {
            persentLabel.alpha = 0
        }
        //종료 예상시간 보이기
        Label_toTime.text = getFutureTime()
    }
    
    // Selected for Lifecycle Methods
        @objc func pauseWhenBackground(noti: Notification) {
            print("background")
            if(!isStop)
            {
                realTime.invalidate()
                timeTrigger = true
                let shared = UserDefaults.standard
                shared.set(Date(), forKey: "savedTime")
            }
        }
    
    @objc func willEnterForeground(noti: Notification) {
        print("Enter")
        if(!isStop)
        {
            if let savedDate = UserDefaults.standard.object(forKey: "savedTime") as? Date {
                (diffHrs, diffMins, diffSecs) = ViewController.getTimeDifference(startDate: savedDate)
                refresh(hours: diffHrs, mins: diffMins, secs: diffSecs)
                removeSavedDate()
            }
        }
        //백그라운드 진입시 다시 최신화 설정
        Label_toTime.text = getFutureTime()
    }
    
    static func getTimeDifference(startDate: Date) -> (Int, Int, Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: startDate, to: Date())
        return(components.hour!, components.minute!, components.second!)
    }
    
    func refresh (hours: Int, mins: Int, secs: Int) {
        let tempSeconds = hours*3600 + mins*60 + secs
        let temp = second-tempSeconds;
        
        if(second - tempSeconds < 0)
        {
            allTime = allTime - tempSeconds
            sum = sum + tempSeconds
            second = 0
        }
        else
        {
            allTime = allTime - tempSeconds
            sum = sum + tempSeconds
            second = second - tempSeconds
        }
        setPerSeconds()
        startAction()
        if(second - tempSeconds < 0)
        {
            CountTimeLabel.text = printTime(temp: temp)
        }
    }
    
    func removeSavedDate() {
        if (UserDefaults.standard.object(forKey: "savedTime") as? Date) != nil {
            UserDefaults.standard.removeObject(forKey: "savedTime")
        }
    }
    
    func startAction()
    {
        if timeTrigger { checkTimeTrigger() }
        startEnable()
        print("Start")
    }
    
    func setPerSeconds()
    {
        AllTimeLabel.text = printTime(temp: allTime)
        SumTimeLabel.text = printTime(temp: sum)
        CountTimeLabel.text = printTime(temp: second)
        print("update : " + String(second))
        UserDefaults.standard.set(sum, forKey: "sum2")
        UserDefaults.standard.set(second, forKey: "second2")
        UserDefaults.standard.set(allTime, forKey: "allTime2")
        
        //persent 추가!
//        checkPersent()
        //프로그래스 추가!
        progressPer = Float(fixedSecond - second) / Float(fixedSecond)
        print("fixedSecond : " + String(fixedSecond))
        print("second : " + String(second))
        CircleView.setProgressWithAnimation(duration: 0.0, value: progressPer, from: fromSecond)
        fromSecond = progressPer
    }
    
    func persentReset()
    {
        isRESET = true
//        persentLabel.text = "빡공률 : 0.0%"
        persentLabel.textColor = UIColor.white
        //프로그래스 추가!
        fixedSecond = UserDefaults.standard.value(forKey: "second") as? Int ?? 2400
        CircleView.setProgressWithAnimation(duration: 1.0, value: 0.0, from: fromSecond)
        fromSecond = 0.0
    }
    
    //빡공률 -> 종료회수, 평균시간 보이기로 변경
    func checkPersent()
    {
//        if let startTime = UserDefaults.standard.object(forKey: "startTime") as? Date {
//            (diffHrs, diffMins, diffSecs) = ViewController.getTimeDifference(startDate: startTime)
//            timeForPersent = diffHrs*3600 + diffMins*60 + diffSecs
//            print("timeForPersent : " + String(timeForPersent))
//
//            //계산부분
//            let per : Double = Double(sum)/Double(timeForPersent)*100
//            persentLabel.text = "빡공률 : " + String(format: "%.1f", per) + "%"
//
//            if (per>50.0)
//            {
//                persentLabel.textColor = UIColor.white
//            }
//            else
//            {
//                persentLabel.textColor = TEXT
//            }
//        }
        //정지회수 보이기
        var print = "STOP : " + String(stopCount)
        let aver = (Int)(sum/stopCount)
        print += "\nAVER : " + printTime(temp: aver)
        //정지회수, 평균 시간 보이기
        persentLabel.text = print
    }
    
    func stopColor()
    {
        self.view.backgroundColor = BACKGROUND
        CircleView.progressColor = UIColor.white
        StartButton.backgroundColor = BUTTON
        StopButton.backgroundColor = CLICK
        ResetButton.backgroundColor = BUTTON
        StartButton.setTitleColor(BLUE, for: .normal)
        StopButton.setTitleColor(UIColor.white, for: .normal)
        ResetButton.setTitleColor(BLUE, for: .normal)
        CountTimeLabel.textColor = UIColor.white
        //예상종료시간 보이기, stop 버튼 제자리로 이동
        UIView.animate(withDuration: 0.3, animations: {
            self.Label_to.alpha = 1
            self.Label_toTime.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        //animation test
        UIView.animate(withDuration: 0.5, animations: {
            self.StartButton.alpha = 1
            self.ResetButton.alpha = 1
            self.RESETButton.alpha = 1
            self.TimeSETButton.alpha = 1
            self.LogButton.alpha = 1
            self.View_labels.alpha = 1
        })
        //보이기 숨기기 설정
        if(showPersent == 0)
        {
            UIView.animate(withDuration: 0.5, animations: {
                self.persentLabel.alpha = 1
            })
        }
    }
    
    func startColor()
    {
        self.view.backgroundColor = UIColor.black
        CircleView.progressColor = BLUE!
        StartButton.backgroundColor = CLICK
        StopButton.backgroundColor = UIColor.clear
        ResetButton.backgroundColor = CLICK
        StartButton.setTitleColor(UIColor.white, for: .normal)
        StopButton.setTitleColor(UIColor.white, for: .normal)
        ResetButton.setTitleColor(UIColor.white, for: .normal)
        CountTimeLabel.textColor = BLUE
        //예상종료시간 숨기기, stop 버튼 센터로 이동
        UIView.animate(withDuration: 0.3, animations: {
            self.Label_to.alpha = 0
            self.Label_toTime.transform = CGAffineTransform(translationX: 0, y: -15)
            self.StartButton.alpha = 0
            self.ResetButton.alpha = 0
            self.RESETButton.alpha = 0
            self.TimeSETButton.alpha = 0
            self.LogButton.alpha = 0
            self.View_labels.alpha = 0
            self.persentLabel.alpha = 0
        })
    }
    
    func stopEnable()
    {
        StartButton.isUserInteractionEnabled = true
        ResetButton.isUserInteractionEnabled = true
        StopButton.isUserInteractionEnabled = false
        RESETButton.isUserInteractionEnabled = true
        TimeSETButton.isUserInteractionEnabled = true
        LogButton.isUserInteractionEnabled = true
    }
    
    func startEnable()
    {
        StartButton.isUserInteractionEnabled = false
        ResetButton.isUserInteractionEnabled = false
        StopButton.isUserInteractionEnabled = true
        RESETButton.isUserInteractionEnabled = false
        TimeSETButton.isUserInteractionEnabled = false
        LogButton.isUserInteractionEnabled = false
    }
    
    func saveLogData()
    {
        //log 시간 저장
        UserDefaults.standard.set(printTime(temp: sum), forKey: "time1")
    }
    
    func setLogData()
    {
        //값 불러오기
        for i in stride(from: 0, to: 7, by: 1)
        {
            array_day[i] = UserDefaults.standard.value(forKey: "day"+String(i+1)) as? String ?? "NO DATA"
            array_time[i] = UserDefaults.standard.value(forKey: "time"+String(i+1)) as? String ?? "NO DATA"
        }
        //값 옮기기, 값 저장하기
        for i in stride(from: 6, to: 0, by: -1)
        {
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
    
    //예정종료시간 구하기
    func getFutureTime() -> String
    {
        //log 날짜 설정
        let now = Date()
        let future = now.addingTimeInterval(TimeInterval(second))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let today = dateFormatter.string(from: future)
        return today
    }
    
    func RESET_action()
    {
        ResetButton.backgroundColor = CLICK
        ResetButton.setTitleColor(UIColor.white, for: .normal)
        ResetButton.isUserInteractionEnabled = false
        
        isStop = true
        endGame()
        getTimeData()
        sum = 0
        timeTrigger = true
        realTime = Timer()
        print("reset Button complite")
        
        UserDefaults.standard.set(second, forKey: "second2")
        UserDefaults.standard.set(allTime, forKey: "allTime2")
        UserDefaults.standard.set(sum, forKey: "sum2")
        //정지 회수 저장
        stopCount = 0
        UserDefaults.standard.set(0, forKey: "stopCount")
        persentLabel.text = "STOP : " + String(stopCount) + "\nAVER : 0:00:00"
        
        AllTimeLabel.text = printTime(temp: allTime)
        SumTimeLabel.text = printTime(temp: sum)
        CountTimeLabel.text = printTime(temp: second)
        
        //persent 추가! RESET 여부 추가
        persentReset()
        //예상종료시간 보이기
        Label_toTime.text = getFutureTime()
    }

}

