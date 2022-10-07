//
//  SetTimerViewController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2020/10/21.
//  Copyright © 2020 FDEE. All rights reserved.
//

import UIKit

class SetTimerViewController2: UIViewController {
    static let identifier = "SetTimerViewController2"
    
    @IBOutlet var Label_timer: UILabel!
    @IBOutlet var Text_H: UITextField!
    @IBOutlet var Text_M: UITextField!
    @IBOutlet var Text_S: UITextField!
    @IBOutlet var Button_set: UIButton!
    @IBOutlet var Button_Back: UIButton!
    @IBOutlet var Label_toTime: UILabel!
    
    @IBOutlet var Color1: UIButton!
    @IBOutlet var Color2: UIButton!
    @IBOutlet var Color3: UIButton!
    @IBOutlet var Color4: UIButton!
    @IBOutlet var Color5: UIButton!
    @IBOutlet var Color6: UIButton!
    @IBOutlet var Color7: UIButton!
    @IBOutlet var Color8: UIButton!
    
    @IBOutlet var targetLabel: UILabel!
    @IBOutlet var endLabel: UILabel!
    @IBOutlet var colorLabel: UILabel!
    @IBOutlet var ColorButton: UIButton!
    
    
    @IBOutlet var view1: UIView!
    @IBOutlet var view2: UIView!
    
    weak var delegate: NewRecordCreatable?
    
    var H = ""
    var M = ""
    var S = ""
    var h: Int = 0
    var m: Int = 0
    var s: Int = 0
    var goalTime: Int = 21600
    var COLOR = TiTiColor.background2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appTapGestureForDismissingKeyboard()
        setLocalizable()
        setRadius()
        
        goalTime = RecordController.shared.recordTimes.settedGoalTime
        COLOR = UserDefaults.standard.colorForKey(key: "color") as? UIColor ?? TiTiColor.background2
        Label_timer.text = printTime(temp: goalTime)
        
        Text_H.keyboardType = .numberPad
        Text_M.keyboardType = .numberPad
        Text_S.keyboardType = .numberPad
        
        updateColor()

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
        goalTime = h * 3600 + m * 60 + s
        Label_timer.text = printTime(temp: goalTime)
        Label_toTime.text = getFutureTime()
    }
    
    @IBAction func Button_set(_ sender: UIButton) {
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
    
    @IBAction func Button_Back_action(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ColorBTAction(_ sender: Any) {
        if #available(iOS 14.0, *) {
            let picker = UIColorPickerViewController()
            picker.selectedColor = COLOR!
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func SetColor(_ sender: UIButton) {
        let colorName: String = sender.currentTitle ?? "Background2"
        COLOR = UIColor(named: "\(colorName)")
        updateColor()
    }
}

extension SetTimerViewController2 {
    
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
    
    func getFutureTime() -> String {
        //log 날짜 설정
        let now = Date()
        let future = now.addingTimeInterval(TimeInterval(goalTime))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "hh:mm a"
        let today = dateFormatter.string(from: future)
        return today
    }
    
    func updateColor() {
        self.view.backgroundColor = COLOR
        Label_timer.textColor = COLOR
        Label_toTime.textColor = COLOR
        Button_set.layer.borderColor = UIColor.systemPink.cgColor
        Button_Back.layer.borderColor = UIColor.white.cgColor
    }
    
    func SET_action() {
        UserDefaults.standard.setColor(color: COLOR, forKey: "color")
        RecordController.shared.recordTimes.updateGoalTime(to: self.goalTime)
        UserDefaultsManager.set(to: self.goalTime, forKey: .goalTimeOfDaily)
        print("set complite")
        self.delegate?.newRecord()
        self.dismiss(animated: true, completion: nil)
    }
    
    func setRadius() {
        Button_set.layer.cornerRadius = 12
        Button_set.layer.borderWidth = 3
        
        Button_Back.layer.cornerRadius = 12
        Button_Back.layer.borderWidth = 3
        ColorButton.layer.cornerRadius = 5
        ColorButton.clipsToBounds = true
        
        Color1.layer.cornerRadius = 5
        Color2.layer.cornerRadius = 5
        Color3.layer.cornerRadius = 5
        Color4.layer.cornerRadius = 5
        Color5.layer.cornerRadius = 5
        Color6.layer.cornerRadius = 5
        Color7.layer.cornerRadius = 5
        Color8.layer.cornerRadius = 5
        
        view1.layer.cornerRadius = 15
        view2.layer.cornerRadius = 15
    }
    
    func setLocalizable() {
        targetLabel.text = "Target Time2".localized()
        endLabel.text = "End Time".localized()
        colorLabel.text = "Change Background Color".localized()
//        ColorButton.setTitle("Change background Color".localized(), for: .normal)
    }
}


extension SetTimerViewController2 : UIColorPickerViewControllerDelegate {
    
    @available(iOS 14.0, *)
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        print(viewController.selectedColor)
        COLOR = viewController.selectedColor
        updateColor()
    }
    
    @available(iOS 14.0, *)
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        print(viewController.selectedColor)
        COLOR = viewController.selectedColor
        updateColor()
    }
}


