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
    var second : Int = 3000
    var sum : Int = 14400
    var allTime : Int = 14400
    var IntSecond : Int = 0
    var ifReset = false
    
    override func viewDidLoad() {
        
        StartButton.layer.cornerRadius = 10
        StopButton.layer.cornerRadius = 10
        ResetButton.layer.cornerRadius = 10
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func StartButtonAction(_ sender: UIButton) {
        if timeTrigger { checkTimeTrigger() }
        print("Start")
    }
    @IBAction func StopButtonAction(_ sender: UIButton) {
        endGame()
    }
    @IBAction func ResetButtonAction(_ sender: UIButton) {
        second = 3000
        CountTimeLabel.text = "0:50:00"
        ifReset = true
    }
    @IBAction func Reset(_ sender: UIButton) {
        endGame()
        timeTrigger = true
        realTime = Timer()
        second = 3000
        sum = 14400
        allTime = 14400
        IntSecond = 0
        ifReset = false
        
        AllTileLabel.text = "8:00:00"
        SumTimeLabel.text = "0:0:0"
        CountTimeLabel.text = "0:50:00"
    }
    
    @objc func updateCounter(){
    //        if String(format: "%.2f",second) == "0.00"{
            if second < 1 {
                endGame()
                CountTimeLabel.text = "종료"
                //시간제한이 끝났을때 일어날 일(세그웨이로 실패한 페이지 혹은 팝업을 띄운다.)
            } else {
                second = second - 1
                sum = sum + 1
                allTime = allTime - 1
                AllTileLabel.text = printTime(temp: allTime)
                SumTimeLabel.text = printTime(temp: sum)
                CountTimeLabel.text = printTime(temp: second)
                print("update")
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
        
        let returnString = String(H) + ":" + String(M) + ":" + String(S)
        return returnString
    }
    
    //클래스 불러오는 메소드 영역
    func getTimeData() {
//        second = TimeData.getSecond.init()
        
    }
    
}

