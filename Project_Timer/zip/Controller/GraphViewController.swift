//
//  GraphViewController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/02/23.
//  Copyright © 2021 FDEE. All rights reserved.
//

import UIKit
import SwiftUI

class GraphViewController: UIViewController {

    
    @IBOutlet var viewOfView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let hostingController = UIHostingController(rootView: ContentView())
        hostingController.view.translatesAutoresizingMaskIntoConstraints = true
        hostingController.view.frame = viewOfView.bounds
        ContentView().appendDailyDatas(isDummy: false)
//        ContentView().appendDumyDatas()
        addChild(hostingController)
        viewOfView.addSubview(hostingController.view)
    }
    override func viewDidDisappear(_ animated: Bool) {
        ContentView().reset()
    }
}
