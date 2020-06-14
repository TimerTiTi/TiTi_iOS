//
//  SetViewController.swift
//  Project_Timer
//
//  Created by Min_MacBook Pro on 2020/06/10.
//  Copyright © 2020 FDEE. All rights reserved.
//

import UIKit

class SetViewController: UIViewController {
    @IBOutlet var View1: UIView!
    @IBOutlet var View2: UIView!
    @IBOutlet var InputView1: UIView!
    @IBOutlet var InputView2: UIView!
    @IBOutlet var SetButton: UIButton!
    
    @IBOutlet var H1TextField: UITextField!
    @IBOutlet var M1TextField: UITextField!
    @IBOutlet var H2TextField: UITextField!
    @IBOutlet var M2TextField: UITextField!
    
    var second : Int = 3000
    var sum : Int = 0
    var allTime : Int = 28800
    var temp = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        
        H1TextField.keyboardType = .numberPad
        M1TextField.keyboardType = .numberPad
        H2TextField.keyboardType = .numberPad
        M2TextField.keyboardType = .numberPad
        
        View1.layer.cornerRadius = 14
        View2.layer.cornerRadius = 14
        InputView1.layer.cornerRadius = 10
        InputView2.layer.cornerRadius = 10
        SetButton.layer.cornerRadius = 10
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func SetButton(_ sender: UIButton) {
        //이전 화면으로 복귀
        if(check())
        {
            allTime = Int(H1TextField.text!)! * 3600 + Int(M1TextField.text!)! * 60
            second = Int(H2TextField.text!)! * 3600 + Int(M2TextField.text!)! * 60
        }
        
        UserDefaults.standard.set(second, forKey: "second")
        UserDefaults.standard.set(allTime, forKey: "allTime")
        print("set complite")
        self.dismiss(animated: true, completion: nil)
    }
    
    func check() -> Bool
    {
        if(H1TextField.text == "")
        {
            return false
        }
        if(M1TextField.text == "")
        {
            return false
        }
        if(H2TextField.text == "")
        {
            return false
        }
        if(M2TextField.text == "")
        {
            return false
        }
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension UIViewController {
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

