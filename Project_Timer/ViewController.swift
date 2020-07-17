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

    @IBOutlet var CircleView: CircularProgressView!
    var audioPlayer = AVAudioPlayer()
    
    
    var timeTrigger = true
    var realTime = Timer()
    
    var second : Int = 0
    var sum : Int = 0
    var allTime : Int = 0
    
    let BROWN = UIColor(named: "Brown")
    let BUTTON = UIColor(named: "Button")
    let STOP = UIColor(named: "Stop")
    let TEXT = UIColor(named: "Text")
    let BABYRED = UIColor(named: "Text")
    
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
    
    override func viewDidLoad() {
        StartButton.layer.cornerRadius = 10
        StopButton.layer.cornerRadius = 10
        ResetButton.layer.cornerRadius = 10

        sum = UserDefaults.standard.value(forKey: "sum2") as? Int ?? 0
        allTime = UserDefaults.standard.value(forKey: "allTime2") as? Int ?? 28800
        second = UserDefaults.standard.value(forKey: "second2") as? Int ?? 3000

        AllTimeLabel.text = printTime(temp: allTime)
        CountTimeLabel.text = printTime(temp: second)
        SumTimeLabel.text = printTime(temp: sum)
        
        self.view.backgroundColor = STOP
        StartButton.backgroundColor = BUTTON
        ResetButton.backgroundColor = BUTTON
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(pauseWhenBackground(noti:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(noti:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        if (UserDefaults.standard.object(forKey: "startTime") == nil)
        {
            isRESET = true
        }
        checkPersent()
        persentLabel.textColor = UIColor.white
        
        //프로그래스 추가
        CircleView.trackColor = UIColor.darkGray
        CircleView.progressColor = BABYRED!
        fixedSecond = UserDefaults.standard.value(forKey: "second") as? Int ?? 3000
        
        progressPer = Float(fixedSecond - second) / Float(fixedSecond)
        fromSecond = progressPer
        CircleView.setProgressWithAnimation(duration: 1.0, value: progressPer, from: 0.0)
    }
    
    @IBAction func StartButtonAction(_ sender: UIButton) {
        //persent 추가! RESET 후 시작시 시작하는 시간 저장!
        if(isRESET)
        {
            let startTime = UserDefaults.standard
            startTime.set(Date(), forKey: "startTime")
            print("startTime SAVE")
            isRESET = false
            fixedSecond = UserDefaults.standard.value(forKey: "second") as? Int ?? 3000
        }
        
        startAction()
        isStop = false
    }
    
    @IBAction func StopButtonAction(_ sender: UIButton) {
        isStop = true
        endGame()
        StopButton.backgroundColor = BROWN
        StartButton.backgroundColor = BUTTON
        ResetButton.backgroundColor = BUTTON
        
        StartButton.isUserInteractionEnabled = true
        ResetButton.isUserInteractionEnabled = true
        StopButton.isUserInteractionEnabled = false
        
        RESETButton.isUserInteractionEnabled = true
        TimeSETButton.isUserInteractionEnabled = true
    }
    
    @IBAction func ResetButtonAction(_ sender: UIButton) {
        isStop = true
        second = UserDefaults.standard.value(forKey: "second") as? Int ?? 3000
        print("reset Button complite")
        StartButton.backgroundColor = BUTTON
        ResetButton.backgroundColor = BROWN
        CountTimeLabel.text = printTime(temp: second)
        SumTimeLabel.text = printTime(temp: sum)
        print("print Time complite")
        StartButton.isUserInteractionEnabled = true
        ResetButton.isUserInteractionEnabled = false
        StopButton.isUserInteractionEnabled = false
        //프로그래스 추가!
        CircleView.setProgressWithAnimation(duration: 1.0, value: 0.0, from: fromSecond)
        fromSecond = 0.0
    }
    @IBAction func Reset(_ sender: UIButton) {
        isStop = true
        endGame()
        getTimeData()
        sum = 0
        ResetButton.backgroundColor = BROWN
        timeTrigger = true
        realTime = Timer()
        print("reset Button complite")
        
        UserDefaults.standard.set(second, forKey: "second2")
        UserDefaults.standard.set(allTime, forKey: "allTime2")
        UserDefaults.standard.set(sum, forKey: "sum2")
        
        AllTimeLabel.text = printTime(temp: allTime)
        SumTimeLabel.text = printTime(temp: sum)
        CountTimeLabel.text = printTime(temp: second)
        
        StartButton.backgroundColor = BUTTON
        StartButton.isUserInteractionEnabled = true
        ResetButton.backgroundColor = BROWN
        ResetButton.isUserInteractionEnabled = false
        
        //persent 추가! RESET 여부 추가
        persentReset()
    }
    
    @IBAction func TimeSetButton(_ sender: UIButton) {
        let setVC = storyboard?.instantiateViewController(withIdentifier: "SetViewController") as! SetViewController
            setVC.setViewControllerDelegate = self
            present(setVC,animated: true,completion: nil)
        persentReset()
    }
    
    
    @objc func updateCounter(){
        if second < 1 {
            self.view.backgroundColor = STOP
            endGame()
            CountTimeLabel.text = "종료"
            StopButton.backgroundColor = BROWN
            StartButton.backgroundColor = BROWN
            ResetButton.backgroundColor = BUTTON
            
            StartButton.isUserInteractionEnabled = false
            ResetButton.isUserInteractionEnabled = true
            StopButton.isUserInteractionEnabled = false
            
            RESETButton.isUserInteractionEnabled = true
            TimeSETButton.isUserInteractionEnabled = true
            
            AudioServicesPlaySystemSound(1254)
            AudioServicesPlaySystemSound(4095)
//            let music = Bundle.main.path(forResource: "timer end sound", ofType: "wav")
//            do {
//                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: music!))
//            } catch {
//
//            }
        }
        else if allTime < 1 {
            endGame()
            CountTimeLabel.text = "종료"
            StopButton.backgroundColor = BROWN
            StartButton.backgroundColor = BROWN
            ResetButton.backgroundColor = BUTTON
            
            StartButton.isUserInteractionEnabled = false
            ResetButton.isUserInteractionEnabled = true
            StopButton.isUserInteractionEnabled = false
            
            RESETButton.isUserInteractionEnabled = true
            TimeSETButton.isUserInteractionEnabled = true
            
            AudioServicesPlaySystemSound(1254)
            AudioServicesPlaySystemSound(4095)
//            let music = Bundle.main.path(forResource: "timer end sound", ofType: "wav")
//            do {
//                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: music!))
//            } catch {
//
//            }
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
        self.view.backgroundColor = STOP
        realTime.invalidate()
        timeTrigger = true
    }
    
    func printTime(temp : Int) -> String
    {
        let S = temp%60
        let H = temp/3600
        let M = temp/60 - H*60
        
        let stringS = S<10 ? "0"+String(S) : String(S)
        let stringM = M<10 ? "0"+String(M) : String(M)
        
        let returnString  = String(H) + ":" + stringM + ":" + stringS
        return returnString
    }
    
    //클래스 불러오는 메소드 영역
    func getTimeData(){
        second = UserDefaults.standard.value(forKey: "second") as? Int ?? 3000
        print("second set complite")
        allTime = UserDefaults.standard.value(forKey: "allTime") as? Int ?? 28800
        print("allTime set complite")
    }
    
}

extension ViewController : ChangeViewController {
    
    func updateViewController() {
         endGame()
         getTimeData()
         sum = 0
         ResetButton.backgroundColor = BROWN
         timeTrigger = true
         realTime = Timer()
         print("reset Button complite")
         
         UserDefaults.standard.set(second, forKey: "second2")
         UserDefaults.standard.set(allTime, forKey: "allTime2")
         UserDefaults.standard.set(sum, forKey: "sum2")
         
         AllTimeLabel.text = printTime(temp: allTime)
         SumTimeLabel.text = printTime(temp: sum)
         CountTimeLabel.text = printTime(temp: second)
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
    }
    
    static func getTimeDifference(startDate: Date) -> (Int, Int, Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: startDate, to: Date())
        return(components.hour!, components.minute!, components.second!)
    }
    
    func refresh (hours: Int, mins: Int, secs: Int) {
        let tempSeconds = hours*3600 + mins*60 + secs
        if(second - tempSeconds < 0)
        {
            allTime = allTime - second
            sum = sum + second
            second = 0
        }
        else if(allTime - tempSeconds < 0)
        {
            allTime = 0
            sum = sum + allTime
            second = second - allTime
        }
        else
        {
            allTime = allTime - tempSeconds
            sum = sum + tempSeconds
            second = second - tempSeconds
        }
        setPerSeconds()
        startAction()
    }
    
    func removeSavedDate() {
        if (UserDefaults.standard.object(forKey: "savedTime") as? Date) != nil {
            UserDefaults.standard.removeObject(forKey: "savedTime")
        }
    }
    
    func startAction()
    {
        if timeTrigger { checkTimeTrigger() }
        print("Start")
        StartButton.backgroundColor = BROWN
        StopButton.backgroundColor = BUTTON
        ResetButton.backgroundColor = BROWN
        
        StartButton.isUserInteractionEnabled = false
        ResetButton.isUserInteractionEnabled = false
        StopButton.isUserInteractionEnabled = true
        
        RESETButton.isUserInteractionEnabled = false
        TimeSETButton.isUserInteractionEnabled = false
        self.view.backgroundColor = UIColor.black
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
        checkPersent()
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
        persentLabel.text = "빡공률 : 0.0%"
        persentLabel.textColor = UIColor.white
        //프로그래스 추가!
        fixedSecond = UserDefaults.standard.value(forKey: "second") as? Int ?? 3000
        CircleView.setProgressWithAnimation(duration: 1.0, value: 0.0, from: fromSecond)
        fromSecond = 0.0
    }
    
    func checkPersent()
    {
        if let startTime = UserDefaults.standard.object(forKey: "startTime") as? Date {
            (diffHrs, diffMins, diffSecs) = ViewController.getTimeDifference(startDate: startTime)
            timeForPersent = diffHrs*3600 + diffMins*60 + diffSecs
            print("timeForPersent : " + String(timeForPersent))
            
            //계산부분
            let per : Double = Double(sum)/Double(timeForPersent)*100
            persentLabel.text = "빡공률 : " + String(format: "%.1f", per) + "%"
            
            if (per>50.0)
            {
                persentLabel.textColor = UIColor.white
            }
            else
            {
                persentLabel.textColor = TEXT
            }
        }
    }
    
//    @objc func animateProgress() {
//        let cP = self.view.viewWithTag(101) as! CircularProgressView
//        cP.setProgressWithAnimation(duration: 1.0, value: 0.7)
//    }

}

