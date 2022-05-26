//
//  SetViewController.swift
//  Project_Timer
//
//  Created by Min_MacBook Pro on 2020/06/10.
//  Copyright © 2020 FDEE. All rights reserved.
//

import UIKit

class SetViewController: UIViewController {
    static let identifier = "SetViewController"

    @IBOutlet var SetButton: UIButton!
    @IBOutlet var BackButton: UIButton!
    @IBOutlet var H1TextField: UITextField!
    @IBOutlet var M1TextField: UITextField!
    @IBOutlet var S1TextField: UITextField!
    @IBOutlet var H2TextField: UITextField!
    @IBOutlet var M2TextField: UITextField!
    @IBOutlet var S2TextField: UITextField!
    @IBOutlet var AllTimeLabel: UILabel!
    @IBOutlet var SecondLabel: UILabel!
    @IBOutlet var view1: UIView!
    @IBOutlet var view2: UIView!
    
    @IBOutlet var targetLabel: UILabel!
    @IBOutlet var timerLabel: UILabel!
    
    weak var delegate: NewRecordCreatable?
    var allTime : Int = 21600
    var second : Int = 2400
    
    var H1 = ""
    var M1 = ""
    var H2 = ""
    var M2 = ""
    var S1 = ""
    var S2 = ""
    var h1 = 6
    var h2 = 0
    var m1 = 0
    var m2 = 40
    var s1 = 0
    var s2 = 0
    
    let BLUE = UIColor(named: "Blue")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        setLocalizable()
        
        allTime = RecordController.shared.recordTimes.settedGoalTime
        AllTimeLabel.text = printTime(temp: allTime)
        second = RecordController.shared.recordTimes.settedTimerTime
        SecondLabel.text = printTime(temp: second)
        getHMS1()
        getHMS2()
        
        H1TextField.keyboardType = .numberPad
        M1TextField.keyboardType = .numberPad
        H2TextField.keyboardType = .numberPad
        M2TextField.keyboardType = .numberPad
        S1TextField.keyboardType = .numberPad
        S2TextField.keyboardType = .numberPad
        
        setRadius()
        
        H1TextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        M1TextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        H2TextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        M2TextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        S1TextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        S2TextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        H1 = H1TextField.text!
        H2 = H2TextField.text!
        M1 = M1TextField.text!
        M2 = M2TextField.text!
        S1 = S1TextField.text!
        S2 = S2TextField.text!
        
        check()
        
        allTime = h1 * 3600 + m1 * 60 + s1
        second = h2 * 3600 + m2 * 60 + s2
        
        AllTimeLabel.text = printTime(temp: allTime)
        SecondLabel.text = printTime(temp: second)
    }
    
    @IBAction func SetButton(_ sender: UIButton) {
        let message = "The recording of the new date begins.".localized() + "\n"+Date().YYYYMMDDstyleString
        let alert = UIAlertController(title:"New Record".localized(),message: message,preferredStyle: UIAlertController.Style.alert)
        let cancel = UIAlertAction(title: "CANCEL", style: .destructive, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { action in
            self.SET_action()
        })
        alert.addAction(cancel)
        alert.addAction(okAction)
        
        present(alert,animated: true,completion: nil)
    }
    
    
    @IBAction func Backbutton_action(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func check()
    {
        if (H1 != "")
        {
            h1 = Int(H1)!
            m1 = 0
            s1 = 0
        }
        if (H2 != "")
        {
            h2 = Int(H2)!
            m2 = 0
            s2 = 0
        }
        if (M1 != "")
        {
            if(H1 == "")
            {
                h1 = 0
            }
            m1 = Int(M1)!
            s1 = 0
        }
        if (M2 != "")
        {
            if(H2 == "")
            {
                h2 = 0
            }
            m2 = Int(M2)!
            s2 = 0
        }
        if (S1 != "")
        {
            if(H1 == "")
            {
                h1 = 0
            }
            if(M1 == "")
            {
                m1 = 0
            }
            s1 = Int(S1)!
        }
        if (S2 != "")
        {
            if(H2 == "")
            {
                h2 = 0
            }
            if(M2 == "")
            {
                m2 = 0
            }
            s2 = Int(S2)!
        }
    }
    
    func getHMS1()
    {
        s1 = allTime%60
        h1 = allTime/3600
        m1 = allTime/60 - h1*60
    }
    
    func getHMS2()
    {
        s2 = second%60
        h2 = second/3600
        m2 = second/60 - h2*60
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
    
    func SET_action() {
        RecordController.shared.recordTimes.updateGoalTime(to: self.allTime)
        RecordController.shared.recordTimes.updateTimerTime(to: self.second)
        print("set complite")
        self.delegate?.newRecord()
        self.dismiss(animated: true, completion: nil)
    }
    
    func setLocalizable() {
        targetLabel.text = "Target Time2".localized()
        timerLabel.text = "Timer Time".localized()
    }
    
    func setRadius() {
        SetButton.layer.cornerRadius = 12
        SetButton.layer.borderWidth = 3
        SetButton.layer.borderColor = UIColor.systemPink.cgColor
        
        BackButton.layer.cornerRadius = 12
        BackButton.layer.borderWidth = 3
        BackButton.layer.borderColor = UIColor.white.cgColor
        
        view1.layer.cornerRadius = 15
        view2.layer.cornerRadius = 15
    }
}

