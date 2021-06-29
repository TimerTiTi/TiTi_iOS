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
    //frame1
    @IBOutlet var frame1: UIView!
    @IBOutlet var view1: UIView!
    @IBOutlet var today: UILabel!
    @IBOutlet var sumTime: UILabel!
    @IBOutlet var maxTime: UILabel!
    @IBOutlet var timeline: UIView!
    @IBOutlet var mon: UIView!
    @IBOutlet var tue: UIView!
    @IBOutlet var wed: UIView!
    @IBOutlet var thu: UIView!
    @IBOutlet var fri: UIView!
    @IBOutlet var sat: UIView!
    @IBOutlet var sun: UIView!
    
    //frame2
    @IBOutlet var frame2: UIView!
    @IBOutlet var view2: UIView!
    @IBOutlet var today2: UILabel!
    @IBOutlet var progress: UIView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionHeight: NSLayoutConstraint!//160
    
    //frame3
    @IBOutlet var frame3: UIView!
    @IBOutlet var view3: UIView!
    @IBOutlet var view4_timeline: UIView!
    @IBOutlet var view4_progress: UIView!
    @IBOutlet var view4_collectionView: UICollectionView!
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
    
    //viewController
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var leftGesture: UIScreenEdgePanGestureRecognizer!
    
    @IBOutlet var check1: UIButton!
    @IBOutlet var check2: UIButton!
    @IBOutlet var check3: UIButton!
    
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
    
    @IBOutlet var selectDay: UIButton!
    
    let todayViewManager = TodayViewManager()
    var weeks: [UIView] = []
    var weeks2: [UIView] = []
    var dateIndex: Int?
    let dateFormatter = DateFormatter()
    
    let dailyViewModel = DailyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()

        weeks = [mon, tue, wed, thu, fri, sat, sun]
        weeks2 = [view4_mon, view4_tue, view4_wed, view4_thu, view4_fri, view4_sat, view4_sun]
        
        setRadius()
        setShadow(view1)
        setShadow(view2)
        setShadow(view3)
        
        //저장된 dailys들 로딩
        dailyViewModel.loadDailys()
        
        getColor()
        let isDumy: Bool = false //앱스토어 스크린샷을 위한 더미데이터 여부
        showDatas(isDumy: isDumy)
        showSwiftUIGraph(isDumy: isDumy)
        
        setChecks()
        leftGesture.edges = .left
        
        dateFormatter.dateFormat = "yyyy.MM.dd"
//        dumyDays = Dumy().getDumyDays(Dumy().getDumyStringDays())
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
        todayViewManager.saveChecks(check1, check2, check3)
        
        print("disappear in today")
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    @IBAction func saveImage(_ sender: Any) {
        todayViewManager.saveImages(frame1, frame2, frame3)
        showAlert()
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func check(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let index = Int(sender.tag)
        todayViewManager.updateChecks(index)
    }
    
    @IBAction func changeColor(_ sender: UIButton) {
        let i = Int(sender.tag)
        todayViewManager.setStartColorIndex(i)
        
        reset()
    }
    
    @IBAction func leftGestureAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showCalendar(_ sender: Any) {
        showCalendar()
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
    
    func getColor() {
        todayViewManager.startColor = UserDefaults.standard.value(forKey: "startColor") as? Int ?? 1
    }
    
    func showSwiftUIGraph(isDumy: Bool) {
        let startColor = todayViewManager.startColor
        let colorNow: Int = startColor
        var colorSecond: Int = 0
        if(!todayViewManager.reverseColor) {
            colorSecond = startColor+1 == 13 ? 1 : startColor+1
        } else {
            colorSecond = startColor-1 == 0 ? 12 : startColor-1
        }
        //frame1
        let hostingController = UIHostingController(rootView: todayContentView(colors: [Color("D\(colorSecond)"), Color("D\(colorNow)")], frameHeight: 128, height: 125))
        hostingController.view.translatesAutoresizingMaskIntoConstraints = true
        hostingController.view.frame = timeline.bounds
        todayContentView().appendTimes(isDumy: isDumy, daily: todayViewManager.daily)
        
        addChild(hostingController)
        timeline.addSubview(hostingController.view)
        
        todayContentView().reset()
        //frame3
        let hostingController2 = UIHostingController(rootView: todayContentView(colors: [Color("D\(colorSecond)"), Color("D\(colorNow)")], frameHeight: 97, height: 93))
        hostingController2.view.translatesAutoresizingMaskIntoConstraints = true
        hostingController2.view.frame = view4_timeline.bounds
        todayContentView().appendTimes(isDumy: isDumy, daily: todayViewManager.daily)
        
        addChild(hostingController2)
        view4_timeline.addSubview(hostingController2.view)
    }
    
    func showDatas(isDumy: Bool) {
        if(dateIndex == nil) {
            todayViewManager.daily.load()
        } else {
            //배열에 있는 daily 보이기
            todayViewManager.daily = dailyViewModel.dailys[dateIndex!]
//            todayViewManager.daily.day = dumyDays[dateIndex!]
        }
        
        if(isDumy) {
            todayViewManager.setDumyDaily()
        }
        if(todayViewManager.daily.tasks != [:]) {
            todayViewManager.setTasksColor()
            todayViewManager.setDay(today, today2, view4_today)
            todayViewManager.setWeek(weeks)
            todayViewManager.setWeek(weeks2)
            todayViewManager.getTasks()
            todayViewManager.makeProgress(progress, view4_progress)
            todayViewManager.showTimes(sumTime, view4_sumTime, maxTime, view4_maxTime)
            
            setHeight()
        } else {
            print("no data")
        }
    }
    
    func setChecks() {
        let checks = UserDefaults.standard.value(forKey: "checks") as? [Bool] ?? [true,true,true]
        check1.isSelected = checks[0]
        check2.isSelected = checks[1]
        check3.isSelected = checks[2]
        todayViewManager.checks = checks
    }
    
    func showAlert() {
        let alert = UIAlertController(title:"Save completed".localized(),
            message: "",
            preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert,animated: true,completion: nil)
    }
    
    func setHeight() {
        if(todayViewManager.array.count < 8) {
            collectionHeight.constant = CGFloat(20*todayViewManager.array.count)
        }
    }
    
    func showCalendar() {
        let setVC = storyboard?.instantiateViewController(withIdentifier: "calendarViewController") as! calendarViewController
        setVC.calendarViewControllerDelegate = self
        present(setVC,animated: true,completion: nil)
    }
    
    func reset() {
        for view in self.progress.subviews {
            view.removeFromSuperview()
        }
        for view in self.view4_progress.subviews {
            view.removeFromSuperview()
        }
        
        todayViewManager.reset()
        todayContentView().reset()
        self.viewDidLoad()
        self.view.layoutIfNeeded()
        collectionView.reloadData()
        view4_collectionView.reloadData()
    }
}

extension TodayViewController: selectCalendar {
    func getDailyIndex() {
        dateIndex = UserDefaults.standard.value(forKey: "dateIndex") as? Int ?? nil
        selectDay.setTitle(dateFormatter.string(from: dailyViewModel.dates[dateIndex!]), for: .normal)
        reset()
    }
}

extension TodayViewController: UICollectionViewDataSource {
    //몇개 표시 할까?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todayViewManager.counts
    }
    //셀 어떻게 표시 할까?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == self.collectionView) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "todayCell", for: indexPath) as? todayCell else {
                return UICollectionViewCell()
            }
            let counts = todayViewManager.counts
            let color = todayViewManager.colors[counts - indexPath.item - 1]
            cell.colorView.backgroundColor = color
            cell.colorView.layer.cornerRadius = 2
            cell.taskName.text = todayViewManager.arrayTaskName[counts - indexPath.item - 1]
            cell.taskTime.text = todayViewManager.arrayTaskTime[counts - indexPath.item - 1]
            cell.taskTime.textColor = color
            
            
            return cell
        }
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "todayCell2", for: indexPath) as? todayCell2 else {
                return UICollectionViewCell()
            }
            let counts = todayViewManager.counts
            let color = todayViewManager.colors[counts - indexPath.item - 1]
            cell.check.textColor = color
            cell.taskName.text = todayViewManager.arrayTaskName[counts - indexPath.item - 1]
            cell.taskTime.text = todayViewManager.arrayTaskTime[counts - indexPath.item - 1]
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
