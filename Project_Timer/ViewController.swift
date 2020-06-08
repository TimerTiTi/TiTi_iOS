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
    var second : Double = 3000
    var sum : Double = 1
    var allTime : Double = 28800
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
        if (ifReset) {
            sum = sum + 1
            allTime = allTime - 1
            ifReset = false
        }
        if timeTrigger { checkTimeTrigger() }
    }
    @IBAction func StopButtonAction(_ sender: UIButton) {
        endGame()
        AllTileLabel.text = printTime(temp: allTime)
        SumTimeLabel.text = printTime(temp: sum)
        CountTimeLabel.text = printTime(temp: second)
    }
    @IBAction func ResetButtonAction(_ sender: UIButton) {
        second = 3000
        CountTimeLabel.text = String(3000)
        ifReset = true
    }
    @IBAction func Reset(_ sender: UIButton) {
        endGame()
        timeTrigger = true
        realTime = Timer()
        second = 3000
        sum = 1
        allTime = 28800
        IntSecond = 0
        ifReset = false
        
        AllTileLabel.text = "28800"
        SumTimeLabel.text = "0"
        CountTimeLabel.text = "3000"
    }
    
    @objc func updateCounter(){
    //        if String(format: "%.2f",second) == "0.00"{
            if second < 0.99 {
                endGame()
                CountTimeLabel.text = "종료"
                //시간제한이 끝났을때 일어날 일(세그웨이로 실패한 페이지 혹은 팝업을 띄운다.)
            } else {
                second = second - 0.01
                sum = sum + 0.01
                allTime = allTime - 0.01
                CountTimeLabel.text = String(Int(second))
                SumTimeLabel.text = String(Int(sum))
                AllTileLabel.text = String(Int(allTime))
            }
        }
    
    func checkTimeTrigger() {
        realTime = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        timeTrigger = false
    }
    
    func endGame() {
        realTime.invalidate()
        timeTrigger = true
    }
    
    func printTime(temp : Double) -> String
    {
        let S = Int(temp)%60
        let H = Int(temp)/3600
        let M = Int(temp)/60 - H*60
        
        let returnString = String(H) + ":" + String(M) + ":" + String(S)
        return returnString
    }
}

