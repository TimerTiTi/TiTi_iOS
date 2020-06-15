//
//  ViewController.swift
//  Project_Timer
//
//  Created by Min_MacBook Pro on 2020/06/08.
//  Copyright © 2020 FDEE. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var AllTileLabel: UILabel!
    @IBOutlet var SumTimeLabel: UILabel!
    @IBOutlet var CountTimeLabel: UILabel!
    @IBOutlet var StartButton: UIButton!
    @IBOutlet var StopButton: UIButton!
    @IBOutlet var ResetButton: UIButton!
    
    var timeTrigger = true
    var realTime = Timer()
    var second : Int = 0
    var sum : Int = 0
    var allTime : Int = 0
    var IntSecond : Int = 0
    var ifReset = false
    var data = TimeData()
    
    override func viewDidLoad() {
        
        StartButton.layer.cornerRadius = 10
        StopButton.layer.cornerRadius = 10
        ResetButton.layer.cornerRadius = 10

        sum = UserDefaults.standard.value(forKey: "sum2") as? Int ?? 0
        allTime = UserDefaults.standard.value(forKey: "allTime2") as? Int ?? 28800
        second = UserDefaults.standard.value(forKey: "second2") as? Int ?? 3000

        AllTileLabel.text = printTime(temp: allTime)
        CountTimeLabel.text = printTime(temp: second)
        SumTimeLabel.text = printTime(temp: sum)
        
        super.viewDidLoad()
    }
    
    @IBAction func StartButtonAction(_ sender: UIButton) {
        if timeTrigger { checkTimeTrigger() }
        print("Start")
    }
    @IBAction func StopButtonAction(_ sender: UIButton) {
        endGame()
    }
    @IBAction func ResetButtonAction(_ sender: UIButton) {
//        getTimeData() //data가 최신화
//        print("reset Button complite")
        second = UserDefaults.standard.value(forKey: "second") as? Int ?? 3000
        CountTimeLabel.text = printTime(temp: second)
        SumTimeLabel.text = printTime(temp: sum)
//        AllTileLabel.text = printTime(temp: allTime)
        print("print Time complite")
        ifReset = true
    }
    @IBAction func Reset(_ sender: UIButton) {
        endGame()
        timeTrigger = true
        realTime = Timer()
//        getTimeData() //data가 최신화
        print("reset Button complite")
        second = UserDefaults.standard.value(forKey: "second") as? Int ?? 3000
        sum = UserDefaults.standard.value(forKey: "sum") as? Int ?? 0
        allTime = UserDefaults.standard.value(forKey: "allTime") as? Int ?? 28800
        
        UserDefaults.standard.set(second, forKey: "second2")
        UserDefaults.standard.set(allTime, forKey: "allTime2")
        UserDefaults.standard.set(sum, forKey: "sum2")
        
        IntSecond = 0
        ifReset = false
        
        AllTileLabel.text = printTime(temp: allTime)
        SumTimeLabel.text = printTime(temp: sum)
        CountTimeLabel.text = printTime(temp: second)
    }
    
    @IBAction func TimeSetButton(_ sender: UIButton) {
        AllTileLabel.text = "-"
        SumTimeLabel.text = "-"
        CountTimeLabel.text = "Click RESET"
    }
    
    
    @objc func updateCounter(){
    //        if String(format: "%.2f",second) == "0.00"{
            if second < 1 {
                endGame()
                CountTimeLabel.text = "종료"
                //시간제한이 끝났을때 일어날 일(세그웨이로 실패한 페이지 혹은 팝업을 띄운다.)
            } else if allTime < 1{
                endGame()
                CountTimeLabel.text = "종료"
            }
            else {
                second = second - 1
                sum = sum + 1
                allTime = allTime - 1
                AllTileLabel.text = printTime(temp: allTime)
                SumTimeLabel.text = printTime(temp: sum)
                CountTimeLabel.text = printTime(temp: second)
                print("update")
                UserDefaults.standard.set(sum, forKey: "sum2")
                UserDefaults.standard.set(second, forKey: "second2")
                UserDefaults.standard.set(allTime, forKey: "allTime2")
            }
        }
    
    func checkTimeTrigger() {
        realTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        timeTrigger = false
    }
    
    func endGame() {
        realTime.invalidate()
        timeTrigger = true
    }
    
    func printTime(temp : Int) -> String
    {
        let S = temp%60
        let H = temp/3600
        let M = temp/60 - H*60
        
        let stringS = S<10 ? "0"+String(S) : String(S)
//        let stringH = H<10 ? "0"+String(H) : String(H)
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

