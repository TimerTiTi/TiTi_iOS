//
//  firstViewController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/05/11.
//  Copyright © 2021 FDEE. All rights reserved.
//

import UIKit

class firstViewController: UIViewController {
    @IBOutlet var taskButton: UIButton!
    @IBOutlet var innerProgress: CircularProgressView!
    @IBOutlet var outterProgress: CircularProgressView!
    
    @IBOutlet var sumTimeLabel: UILabel!
    @IBOutlet var TIMEofSum: UILabel!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var TIMEofTimer: UILabel!
    @IBOutlet var targetTimeLabel: UILabel!
    @IBOutlet var TIMEofTarget: UILabel!
    @IBOutlet var finishTimeLabel: UILabel!
    
    @IBOutlet var modeTimer: UIButton!
    @IBOutlet var modeTimerLabel: UILabel!
    @IBOutlet var modeStopWatch: UIButton!
    @IBOutlet var modeStopWatchLabel: UILabel!
    @IBOutlet var log: UIButton!
    @IBOutlet var logLabel: UILabel!
    
    @IBOutlet var startStopBT: UIButton!
    @IBOutlet var startStopBTLabel: UILabel!
    @IBOutlet var setTimerBT: UIButton!
    @IBOutlet var setTimerBTLabel: UILabel!
    @IBOutlet var settingBT: UIButton!
    @IBOutlet var settingBTLabel: UILabel!
    @IBOutlet var dock: UIView!
    @IBOutlet var grayLayer: UIView!
    
    @IBOutlet var arrow1: UILabel!
    @IBOutlet var text1: UILabel!
    @IBOutlet var arrow2: UILabel!
    @IBOutlet var text2: UILabel!
    @IBOutlet var arrow3: UILabel!
    @IBOutlet var arrow4: UILabel!
    @IBOutlet var arrow5: UILabel!
    @IBOutlet var arrow6: UILabel!
    @IBOutlet var text5: UILabel!
    @IBOutlet var arrow7: UILabel!
    @IBOutlet var text7: UILabel!
    @IBOutlet var nextBT: UIButton!
    
    let BLUE = UIColor(named: "Blue")
    let BUTTON = UIColor(named: "Button")
    let CLICK = UIColor(named: "Click")
    let RED = UIColor(named: "Text")
    let INNER = UIColor(named: "innerColor")
    
    var nextCount: Int = 1
    var isFirst: Bool = true
    
    override func viewDidAppear(_ animated: Bool) {
        isFirst = UserDefaults.standard.value(forKey: "isFirst") as? Bool ?? true
        checkIsFirst()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalizable()
        setButtonRotation()
        setRadius()
        setShadow()
        setBorner()
        stopColor()
        
        setAlpha()
        ani1()
    }
    
    @IBAction func nextAction(_ sender: Any) {
        nextCount += 1
        switch(nextCount) {
        case 2: ani2()
        case 3: ani3()
        case 4: ani4()
        case 5: ani5()
        case 6: ani6()
        default:
            UserDefaults.standard.set(false, forKey: "isFirst")
            goToViewController(where: "TimerViewController")
        }
    }
}

extension firstViewController {
    func checkIsFirst() {
        print(isFirst)
        if(!isFirst) {
            let VCNum = UserDefaults.standard.value(forKey: "VCNum") as? Int ?? 1
            if(VCNum == 2) {
                goToViewController(where: "StopwatchViewController")
            } else {
                goToViewController(where: "TimerViewController")
            }
        }
    }
    func setLocalizable() {
        sumTimeLabel.text = "Sum Time".localized()
        timerLabel.text = "Timer".localized()
        targetTimeLabel.text = "Target Time".localized()
    }
    func setButtonRotation() {
        modeTimer.transform = CGAffineTransform(rotationAngle: .pi*8/9)
        log.transform = CGAffineTransform(rotationAngle: .pi*1/9)
    }
    func setRadius() {
        taskButton.layer.cornerRadius = 12
        
        startStopBT.layer.cornerRadius = 15
        setTimerBT.layer.cornerRadius = 15
        settingBT.layer.cornerRadius = 15
        
        modeTimer.layer.cornerRadius = 10
        modeStopWatch.layer.cornerRadius = 10
        log.layer.cornerRadius = 10
        
        dock.layer.cornerRadius = 20
    }
    func setShadow() {
        startStopBT.layer.shadowColor = UIColor(named: "darkRed")!.cgColor
        startStopBT.layer.shadowOpacity = 0.3
        startStopBT.layer.shadowOffset = CGSize.zero
        startStopBT.layer.shadowRadius = 3
        
        setTimerBT.layer.shadowColor = UIColor.gray.cgColor
        setTimerBT.layer.shadowOpacity = 0.5
        setTimerBT.layer.shadowOffset = CGSize.zero
        setTimerBT.layer.shadowRadius = 4
        
        settingBT.layer.shadowColor = UIColor.gray.cgColor
        settingBT.layer.shadowOpacity = 0.5
        settingBT.layer.shadowOffset = CGSize.zero
        settingBT.layer.shadowRadius = 4
        
        modeStopWatch.layer.shadowColor = UIColor.gray.cgColor
        modeStopWatch.layer.shadowOpacity = 0.4
        modeStopWatch.layer.shadowOffset = CGSize.zero
        modeStopWatch.layer.shadowRadius = 4
        
        log.layer.shadowColor = UIColor.gray.cgColor
        log.layer.shadowOpacity = 0.4
        log.layer.shadowOffset = CGSize.zero
        log.layer.shadowRadius = 4
    }
    func setBorner() {
        startStopBT.layer.borderWidth = 3
        startStopBT.layer.borderColor = RED!.cgColor
        taskButton.layer.borderWidth = 2
    }
    func stopColor() {
        self.grayLayer.alpha = 0
        self.view.backgroundColor = BLUE
        outterProgress.progressColor = UIColor.white
        innerProgress.progressColor = INNER!
        startStopBT.backgroundColor = RED!
        TIMEofTimer.textColor = UIColor.white
        //예상종료시간 보이기, stop 버튼 제자리로 이동
        UIView.animate(withDuration: 0.3, animations: {
            self.setTimerBT.alpha = 1
            self.settingBT.alpha = 1
            self.taskButton.layer.borderColor = UIColor.white.cgColor
            self.startStopBTLabel.textColor = UIColor.white
            self.setTimerBTLabel.alpha = 1
            self.settingBTLabel.alpha = 1
            self.taskButton.transform = CGAffineTransform(translationX: 0, y: 0)
            self.dock.backgroundColor = UIColor(named: "dock")
        })
        //animation test
        UIView.animate(withDuration: 0.5, animations: {
            self.grayLayer.alpha = 1
            self.modeTimer.alpha = 1
            self.modeStopWatch.alpha = 1
            self.log.alpha = 1
            self.modeTimerLabel.alpha = 1
            self.modeStopWatchLabel.alpha = 1
            self.logLabel.alpha = 1
        })
    }
}

extension firstViewController {
    func setAlpha() {
        arrow1.alpha = 0
        text1.alpha = 0
        arrow2.alpha = 0
        text2.alpha = 0
        arrow3.alpha = 0
        arrow4.alpha = 0
        arrow5.alpha = 0
        arrow6.alpha = 0
        text5.alpha = 0
        arrow7.alpha = 0
        text7.alpha = 0
    }
    func ani1() {
        UIView.animate(withDuration: 0.3) {
            self.arrow1.alpha = 1
            self.text1.alpha = 1
        }
    }
    func ani2() {
        UIView.animate(withDuration: 0.3) {
            self.arrow1.alpha = 0
            self.text1.alpha = 0
            self.arrow2.alpha = 1
            self.text2.alpha = 1
        }
    }
    func ani3() {
        UIView.animate(withDuration: 0.3) {
            self.arrow2.alpha = 0
            self.arrow3.alpha = 1
            self.text2.text = "start, stop button"
        }
    }
    func ani4() {
        UIView.animate(withDuration: 0.3) {
            self.arrow3.alpha = 0
            self.arrow4.alpha = 1
            self.text2.text = "you can setting timer time"
        }
    }
    func ani5() {
        UIView.animate(withDuration: 0.3) {
            self.arrow4.alpha = 0
            self.text2.alpha = 0
            self.arrow5.alpha = 1
            self.arrow6.alpha = 1
            self.text5.alpha = 1
        }
    }
    func ani6() {
        UIView.animate(withDuration: 0.3) {
            self.arrow5.alpha = 0
            self.arrow6.alpha = 0
            self.text5.alpha = 0
            self.arrow7.alpha = 1
            self.text7.alpha = 1
            self.nextBT.setTitle("FINISH", for: .normal)
        }
    }
    func goToViewController(where: String) {
        let vcName = self.storyboard?.instantiateViewController(withIdentifier: `where`)
        vcName?.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
        vcName?.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
        self.present(vcName!, animated: true, completion: nil)
    }
}
