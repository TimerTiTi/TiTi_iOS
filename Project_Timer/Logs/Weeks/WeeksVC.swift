//
//  WeeksVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/07/30.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit
import Combine
import SwiftUI
import FSCalendar

final class WeeksVC: UIViewController {
    static let identifier = "WeeksVC"
    @IBOutlet var calendar: FSCalendar!
    @IBOutlet weak var graphsScrollView: UIScrollView!
    @IBOutlet weak var graphsContentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func changeColor(_ sender: UIButton) {
        
    }
    
    @IBAction func saveGraphsToLibrary(_ sender: Any) {
        
    }
    
    @IBAction func shareGraphs(_ sender: UIButton) {
        
    }
}
