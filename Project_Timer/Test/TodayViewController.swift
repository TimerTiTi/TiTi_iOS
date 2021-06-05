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
    
    @IBOutlet var t1: UITextField!
    @IBOutlet var t2: UITextField!
    @IBOutlet var t3: UITextField!
    @IBOutlet var t4: UITextField!
    @IBOutlet var t5: UITextField!
    
    @IBOutlet var bottomTerm: NSLayoutConstraint!
    
    var arrayTaskName: [String] = []
    var arrayTaskTime: [String] = []
    var colors: [UIColor] = []
    var fixed_sum: Int = 0
    let f = Float(0.003)
    var daily = Daily()
    var counts: Int = 0
    var array: [Int] = []
    var fixedSum: Int = 0
    var memos: [String] = []
    
    var COLOR: UIColor = UIColor(named: "CCC1")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()

        setRadius()
        setShadow(view1)
        setShadow(view2)
        setShadow(view3)
        
        setTimeLine()
        setExtra()
        setMemo()
        
        t1.underlined()
        t2.underlined()
        t3.underlined()
        t4.underlined()
        t5.underlined()
        
        // TODO: 키보드 디텍션 : keyboard가 띄워지고, 사라지면 adjustInputView가 실행되는 원리 : OK
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        todayContentView().reset()
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let m1 = t1.text!
        let m2 = t2.text!
        let m3 = t3.text!
        let m4 = t4.text!
        let m5 = t5.text!
        memos = [m1,m2,m3,m4,m5]
        print(memos)
        
        UserDefaults.standard.set(memos, forKey: "memos")
        print("disappear in today")
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    @IBAction func saveImage(_ sender: Any) {
        saveImageTest(frame1)
        saveImageTest(frame2)
        saveImageTest(frame3)
        showAlert()
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension TodayViewController {
    
    func setRadius() {
        view1.layer.cornerRadius = 45
        view2.layer.cornerRadius = 45
        view3.layer.cornerRadius = 45
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
        if(daily.tasks != [:]) {
            setDay()
            getTasks()
            setProgress()
            setTimes()
        } else {
            print("no data")
        }
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
    
    func makeProgress(_ datas: [Int], _ width: CGFloat, _ height: CGFloat) {
        print(datas)
        for i in 0..<counts {
            fixedSum += datas[i]
        }
        var sum = Float(fixedSum)
        sumTime.text = printTime(temp: fixedSum)
        
        //그래프 간 구별선 추가
        sum += f*Float(counts)
        
        var value: Float = 1
        value = addBlock(value: value, width: width, height: height)
        for i in 0..<counts {
            let prog = StaticCircularProgressView(frame: CGRect(x: 0, y: 0, width: width, height: height))
            prog.progressWidth = 35
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
        block.progressColor = UIColor.systemBackground
        block.progressWidth = 35
        block.setProgressWithAnimation(duration: 1, value: value, from: 0)
        
        value -= f
        progress.addSubview(block)
        return value
    }
    
    func setTimeLine() {
        //timeline
        let hostingController = UIHostingController(rootView: todayContentView())
        hostingController.view.translatesAutoresizingMaskIntoConstraints = true
        hostingController.view.frame = timeline.bounds
        todayContentView().appendTimes()
//        todayContentView().appendDumyDatas()
        addChild(hostingController)
        timeline.addSubview(hostingController.view)
    }
    
    func setDay() {
        today.text = getDay(day: daily.day)
        setWeek()
//        today.text = "2021.05.06"
//        thu.backgroundColor = COLOR
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
        case 2:
            tue.backgroundColor = COLOR
        case 3:
            wed.backgroundColor = COLOR
        case 4:
            thu.backgroundColor = COLOR
        case 5:
            fri.backgroundColor = COLOR
        case 6:
            sat.backgroundColor = COLOR
        case 0:
            sun.backgroundColor = COLOR
        default:
            mon.backgroundColor = UIColor.clear
        }
    }
    
    func getTasks() {
        let temp: [String:Int] = daily.tasks
//            let temp = addDumy()
        counts = temp.count
        
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
        sumTime.text = printTime(temp: fixedSum)
        sumTime.textColor = COLOR
        maxTime.text = printTime(temp: daily.maxTime)
//        maxTime.text = "1:12:30"
        maxTime.textColor = COLOR
    }
    
    func setProgress() {
        appendColors()
        let width = progress.bounds.width
        let height = progress.bounds.height
        makeProgress(array, width, height)
    }
    
    func setMemo() {
        memos = UserDefaults.standard.value(forKey: "memos") as? [String] ?? ["", "", "", "", ""]
        t1.text = memos[0]
        t2.text = memos[1]
        t3.text = memos[2]
        t4.text = memos[3]
        t5.text = memos[4]
    }
}




extension TodayViewController: UICollectionViewDataSource {
    //몇개 표시 할까?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return counts
    }
    //셀 어떻게 표시 할까?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
}

class todayCell: UICollectionViewCell {
    @IBOutlet var colorView: UIView!
    @IBOutlet var taskName: UILabel!
    @IBOutlet var taskTime: UILabel!
}


extension TodayViewController {
    @objc private func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        // TODO: 키보드 높이에 따른 인풋뷰 위치 변경 : OK
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        var adjustmentHeight: CGFloat = 0
        //이동시킬 Height를 구한다
        if noti.name == UIResponder.keyboardWillShowNotification {
            adjustmentHeight = keyboardFrame.height - view.safeAreaInsets.bottom
        } else {
            adjustmentHeight = 0
        }
        //구한 Height 만큼 변화시킨다
        self.bottomTerm.constant = adjustmentHeight+15
        self.view.layoutIfNeeded()
        
        print("--> keyboard End Frame: \(keyboardFrame)")
    }
}
