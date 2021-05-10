//
//  GraphViewController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/02/23.
//  Copyright © 2021 FDEE. All rights reserved.
//

import UIKit
import SwiftUI

class GraphViewController2: UIViewController {

    @IBOutlet var viewOfView: UIView!
    
    @IBOutlet var progress: UIView!
    @IBOutlet var sumTime: UILabel!
//    @IBOutlet var taskTitle: UILabel!
//    @IBOutlet var taskTime: UILabel!
    @IBOutlet var today: UILabel!
    
    @IBOutlet var time_05: UIView!
    @IBOutlet var time_06: UIView!
    @IBOutlet var time_07: UIView!
    @IBOutlet var time_08: UIView!
    @IBOutlet var time_09: UIView!
    @IBOutlet var time_10: UIView!
    @IBOutlet var time_11: UIView!
    @IBOutlet var time_12: UIView!
    @IBOutlet var time_13: UIView!
    @IBOutlet var time_14: UIView!
    @IBOutlet var time_15: UIView!
    @IBOutlet var time_16: UIView!
    @IBOutlet var time_17: UIView!
    @IBOutlet var time_18: UIView!
    @IBOutlet var time_19: UIView!
    @IBOutlet var time_20: UIView!
    @IBOutlet var time_21: UIView!
    @IBOutlet var time_22: UIView!
    @IBOutlet var time_23: UIView!
    @IBOutlet var time_24: UIView!
    @IBOutlet var time_01: UIView!
    @IBOutlet var time_02: UIView!
    @IBOutlet var time_03: UIView!
    @IBOutlet var time_04: UIView!
    
    var arrayTaskName: [String] = []
    var arrayTaskTime: [String] = []
    var colors: [UIColor] = []
    var fixed_sum: Int = 0
    let f = Float(0.003)
    var daily = Daily()
    var counts: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRadius()
        
        //7days
        let hostingController = UIHostingController(rootView: ContentView())
        hostingController.view.translatesAutoresizingMaskIntoConstraints = true
        hostingController.view.frame = viewOfView.bounds
        ContentView().appendDailyDatas()
//        ContentView().appendDumyDatas()
        addChild(hostingController)
        viewOfView.addSubview(hostingController.view)
        
        //today
        daily.load()
        fillHourColor()
        if(daily.tasks != [:]) {
            today.text = getDay(day: daily.day)
            let temp: [String:Int] = daily.tasks
//            let temp = addDumy()
            counts = temp.count
            appendColors()
            
            let tasks = temp.sorted(by: { $0.1 < $1.1 } )
            
            var array: [Int] = []
            for (key, value) in tasks {
                arrayTaskName.append(key)
                arrayTaskTime.append(printTime(temp: value))
                array.append(value)
            }
            
            let width = progress.bounds.width
            let height = progress.bounds.height
            makeProgress(array, width, height)
            var p1 = ""
            var p2 = ""
            for i in (0..<tasks.count).reversed() {
                p1 += "\(arrayTaskName[i])\n"
                p2 += "\(arrayTaskTime[i])\n"
            }
//            taskTitle.text = p1
//            taskTime.text = p2
            print("max : \(daily.maxTime)")
        } else {
            print("no data")
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        ContentView().reset()
    }
}

extension GraphViewController2 {
    
    func setRadius() {
        time_05.layer.cornerRadius = 3
        time_06.layer.cornerRadius = 3
        time_07.layer.cornerRadius = 3
        time_08.layer.cornerRadius = 3
        time_09.layer.cornerRadius = 3
        time_10.layer.cornerRadius = 3
        time_11.layer.cornerRadius = 3
        time_12.layer.cornerRadius = 3
        time_13.layer.cornerRadius = 3
        time_14.layer.cornerRadius = 3
        time_15.layer.cornerRadius = 3
        time_16.layer.cornerRadius = 3
        time_17.layer.cornerRadius = 3
        time_18.layer.cornerRadius = 3
        time_19.layer.cornerRadius = 3
        time_20.layer.cornerRadius = 3
        time_21.layer.cornerRadius = 3
        time_22.layer.cornerRadius = 3
        time_23.layer.cornerRadius = 3
        time_24.layer.cornerRadius = 3
        time_01.layer.cornerRadius = 3
        time_02.layer.cornerRadius = 3
        time_03.layer.cornerRadius = 3
        time_04.layer.cornerRadius = 3
    }
    
    func getDay(day: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d"
        return dateFormatter.string(from: day)
    }
    
    func appendColors() {
        var i = counts%12
        if(i == 0) {
            i = 12
        }
        for _ in 1...counts {
            colors.append(UIColor(named: "CCC\(i)")!)
            i -= 1
            if(i == 0) {
                i = 12
            }
        }
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
    
    func makeProgress(_ datas: [Int], _ width: CGFloat, _ height: CGFloat) {
        print(datas)
        fixed_sum = 0
        for i in 0..<counts {
            fixed_sum += datas[i]
        }
        var sum = Float(fixed_sum)
        sumTime.text = printTime(temp: fixed_sum)
//        breakLabel.text = printTime(temp: breakTime)
        
        //그래프 간 구별선 추가
        sum += f*Float(counts)
        
        var value: Float = 1
        value = addBlock(value: value, width: width, height: height)
        for i in 0..<counts {
            let prog = StaticCircularProgressView(frame: CGRect(x: 0, y: 0, width: width, height: height))
            prog.trackColor = UIColor.clear
            prog.progressColor = colors[i%colors.count]
            print(value)
            prog.setProgressWithAnimation(duration: 1, value: value, from: 0)
            
            let per = Float(datas[i])/Float(sum) //그래프 퍼센트
            value -= per
            
            progress.addSubview(prog)
            
            value = addBlock(value: value, width: width, height: height)
        }
        
    }
    
    func addBlock(value: Float, width: CGFloat, height: CGFloat) -> Float {
        var value = value
        let block = StaticCircularProgressView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        block.trackColor = UIColor.clear
        block.progressColor = UIColor.black
        block.setProgressWithAnimation(duration: 1, value: value, from: 0)
        
        value -= f
        progress.addSubview(block)
        return value
    }
    
    func addDumy() -> [String:Int] {
        var temp: [String:Int] = [:]
//        temp["Learning Korean"] = 2100
//        temp["Swift Programming"] = 4680
//        temp["Cycleing"] = 3900
//        temp["Running"] = 2700
//        temp["Reading Book"] = 2280
        temp["프로그래밍 공부"] = 4680
        temp["전공수업 과제"] = 3900
        temp["프로젝트 토의"] = 2700
        temp["책읽기"] = 2280
        temp["영문학 공부"] = 2100
        return temp
    }
    
    func fillHourColor() {
        let timeline = daily.timeline
        print("timeLine : \(timeline)")
//        let timeline = [3600,1300,0,0,0,0,0,0,0,1200,2000,3000,2600,2600,3600,3600,1000,0,500,2000,0,0,0,1200]
        fillColor(time: timeline[0], view: time_24)
        fillColor(time: timeline[1], view: time_01)
        fillColor(time: timeline[2], view: time_02)
        fillColor(time: timeline[3], view: time_03)
        fillColor(time: timeline[4], view: time_04)
        fillColor(time: timeline[5], view: time_05)
        fillColor(time: timeline[6], view: time_06)
        fillColor(time: timeline[7], view: time_07)
        fillColor(time: timeline[8], view: time_08)
        fillColor(time: timeline[9], view: time_09)
        fillColor(time: timeline[10], view: time_10)
        fillColor(time: timeline[11], view: time_11)
        fillColor(time: timeline[12], view: time_12)
        fillColor(time: timeline[13], view: time_13)
        fillColor(time: timeline[14], view: time_14)
        fillColor(time: timeline[15], view: time_15)
        fillColor(time: timeline[16], view: time_16)
        fillColor(time: timeline[17], view: time_17)
        fillColor(time: timeline[18], view: time_18)
        fillColor(time: timeline[19], view: time_19)
        fillColor(time: timeline[20], view: time_20)
        fillColor(time: timeline[21], view: time_21)
        fillColor(time: timeline[22], view: time_22)
        fillColor(time: timeline[23], view: time_23)
    }
    
    func fillColor(time: Int, view: UIView) {
        if(time == 0) {
            return
        }
        view.backgroundColor = UIColor(named: "CCC2")
        if(time < 600) { //0 ~ 10
            view.alpha = 0.2
        } else if(time < 1200) { //10 ~ 20
            view.alpha = 0.35
        } else if(time < 1800) { //20 ~ 30
            view.alpha = 0.5
        } else if(time < 2400) { //30 ~ 40
            view.alpha = 0.65
        } else if(time < 3000) { //40 ~ 50
            view.alpha = 0.8
        } else { //50 ~ 60
            view.alpha = 1.0
        }
    }
}

extension GraphViewController2: UICollectionViewDataSource {
    //몇개 표시 할까?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return counts
    }
    //셀 어떻게 표시 할까?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as? ListCell else {
            return UICollectionViewCell()
        }
        let color = colors[counts - indexPath.item - 1]
        cell.colorView.backgroundColor = color
        cell.colorView.layer.cornerRadius = 2
        cell.taskName.text = arrayTaskName[counts - indexPath.item - 1]
        cell.taskTime.text = arrayTaskTime[counts - indexPath.item - 1]
        cell.taskTime.textColor = color
        
        return cell
    }
}


class ListCell: UICollectionViewCell {
    @IBOutlet var colorView: UIView!
    @IBOutlet var taskName: UILabel!
    @IBOutlet var taskTime: UILabel!
}
