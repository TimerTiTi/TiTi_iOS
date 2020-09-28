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
    
    var day1: String = ""
    var time1: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        day1 = UserDefaults.standard.value(forKey: "day") as? String ?? "NO DATA"
        time1 = UserDefaults.standard.value(forKey: "time") as? String ?? "NO DATA"
        
        Label_day1.text = day1
        Label_time1.text = time1
    }
    

    

}
