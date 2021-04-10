//
//  SetTimerViewController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2020/10/21.
//  Copyright © 2020 FDEE. All rights reserved.
//

import UIKit

class SetTimerViewController: UIViewController {
    
    @IBOutlet var Label_timer: UILabel!
    @IBOutlet var Text_H: UITextField!
    @IBOutlet var Text_M: UITextField!
    @IBOutlet var Text_S: UITextField!
    @IBOutlet var Button_set: UIButton!
    @IBOutlet var Button_Back: UIButton!
    @IBOutlet weak var Label_toTime: UILabel!
    
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var endLabel: UILabel!
    
    var SetTimerViewControllerDelegate : ChangeViewController!
    
    var H = ""
    var M = ""
    var S = ""
    var h: Int = 0
    var m: Int = 0
    var s: Int = 0
    var second: Int = 2400
    
    let BLUE = UIColor(named: "Blue")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        setLocalizable()
        
        second = UserDefaults.standard.value(forKey: "second") as? Int ?? 2400
        Label_timer.text = printTime(temp: second)
        
        Text_H.keyboardType = .numberPad
        Text_M.keyboardType = .numberPad
        Text_S.keyboardType = .numberPad
        
        Button_set.layer.cornerRadius = 10
        Button_set.layer.borderWidth = 2
        Button_set.layer.borderColor = BLUE?.cgColor
        
        Button_Back.layer.cornerRadius = 10
        Button_Back.layer.borderWidth = 2
        Button_Back.layer.borderColor = UIColor.white.cgColor

        Text_H.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        Text_M.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        Text_S.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        //종료예정시간 보이기
        Label_toTime.text = getFutureTime()
    }
    @objc func textFieldDidChange(textField: UITextField){
        H = Text_H.text!
        M = Text_M.text!
        S = Text_S.text!
        
        check()
        second = h * 3600 + m * 60 + s
        Label_timer.text = printTime(temp: second)
        Label_toTime.text = getFutureTime()
    }
    
    func check()
    {
        if (H != "")
        {
            h = Int(H)!
            m = 0
            s = 0
        }
        if (M != "")
        {
            if(H == "")
            {
                h = 0
            }
            m = Int(M)!
            s = 0
        }
        if (S != "")
        {
            if(H == "")
            {
                h = 0
            }
            if(M == "")
            {
                m = 0
            }
            s = Int(S)!
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
    
    @IBAction func Button_set(_ sender: UIButton) {
        UserDefaults.standard.set(second, forKey: "second")
        print("set complite")
        SetTimerViewControllerDelegate.changeTimer()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Button_Back_adtion(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getFutureTime() -> String
    {
        //log 날짜 설정
        let now = Date()
        let future = now.addingTimeInterval(TimeInterval(second))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "hh:mm a"
        let today = dateFormatter.string(from: future)
        return today
    }
    
    func setLocalizable() {
        timerLabel.text = "Timer Time".localized()
        endLabel.text = "End Time".localized()
    }
}
