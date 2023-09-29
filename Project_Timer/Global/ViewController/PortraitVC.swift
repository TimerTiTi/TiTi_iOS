//
//  PortraitVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/09/29.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit

class PortraitVC: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configurePortraitOrientationForIphone()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.disablePortraitOrientationForIphone()
    }
    
    // MARK: Orientation
    private func configurePortraitOrientationForIphone() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            AppDelegate.shared.shouldSupportPortraitOrientation = true
        }
    }
    
    private func disablePortraitOrientationForIphone() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            AppDelegate.shared.shouldSupportPortraitOrientation = false
        }
    }
}
