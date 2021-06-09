//
//  TodayViewController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/06/04.
//  Copyright © 2021 FDEE. All rights reserved.
//

import UIKit
import SwiftUI

class TodayViewController: UIViewController {
    
    @IBOutlet var frame1: UIView!
    @IBOutlet var view1: UIView!
    @IBOutlet var frame2: UIView!
    @IBOutlet var view2: UIView!
    @IBOutlet var frame3: UIView!
    @IBOutlet var view3: UIView!
    
    @IBOutlet var timeline: UIView!
    @IBOutlet var progress: UIView!
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var mon: UIView!
    @IBOutlet var tue: UIView!
    @IBOutlet var wed: UIView!
    @IBOutlet var thu: UIView!
    @IBOutlet var fri: UIView!
    @IBOutlet var sat: UIView!
    @IBOutlet var sun: UIView!
    
    @IBOutlet var today: UILabel!
    @IBOutlet var sumTime: UILabel!
    @IBOutlet var maxTime: UILabel!
    
    @IBOutlet var collectionHeight: NSLayoutConstraint!//160
    
    @IBOutlet var check1: UIButton!
    @IBOutlet var check2: UIButton!
    @IBOutlet var check3: UIButton!
    
    @IBOutlet var view4_today: UILabel!
    @IBOutlet var view4_mon: UIView!
    @IBOutlet var view4_tue: UIView!
    @IBOutlet var view4_wed: UIView!
    @IBOutlet var view4_thu: UIView!
    @IBOutlet var view4_fri: UIView!
    @IBOutlet var view4_sat: UIView!
    @IBOutlet var view4_sun: UIView!
    @IBOutlet var view4_sumTime: UILabel!
    @IBOutlet var view4_maxTime: UILabel!
    
    @IBOutlet var view4_timeline: UIView!
    @IBOutlet var view4_progress: UIView!
    @IBOutlet var view4_collectionView: UICollectionView!
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var color1: UIButton!
    @IBOutlet var color2: UIButton!
    @IBOutlet var color3: UIButton!
    @IBOutlet var color4: UIButton!
    @IBOutlet var color5: UIButton!
    @IBOutlet var color6: UIButton!
    @IBOutlet var color7: UIButton!
    @IBOutlet var color8: UIButton!
    @IBOutlet var color9: UIButton!
    @IBOutlet var color10: UIButton!
    @IBOutlet var color11: UIButton!
    @IBOutlet var color12: UIButton!
    
    @IBOutlet var leftGesture: UIScreenEdgePanGestureRecognizer!
    
    @IBOutlet var dailyDay: UILabel!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()

        setRadius()
        setShadow(view1)
        setShadow(view2)
        setShadow(view3)
        
        getColor()
        setTimeLine()
        setExtra()
        setChecks()
        
        leftGesture.edges = .left
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        todayContentView().reset()
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let c1 = check1.isSelected
        let c2 = check2.isSelected
        let c3 = check3.isSelected
        checks = [c1,c2,c3]
        UserDefaults.standard.set(checks, forKey: "checks")
        
        print("disappear in today")
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    @IBAction func saveImage(_ sender: Any) {
        if(checks[0]) { saveImageTest(frame1) }
        if(checks[1]) { saveImageTest(frame2) }
        if(checks[2]) { saveImageTest(frame3) }
        showAlert()
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func check(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let index = Int(sender.tag)
        checks[index] = !checks[index]
    }
    
    @IBAction func changeColor(_ sender: UIButton) {
        let i = Int(sender.tag)
        if(i == startColor) {
            reverseColor = !reverseColor
        } else { reverseColor = false }
        startColor = i
        UserDefaults.standard.setValue(startColor, forKey: "startColor")
        
        reset()
        todayContentView().reset()
        self.viewDidLoad()
        self.view.layoutIfNeeded()
        collectionView.reloadData()
        view4_collectionView.reloadData()
    }
    
    @IBAction func leftGestureAction(_ sender: Any) {
        print("left")
        self.dismiss(animated: true, completion: nil)
    }
}

extension TodayViewController {
    
    func setRadius() {
        view1.layer.cornerRadius = 25
        view2.layer.cornerRadius = 25
        view3.layer.cornerRadius = 25
        
        color1.layer.cornerRadius = 5
        color2.layer.cornerRadius = 5
        color3.layer.cornerRadius = 5
        color4.layer.cornerRadius = 5
        color5.layer.cornerRadius = 5
        color6.layer.cornerRadius = 5
        color7.layer.cornerRadius = 5
        color8.layer.cornerRadius = 5
        color9.layer.cornerRadius = 5
        color10.layer.cornerRadius = 5
        color11.layer.cornerRadius = 5
        color12.layer.cornerRadius = 5
    }
    
    func setShadow(_ view: UIView) {
        view.layer.shadowColor = UIColor(named: "shadow")?.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 5
    }
    
    func saveImageTest(_ frame: UIView) {
        let img1 = UIImage.init(view: frame)
        UIImageWriteToSavedPhotosAlbum(img1, nil, nil, nil)
    }
    
    func showAlert() {
        //1. 경고창 내용 만들기
        let alert = UIAlertController(title:"저장되었습니다",
            message: "",
            preferredStyle: UIAlertController.Style.alert)
        //2. 확인 버튼 만들기
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        //3. 확인 버튼을 경고창에 추가하기
        alert.addAction(ok)
        //4. 경고창 보이기
        present(alert,animated: true,completion: nil)
    }
    
    func setExtra() {
        //extra
        daily.load()
//        setDumyDaily()
        counts = daily.tasks.count
        if(daily.tasks != [:]) {
            setColors()
            setDay()
            getTasks()
            setProgress()
            setTimes()
            setHeight()
        } else {
            print("no data")
        }
    }
    
    func appendColors() {
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
    
    func makeProgress(_ datas: [Int], _ view: UIView, _ view2: UIView) {
        let width = view.bounds.width
        let height = view.bounds.height
        let width2 = view2.bounds.width
        let height2 = view2.bounds.height
        
        print(datas)
        for i in 0..<counts {
            fixedSum += datas[i]
        }
        var sum = Float(fixedSum)
        sumTime.text = printTime(temp: fixedSum)
        
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
    
    func setTimeLine() {
        //timeline
        var sc: Int = startColor
        var nc: Int = startColor+1 == 13 ? 1 : startColor+1
        if(reverseColor) { swap(&sc, &nc) }
        
        let hostingController = UIHostingController(rootView: todayContentView(colors: [Color("D\(nc)"), Color("D\(sc)")], frameHeight: 128, height: 125))
        hostingController.view.translatesAutoresizingMaskIntoConstraints = true
        hostingController.view.frame = timeline.bounds
        todayContentView().appendTimes()
//        todayContentView().appendDumyDatas()
        addChild(hostingController)
        timeline.addSubview(hostingController.view)
        
        todayContentView().reset()
        
        let hostingController2 = UIHostingController(rootView: todayContentView(colors: [Color("D\(nc)"), Color("D\(sc)")], frameHeight: 97, height: 93))
        hostingController2.view.translatesAutoresizingMaskIntoConstraints = true
        hostingController2.view.frame = view4_timeline.bounds
        todayContentView().appendTimes()
//        todayContentView().appendDumyDatas()
        addChild(hostingController2)
        view4_timeline.addSubview(hostingController2.view)
    }
    
    func setDay() {
        let stringDay = getDay(day: daily.day)
//        let stringDay = "2021.06.04"
        today.text = stringDay
        view4_today.text = stringDay
        setWeek()
//        thu.backgroundColor = COLOR
        dailyDay.text = stringDay
    }
    
    func getDay(day: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd"
        return dateFormatter.string(from: day)
    }
    
    func weekday(_ today: Date) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        let day = Calendar.current.component(.weekday, from: today) - 1
        print("day : \(day)")
        return day
    }
    
    func setWeek() {
        let todayNum = weekday(daily.day)
        print(todayNum)
        switch(todayNum) {
        case 1:
            mon.backgroundColor = COLOR
            view4_mon.backgroundColor = COLOR
        case 2:
            tue.backgroundColor = COLOR
            view4_tue.backgroundColor = COLOR
        case 3:
            wed.backgroundColor = COLOR
            view4_wed.backgroundColor = COLOR
        case 4:
            thu.backgroundColor = COLOR
            view4_thu.backgroundColor = COLOR
        case 5:
            fri.backgroundColor = COLOR
            view4_fri.backgroundColor = COLOR
        case 6:
            sat.backgroundColor = COLOR
            view4_sat.backgroundColor = COLOR
        case 0:
            sun.backgroundColor = COLOR
            view4_sun.backgroundColor = COLOR
        default:
            mon.backgroundColor = UIColor.clear
            view4_mon.backgroundColor = UIColor.clear
        }
    }
    
    func getTasks() {
        let temp: [String:Int] = daily.tasks
//            let temp = addDumy()
        
        let tasks = temp.sorted(by: { $0.1 < $1.1 } )
        for (key, value) in tasks {
            arrayTaskName.append(key)
            arrayTaskTime.append(printTime(temp: value))
            array.append(value)
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
    
    func setTimes() {
        let stringSum = printTime(temp: fixedSum)
        sumTime.text = stringSum
        sumTime.textColor = COLOR
        view4_sumTime.text = stringSum
        view4_sumTime.textColor = COLOR
        
        let stringMax = printTime(temp: daily.maxTime)
        maxTime.text = stringMax
        maxTime.textColor = COLOR
        view4_maxTime.text = stringMax
        view4_maxTime.textColor = COLOR
    }
    
    func setProgress() {
//        appendColors()
        makeProgress(array, progress, view4_progress)
    }
    
    func setChecks() {
        checks = UserDefaults.standard.value(forKey: "checks") as? [Bool] ?? [true,true,true]
        check1.isSelected = checks[0]
        check2.isSelected = checks[1]
        check3.isSelected = checks[2]
    }
    
    func setDumyDaily() {
        var dumy: [String:Int] = [:]
        dumy.updateValue(2000, forKey: "Swift")
        dumy.updateValue(3000, forKey: "Java")
        dumy.updateValue(1200, forKey: "C++")
//        dumy.updateValue(2400, forKey: "Python")
//        dumy.updateValue(2800, forKey: "Algorithm")
//        dumy.updateValue(3200, forKey: "Programming")
//        dumy.updateValue(1000, forKey: "coding")
//        dumy.updateValue(800, forKey: "blog")
//        dumy.updateValue(2200, forKey: "design")
//        dumy.updateValue(2500, forKey: "develop")
//        dumy.updateValue(2600, forKey: "typing")
//        dumy.updateValue(3600, forKey: "TiTi develop")
        daily.tasks = dumy
    }
    
    func setHeight() {
        if(array.count < 8) {
            collectionHeight.constant = CGFloat(20*array.count)
        }
    }
    
    func setColors() {
        COLOR = UIColor(named: "D\(startColor)")!
        appendColors()
    }
    
    func getColor() {
        startColor = UserDefaults.standard.value(forKey: "startColor") as? Int ?? 1
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
}




extension TodayViewController: UICollectionViewDataSource {
    //몇개 표시 할까?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return counts
    }
    //셀 어떻게 표시 할까?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == self.collectionView) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "todayCell", for: indexPath) as? todayCell else {
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
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "todayCell2", for: indexPath) as? todayCell2 else {
                return UICollectionViewCell()
            }
            let color = colors[counts - indexPath.item - 1]
            cell.check.textColor = color
            cell.taskName.text = arrayTaskName[counts - indexPath.item - 1]
            cell.taskTime.text = arrayTaskTime[counts - indexPath.item - 1]
            cell.taskTime.textColor = color
            cell.background.backgroundColor = color
            
            return cell
        }
    }
}

class todayCell: UICollectionViewCell {
    @IBOutlet var colorView: UIView!
    @IBOutlet var taskName: UILabel!
    @IBOutlet var taskTime: UILabel!
}

class todayCell2: UICollectionViewCell {
    @IBOutlet var check: UILabel!
    @IBOutlet var taskName: UILabel!
    @IBOutlet var taskTime: UILabel!
    @IBOutlet var background: UIView!
}
