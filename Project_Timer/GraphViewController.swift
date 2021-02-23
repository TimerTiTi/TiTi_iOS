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

    override func viewDidLoad() {
        super.viewDidLoad()

        let hostingController = UIHostingController(rootView: ContentView())
        hostingController.view.translatesAutoresizingMaskIntoConstraints = true
        hostingController.view.frame = view.bounds
        addChild(hostingController)
        view.addSubview(hostingController.view)
    }
}
