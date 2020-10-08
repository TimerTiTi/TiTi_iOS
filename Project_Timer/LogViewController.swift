//
//  LogViewController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2020/09/28.
//  Copyright © 2020 FDEE. All rights reserved.
//

import UIKit

class LogViewController: UIViewController {

    @IBOutlet var Label_day1: UILabel!
    @IBOutlet var Label_day2: UILabel!
    @IBOutlet var Label_day3: UILabel!
    @IBOutlet var Label_day4: UILabel!
    @IBOutlet var Label_day5: UILabel!
    @IBOutlet var Label_day6: UILabel!
    @IBOutlet var Label_day7: UILabel!
    
    @IBOutlet var Label_time1: UILabel!
    @IBOutlet var Label_time2: UILabel!
    @IBOutlet var Label_time3: UILabel!
    @IBOutlet var Label_time4: UILabel!
    @IBOutlet var Label_time5: UILabel!
    @IBOutlet var Label_time6: UILabel!
    @IBOutlet var Label_time7: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let day1 = UserDefaults.standard.value(forKey: "day1") as? String ?? "NO DATA"
        let day2 = UserDefaults.standard.value(forKey: "day2") as? String ?? "NO DATA"
        let day3 = UserDefaults.standard.value(forKey: "day3") as? String ?? "NO DATA"
        let day4 = UserDefaults.standard.value(forKey: "day4") as? String ?? "NO DATA"
        let day5 = UserDefaults.standard.value(forKey: "day5") as? String ?? "NO DATA"
        let day6 = UserDefaults.standard.value(forKey: "day6") as? String ?? "NO DATA"
        let day7 = UserDefaults.standard.value(forKey: "day7") as? String ?? "NO DATA"
        let time1 = UserDefaults.standard.value(forKey: "time1") as? String ?? "NO DATA"
        let time2 = UserDefaults.standard.value(forKey: "time2") as? String ?? "NO DATA"
        let time3 = UserDefaults.standard.value(forKey: "time3") as? String ?? "NO DATA"
        let time4 = UserDefaults.standard.value(forKey: "time4") as? String ?? "NO DATA"
        let time5 = UserDefaults.standard.value(forKey: "time5") as? String ?? "NO DATA"
        let time6 = UserDefaults.standard.value(forKey: "time6") as? String ?? "NO DATA"
        let time7 = UserDefaults.standard.value(forKey: "time7") as? String ?? "NO DATA"
        
        Label_day1.text = day1
        Label_day2.text = day2
        Label_day3.text = day3
        Label_day4.text = day4
        Label_day5.text = day5
        Label_day6.text = day6
        Label_day7.text = day7
        Label_time1.text = time1
        Label_time2.text = time2
        Label_time3.text = time3
        Label_time4.text = time4
        Label_time5.text = time5
        Label_time6.text = time6
        Label_time7.text = time7
        
//        Label_day1.text = day1
//        Label_day2.text = "10월 7일"
//        Label_day3.text = "10월 6일"
//        Label_day4.text = "10월 5일"
//        Label_day5.text = "10월 4일"
//        Label_day6.text = "10월 3일"
//        Label_day7.text = "10월 2일"
//        Label_time1.text = time1
//        Label_time2.text = "4:03:41"
//        Label_time3.text = "6:08:14"
//        Label_time4.text = "4:03:39"
//        Label_time5.text = "5:44:07"
//        Label_time6.text = "4:58:23"
//        Label_time7.text = "3:37:20"
    }
}
