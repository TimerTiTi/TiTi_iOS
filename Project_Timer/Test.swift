//
//  Test.swift
//  Project_Timer
//
//  Created by Min_MacBook Pro on 2020/07/17.
//  Copyright © 2020 FDEE. All rights reserved.
//

import UIKit

class Test: UIViewController {

    let BABYRED = UIColor(named: "Text")
    
    @IBOutlet var CircularProgress: CircularProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()

//        let cp = CircularProgressView(frame: CGRect(x: 10.0, y: 10.0, width: 250.0, height: 250.0))
//        cp.trackColor = UIColor.darkGray
//        cp.progressColor = BABYRED!
//        cp.tag = 101
//        self.view.addSubview(cp)
//        cp.center = self.view.center
//
//        self.perform(#selector(animateProgress), with: nil, afterDelay: 2.0)
        
        CircularProgress.trackColor = UIColor.darkGray
        CircularProgress.progressColor = BABYRED!
        CircularProgress.setProgressWithAnimation(duration: 1.0, value: 0.6, from: 0.0)
    }
    
    @objc func animateProgress() {
        let cP = self.view.viewWithTag(101) as! CircularProgressView
        cP.setProgressWithAnimation(duration: 1.0, value: 0.7, from: 0.0)
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
