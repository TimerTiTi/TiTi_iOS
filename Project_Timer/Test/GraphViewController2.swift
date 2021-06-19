//
//  GraphViewController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/02/23.
//  Copyright © 2021 FDEE. All rights reserved.
//

import UIKit
import SwiftUI
import Firebase

class GraphViewController2: UIViewController {

    let db = Database.database().reference().child("test")
    
    @IBOutlet var viewOfView: UIView!
    
    @IBOutlet var progress: UIView!
    @IBOutlet var sumTime: UILabel!
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

    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var view_7days: UIView!
    @IBOutlet var view_today: UIView!
    
    @IBOutlet var collectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet var upload: UIButton!
    @IBOutlet var download: UIButton!
    
    
    
    var arrayTaskName: [String] = []
    var arrayTaskTime: [String] = []
    var colors: [UIColor] = []
    var fixed_sum: Int = 0
    let f = Float(0.003)
    var daily = Daily()
    var counts: Int = 0
    
    var logViewControllerDelegate : ChangeViewController2!
    var phone: String = UserDefaults.standard.value(forKey: "phoneNumber") as? String ?? ""
    var password = UserDefaults.standard.value(forKey: "password") as? String ?? ""
    var isUser: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkUser()
        setRadius()
        setShadow(view_7days)
        setShadow(view_today)
        
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
//            today.text = "5/6"
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
            
            setHeight()
        } else {
            print("no data")
        }
        
        upload.isHidden = true
        download.isHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        ContentView().reset()
    }
    
    @IBAction func todayButtonAction(_ sender: Any) {
        goToViewController(where: "TodayViewController")
    }
    
    @IBAction func upload(_ sender: Any) {
        if(isUser) {
            let temp = getTemp()
            db.child("data").child("\(phone)_\(password)").child("today").setValue(temp)
            alert("upload Success")
        } else {
            newUser(true)
        }
    }
    
    @IBAction func download(_ sender: Any) {
        if(isUser) {
            db.child("data").child("\(phone)_\(password)").child("today").observeSingleEvent(of: .value) { (snapshot) in
                do {
                    let data = try JSONSerialization.data(withJSONObject: snapshot.value, options: [])
                    let decoder = JSONDecoder()
                    let getDaily: GetDaily = try decoder.decode(GetDaily.self, from: data)
                    print("--> daily : \(getDaily)")
                    
                    let newDaily: Daily = self.transDaily(getDaily)
                    //동일날인지 여부
                    if(self.deferentDay(getDaily.day)) {
                        self.setNextDay()
                    }
                    self.saveData(newDaily)
                    self.alert("download Success") 
                    
                    DispatchQueue.main.async {
                        ContentView().reset()
                        self.viewDidLoad()
                        self.view.layoutIfNeeded()
                        self.collectionView.reloadData()
                        self.logViewControllerDelegate.reload()
                    }
                } catch let error { print("--> error: \(error)") }
            }
            self.viewDidAppear(true)
        } else {
            newUser(false)
        }
    }
    
    
    func getTemp() -> [String:Any] {
        let day = uploadDate(day: daily.day)
        let fixedTotalTime = UserDefaults.standard.value(forKey: "allTime") as? Int ?? 21600
        let fixedSumTime = 0
        let fixedTimerTime = UserDefaults.standard.value(forKey: "second") as? Int ?? 2400
//        let currentTotalTime = UserDefaults.standard.value(forKey: "allTime2") as? Int ?? 0
        let currentTotalTime = fixedTotalTime - fixed_sum
//        let currentSumTime = UserDefaults.standard.value(forKey: "sum2") as? Int ?? 0
        let currentSumTime = fixed_sum
        let currentTimerTime = UserDefaults.standard.value(forKey: "second2") as? Int ?? 0
        let breakTime = 0
        let maxTime = daily.maxTime
        let startTime = daily.startTime.timeIntervalSince1970
        let currentTask = daily.currentTask
//        let currentTask = ""
//        let tasks = daily.tasks
        var taskKeys: [String] = []
        var taskValues: [Int] = []
        for (key, value) in daily.tasks {
            taskKeys.append(key)
            taskValues.append(value)
        }
        let beforeTime = daily.beforeTime
        let timeline = daily.timeline
        
        var temp: [String:Any] = [:]
        temp.updateValue(day, forKey: "day")
        temp.updateValue(fixedTotalTime, forKey: "fixedTotalTime")
        temp.updateValue(fixedSumTime, forKey: "fixedSumTime")
        temp.updateValue(fixedTimerTime, forKey: "fixedTimerTime")
        temp.updateValue(currentTotalTime, forKey: "currentTotalTime")
        temp.updateValue(currentSumTime, forKey: "currentSumTime")
        temp.updateValue(currentTimerTime, forKey: "currentTimerTime")
        temp.updateValue(breakTime, forKey: "breakTime")
        temp.updateValue(maxTime, forKey: "maxTime")
        temp.updateValue(startTime, forKey: "startTime")
        temp.updateValue(currentTask, forKey: "currentTask")
//        temp.updateValue(tasks, forKey: "tasks")
        temp.updateValue(taskKeys, forKey: "taskKeys")
        temp.updateValue(taskValues, forKey: "taskValues")
        temp.updateValue(beforeTime, forKey: "beforeTime")
        temp.updateValue(timeline, forKey: "timeline")
        
        
        
        return temp
    }
    
    func alert(_ message: String) {
        //1. 경고창 내용 만들기
        let alert = UIAlertController(title:message,
            message: "",
            preferredStyle: UIAlertController.Style.alert)
        //2. 확인 버튼 만들기
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        //3. 확인 버튼을 경고창에 추가하기
        alert.addAction(ok)
        //4. 경고창 보이기
        present(alert,animated: true,completion: nil)
    }
    
    func uploadDate(day: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd"
        return dateFormatter.string(from: day)
    }
    
    func transDaily(_ getDaily: GetDaily) -> Daily {
        var newDaily: Daily = Daily()
        newDaily.day = stringToDate(getDaily.day)
        newDaily.fixedTotalTime = getDaily.fixedTotalTime
        newDaily.fixedSumTime = 0
        newDaily.fixedTimerTime = getDaily.fixedTimerTime
        newDaily.currentTotalTime = getDaily.currentTotalTime
        newDaily.currentSumTime = getDaily.currentSumTime
        newDaily.currentTimerTime = getDaily.currentTimerTime
        newDaily.breakTime = 0
        newDaily.maxTime = getDaily.maxTime
        newDaily.startTime = doubleToDate(getDaily.startTime)
        newDaily.currentTask = getDaily.currentTask
        for i in 0..<getDaily.taskKeys.count {
            newDaily.tasks.updateValue(getDaily.taskValues[i], forKey: getDaily.taskKeys[i])
        }
        newDaily.beforeTime = getDaily.beforeTime
        newDaily.timeline = getDaily.timeline

        return newDaily
    }
    
    func stringToDate(_ stringDay: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd"
        let date = dateFormatter.date(from: stringDay)!
        return date
    }
    
    func doubleToDate(_ doubleDay: Double) -> Date {
        let date = Date(timeIntervalSince1970: doubleDay)
        return date
    }
    
    func transdDay1(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월 d일"
        return dateFormatter.string(from: date)
    }
    
    func checkUser() {
        if(phone != "" && password != "") {
            db.child("Users").observeSingleEvent(of: .value) { (snapshot) in
                do {
                    guard let keyValues = snapshot.value as? [String:String] else { return }
                    let users = Array(keyValues.values)
                    print(users)
                    
                    if(users.contains("\(self.phone)_\(self.password)")) {
                        print("isUser")
                        self.isUser = true
                    }
                } catch let error { print("--> error: \(error)") }
            }
        }
    }
    
    func newUser(_ upload: Bool) {
        let alert = UIAlertController(title: "Beta 유저정보 등록", message: "핸드폰 번호와\n4자리 패스워드를 등록해주세요", preferredStyle: .alert)
        let cancle = UIAlertAction(title: "CANCLE", style: .destructive, handler: nil)
        let ok = UIAlertAction(title: "ENTER", style: .default, handler: {
            action in
            let phone: String = alert.textFields?[0].text ?? ""
            let pass: String = alert.textFields?[1].text ?? ""
            // 위 변수를 통해 특정기능 수행
            self.checkUserInput(phone, pass, upload)
        })
        //텍스트 입력 추가
        alert.addTextField { (inputNewNickName) in
            inputNewNickName.placeholder = "01012123434"
            inputNewNickName.textAlignment = .center
            inputNewNickName.font = UIFont(name: "HGGGothicssiP60g", size: 17)
            inputNewNickName.keyboardType = .numberPad
        }
        alert.addTextField { (inputNewNickName) in
            inputNewNickName.placeholder = "1234"
            inputNewNickName.textAlignment = .center
            inputNewNickName.font = UIFont(name: "HGGGothicssiP60g", size: 17)
            inputNewNickName.keyboardType = .numberPad
        }
        alert.addAction(cancle)
        alert.addAction(ok)
        present(alert,animated: true,completion: nil)
    }
    
    func checkUserInput(_ phone: String, _ pass: String, _ upload: Bool) {
        if(phone.count != 11) {
            alert("핸드폰 번호를 다시 입력해주세요")
            return
        }
        else if(pass.count != 4) {
            alert("패스워드를 다시 입력해주세요")
            return
        }
        guard let _ = Int(phone) else {
            alert("핸드폰 번호를 다시 입력해주세요")
            return
        }
        guard let _ = Int(pass) else {
            alert("패스워드를 다시 입력해주세요")
            return
        }
        
        db.child("Users").updateChildValues(["\(phone)_\(pass)" : "\(phone)_\(pass)"])
        UserDefaults.standard.setValue(phone, forKey: "phoneNumber")
        UserDefaults.standard.setValue(pass, forKey: "password")
        self.phone = phone
        self.password = pass
        isUser = true
        
        if(upload) {
            let temp = getTemp()
            db.child("data").child("\(phone)_\(password)").child("today").setValue(temp)
        }
        
        alert("등록이 완료되었습니다, 다시 눌러주시기 바랍니다")
    }
    
    func deferentDay(_ getDay: String) -> Bool {
        let savedDay: String = UserDefaults.standard.value(forKey: "day1") as? String ?? "NO DATA"
        if(savedDay == "NO DATA") { return false }
        print("savedDay: \(savedDay)")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd"
        let exported = dateFormatter.date(from: getDay)!
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "M월 d일"
        let transdDay = newDateFormatter.string(from: exported)
        print("transdDay: \(transdDay)")
        
        return(savedDay != transdDay)
    }
    
    func setNextDay() {
        var array_day = [String](repeating: "", count: 7)
        var array_time = [String](repeating: "", count: 7)
        var array_break = [String](repeating: "", count: 7)
        
        for i in stride(from: 0, to: 7, by: 1) {
            array_day[i] = UserDefaults.standard.value(forKey: "day"+String(i+1)) as? String ?? "NO DATA"
            array_time[i] = UserDefaults.standard.value(forKey: "time"+String(i+1)) as? String ?? "NO DATA"
            array_break[i] = UserDefaults.standard.value(forKey: "break"+String(i+1)) as? String ?? "NO DATA"
        }
        //값 옮기기, 값 저장하기
        for i in stride(from: 6, to: 0, by: -1) {
            array_day[i] = array_day[i-1]
            UserDefaults.standard.set(array_day[i], forKey: "day"+String(i+1))
            array_time[i] = array_time[i-1]
            UserDefaults.standard.set(array_time[i], forKey: "time"+String(i+1))
            array_break[i] = array_break[i-1]
            UserDefaults.standard.set(array_break[i], forKey: "break"+String(i+1))
        }
    }
    
    func saveData(_ newDaily: Daily) {
        UserDefaults.standard.set(newDaily.fixedTotalTime, forKey: "allTime")
        UserDefaults.standard.set(newDaily.fixedTimerTime, forKey: "second")
        UserDefaults.standard.set(newDaily.currentTotalTime, forKey: "allTime2")
        UserDefaults.standard.set(newDaily.currentSumTime, forKey: "sum2")
        UserDefaults.standard.set(newDaily.currentTimerTime, forKey: "second2")
        UserDefaults.standard.set(newDaily.currentTask, forKey: "task")
        UserDefaults.standard.set(printTime(temp: newDaily.currentSumTime), forKey: "time1")
        UserDefaults.standard.set(transdDay1(newDaily.day), forKey: "day1")
        newDaily.save()
    }
    
    func saveImageTest() {
        let img1 = UIImage.init(view: viewOfView)
        let img2 = UIImage.init(view: progress)
        let img3 = UIImage.init(view: self.view)
        
        UIImageWriteToSavedPhotosAlbum(img1, nil, nil, nil)
        UIImageWriteToSavedPhotosAlbum(img2, nil, nil, nil)
        UIImageWriteToSavedPhotosAlbum(img3, nil, nil, nil)
        
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
        
        view_7days.layer.cornerRadius = 25
        view_today.layer.cornerRadius = 25
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
            print(i)
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
    
    func goToViewController(where: String) {
        let vcName = self.storyboard?.instantiateViewController(withIdentifier: `where`)
        vcName?.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
        vcName?.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
        self.present(vcName!, animated: true, completion: nil)
    }
    
    func setShadow(_ view: UIView) {
        view.layer.shadowColor = UIColor.white.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 5
    }
    
    func setHeight() {
        if(counts < 8) {
            collectionViewHeight.constant = CGFloat(20*counts)
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

struct GetDaily: Codable {
    var day: String = ""
    var fixedTotalTime: Int = 0
    var fixedSumTime: Int = 0
    var fixedTimerTime: Int = 0
    var currentTotalTime: Int = 0
    var currentSumTime: Int = 0
    var currentTimerTime: Int = 0
    var breakTime: Int = 0
    var maxTime: Int = 0
    
    var startTime: Double = 0
    var currentTask: String = ""
//    var tasks: [String:Int] = [:]
    var taskKeys: [String] = []
    var taskValues: [Int] = []
    
    var beforeTime: Int = 0
    var timeline = Array(repeating: 0, count: 24)
}
