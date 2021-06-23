//
//  TodayViewManager.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/06/17.
//  Copyright © 2021 FDEE. All rights reserved.
//

import UIKit

class TodayViewManager {
    var arrayTaskName: [String] = []
    var arrayTaskTime: [String] = []
    var colors: [UIColor] = []
    var fixed_sum: Int = 0
    let f = Float(0.003)
    var daily = Daily()
    var counts: Int = 0
    var array: [Int] = []
    var fixedSum: Int = 0
    var checks: [Bool] = []
    var startColor: Int = 1
    var reverseColor: Bool = false
    
    var COLOR: UIColor = UIColor(named: "D1")!
    
    func saveChecks(_ check1: UIButton, _ check2: UIButton, _ check3: UIButton) {
        let c1 = check1.isSelected
        let c2 = check2.isSelected
        let c3 = check3.isSelected
        checks = [c1,c2,c3]
        UserDefaults.standard.set(checks, forKey: "checks")
    }
    
    func saveImages(_ f1: UIView, _ f2: UIView, _ f3: UIView) {
        if(checks[0]) { saveImage(f1) }
        if(checks[1]) { saveImage(f2) }
        if(checks[2]) { saveImage(f3) }
    }
    
    func saveImage(_ frame: UIView) {
        let img = UIImage.init(view: frame)
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
    }
    
    func updateChecks(_ index: Int) {
        checks[index] = !checks[index]
    }
    
    func setStartColorIndex(_ i: Int) {
        if(i == startColor) {
            reverseColor = !reverseColor
        } else { reverseColor = false }
        startColor = i
        UserDefaults.standard.setValue(startColor, forKey: "startColor")
    }
    
    func reset() {
        arrayTaskName = []
        arrayTaskTime = []
        colors = []
        fixed_sum = 0
        daily = Daily()
        counts = 0
        array = []
        fixedSum = 0
        checks = []
        startColor = 1
    }
    
    func appendColors() {
        COLOR = UIColor(named: "D\(startColor)")!
        if(!reverseColor) {
            var i = (counts+(startColor-1))%12
            if(i == 0) {
                i = 12
            }
            print(i)
            for _ in 1...counts {
                colors.append(UIColor(named: "D\(i)")!)
                i -= 1
                if(i == 0) {
                    i = 12
                }
            }
        }
        else {
            print("reverse")
            var i = ((startColor-counts+1)+12)%12
            if(i == 0) {
                i = 12
            }
            print(i)
            for _ in 1...counts {
                colors.append(UIColor(named: "D\(i)")!)
                i += 1
                if(i == 13) {
                    i = 1
                }
            }
        }
    }
    
    func setDay(_ today: UILabel, _ today2: UILabel, _ view4_today: UILabel) {
        let stringDay = getDay(day: daily.day)
        today.text = stringDay
        today2.text = stringDay
        view4_today.text = stringDay
    }
    
    func getDay(day: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd"
        return dateFormatter.string(from: day)
    }
    
    func setWeek(_ weeks: [UIView]) {
        let todayNum = weekday(daily.day)
        if(todayNum != 0) {
            let target: UIView = weeks[todayNum-1]
            target.backgroundColor = COLOR
        } else {
            let target: UIView = weeks[6]
            target.backgroundColor = COLOR
        }
    }
    
    func weekday(_ today: Date) -> Int {
        let _ = Calendar(identifier: .gregorian)
        let day = Calendar.current.component(.weekday, from: today) - 1
        print("day : \(day)")
        return day
    }
    
    func setTasksColor() {
        counts = daily.tasks.count
        appendColors()
    }
    
    func getTasks() {
        let temp: [String:Int] = daily.tasks
//            let temp = addDumy()
        
        let tasks = temp.sorted(by: { $0.1 < $1.1 } )
        for (key, value) in tasks {
            let value = value
            arrayTaskName.append(key)
            arrayTaskTime.append(ViewManager().printTime(value))
            array.append(value)
        }
    }
    
    func makeProgress(_ view: UIView, _ view2: UIView) {
        let datas = array
        let width = view.bounds.width
        let height = view.bounds.height
        let width2 = view2.bounds.width
        let height2 = view2.bounds.height
        
        print(datas)
        for i in 0..<counts {
            fixedSum += datas[i]
        }
        var sum = Float(fixedSum)
        
        //그래프 간 구별선 추가
        sum += f*Float(counts)
        
        var value: Float = 1
        value = addBlock(value: value, view: view, view2: view2)
        for i in 0..<counts {
            let prog = StaticCircularProgressView(frame: CGRect(x: 0, y: 0, width: width, height: height))
            let prog2 = StaticCircularProgressView(frame: CGRect(x: 0, y: 0, width: width2, height: height2))
            prog.progressWidth = 35
            prog2.progressWidth = 25
            prog.trackColor = UIColor.clear
            prog2.trackColor = UIColor.clear
            prog.progressColor = colors[i%colors.count]
            prog2.progressColor = colors[i%colors.count]
            print(value)
            prog.setProgressWithAnimation(duration: 0.7, value: value, from: 0)
            prog2.setProgressWithAnimation(duration: 0.7, value: value, from: 0)
            
            let per = Float(datas[i])/Float(sum) //그래프 퍼센트
            value -= per
            
            view.addSubview(prog)
            view2.addSubview(prog2)
            
            value = addBlock(value: value, view: view, view2: view2)
        }
        
    }
    
    func addBlock(value: Float, view: UIView, view2: UIView) -> Float {
        let width = view.bounds.width
        let height = view.bounds.width
        let width2 = view2.bounds.width
        let height2 = view2.bounds.height
        var value = value
        let block = StaticCircularProgressView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        let block2 = StaticCircularProgressView(frame: CGRect(x: 0, y: 0, width: width2, height: height2))
        block.trackColor = UIColor.clear
        block2.trackColor = UIColor.clear
        block.progressColor = UIColor.systemBackground
        block2.progressColor = UIColor.systemBackground
        block.progressWidth = 35
        block2.progressWidth = 25
        block.setProgressWithAnimation(duration: 0.7, value: value, from: 0)
        block2.setProgressWithAnimation(duration: 0.7, value: value, from: 0)
        
        value -= f
        view.addSubview(block)
        view2.addSubview(block2)
        return value
    }
    
    func showTimes(_ sum1: UILabel, _ sum2: UILabel, _ max1: UILabel, _ max2: UILabel) {
        let stringSum = ViewManager().printTime(fixedSum)
        sum1.text = stringSum
        sum2.text = stringSum
        sum1.textColor = COLOR
        sum2.textColor = COLOR
        
        let stringMax = ViewManager().printTime(daily.maxTime)
        max1.text = stringMax
        max2.text = stringMax
        max1.textColor = COLOR
        max2.textColor = COLOR
    }
    
    func setDumyDaily() {
        daily = Dumy().getDumyDaily()
    }
}
