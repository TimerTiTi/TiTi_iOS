//
//  GraphViewController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/02/23.
//  Copyright © 2021 FDEE. All rights reserved.
//

import UIKit
import SwiftUI

class LogViewController: UIViewController {
    @IBOutlet weak var monthFrameView: UIView!
    @IBOutlet weak var monthTimeLabel: UILabel!
    
    @IBOutlet weak var weeksFrameView: UIView!
    @IBOutlet weak var graphViewOfWeeks: UIView!
    
    @IBOutlet weak var todayFrameView: UIView!
    @IBOutlet weak var todayDateLabel: UILabel!
    @IBOutlet weak var todayProgressView: UIView!
    @IBOutlet weak var todaySumtimeLabel: UILabel!
    @IBOutlet var timeSticks: [UIView]!
    @IBOutlet weak var subjects: UICollectionView!
    @IBOutlet weak var subjectsHeight: NSLayoutConstraint!
    
    var arrayTaskName: [String] = []
    var arrayTaskTime: [String] = []
    var colors: [UIColor] = []
    var fixed_sum: Int = 0
    let f = Float(0.003)
    var daily = Daily()
    var counts: Int = 0
    var logViewControllerDelegate : ChangeViewController2!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureShadows(self.monthFrameView, self.weeksFrameView, self.todayFrameView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureWeeksGraph()
        self.configureTodaysData()
        self.showMonthTime()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ContentView().reset()
    }
    
    @IBAction func todayButtonAction(_ sender: Any) {
        goToViewController(where: "TodayViewController")
    }
}

// MARK: Configure
extension LogViewController {
    private func configureShadows(_ views: UIView...) {
        views.forEach { view in
            view.layer.shadowColor = UIColor.white.cgColor
            view.layer.shadowOpacity = 0.5
            view.layer.shadowOffset = CGSize.zero
            view.layer.shadowRadius = 5
        }
    }
}
extension LogViewController {
    private func configureWeeksGraph(_ isDumy: Bool = false) {
        let hostingController = UIHostingController(rootView: ContentView())
        hostingController.view.translatesAutoresizingMaskIntoConstraints = true
        hostingController.view.frame = self.graphViewOfWeeks.bounds
        
        ContentView().appendDailyDatas(isDumy: isDumy)
        self.addChild(hostingController)
        self.graphViewOfWeeks.addSubview(hostingController.view)
    }
    
    private func configureTodaysData(_ isDumy: Bool = false) {
        self.daily.load()
        if isDumy { self.daily = Dumy().getDumyDaily() }
        
        if self.daily.tasks != [:] {
            self.configureTodayDateLabel()
            self.configureTimesticksGraph()
            
            let temp: [String: Int] = self.daily.tasks
            counts = temp.count
            appendColors()
            
            let tasks = temp.sorted(by: { $0.1 < $1.1 } )
            
            var array: [Int] = []
            for (key, value) in tasks {
                arrayTaskName.append(key)
                arrayTaskTime.append(printTime(temp: value))
                array.append(value)
            }
            
            let width = todayProgressView.bounds.width
            let height = todayProgressView.bounds.height
            makeProgress(array, width, height)
            var p1 = ""
            var p2 = ""
            for i in (0..<tasks.count).reversed() {
                p1 += "\(arrayTaskName[i])\n"
                p2 += "\(arrayTaskTime[i])\n"
            }
            
            print("max : \(daily.maxTime)")
            
            setHeight()
        } else {
            print("no data")
        }
    }
    
    private func configureTodayDateLabel() {
        self.todayDateLabel.text = self.daily.day.MDstyleString
    }
    
    private func configureTimesticksGraph() {
        let timeline = daily.timeline
        print("timeLine : \(timeline)")
        for i in 0..<24 {
            self.fillColor(time: timeline[i], view: self.timeSticks[i] as UIView)
        }
    }
    
    private func fillColor(time: Int, view: UIView) {
        if time == 0 { return }
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

extension LogViewController {
    private func appendColors() {
        var i = counts % 12 == 0 ? 12 : counts % 12
        for _ in 1...counts {
            self.colors.append(UIColor(named: "CCC\(i)")!)
            i = i-1 == 0 ? 12 : i-1
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
        for view in self.todayProgressView.subviews {
            view.removeFromSuperview()
        }
        
        fixed_sum = 0
        for i in 0..<counts {
            fixed_sum += datas[i]
        }
        var sum = Float(fixed_sum)
        todaySumtimeLabel.text = printTime(temp: fixed_sum)
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
            
            todayProgressView.addSubview(prog)
            
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
        todayProgressView.addSubview(block)
        return value
    }
    
    
    
    
    
    func goToViewController(where: String) {
        let vcName = self.storyboard?.instantiateViewController(withIdentifier: `where`)
        vcName?.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
        vcName?.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
        self.present(vcName!, animated: true, completion: nil)
    }
    
    
    
    func setHeight() {
        if(counts < 8) {
            subjectsHeight.constant = CGFloat(20*counts)
        }
    }
}

extension LogViewController: UICollectionViewDataSource {
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




extension LogViewController {
    
    
    
}


extension LogViewController {
    func showMonthTime() {
        let manager = DailyViewModel()
        manager.loadDailys()

        DispatchQueue.global().async {
            manager.totalStudyTimeOfMonth { totalTime in
                DispatchQueue.main.async {
                    self.monthTimeLabel.text = ViewManager.printTime(totalTime)
                }
            }
        }
    }
}
