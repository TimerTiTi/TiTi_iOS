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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
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
        
        let rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "RootViewController") as! ViewController
        rootViewController.second = print(rootViewController.second)
        self.dismiss(animated: true, completion: nil)
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
