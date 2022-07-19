//
//  AppUtility.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/07/18.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class OrientationLocker {
    static let shared = OrientationLocker()
    
    private var lastOrientation: UIDeviceOrientation
    
    private init() {
        self.lastOrientation = UIDevice.current.orientation
    }
    
    func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        lastOrientation = UIDevice.current.orientation
        delegate.orientationLock = orientation
        UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
        print("LOCK orientation")
    }
    
    func unlockOrientation() {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate,
              delegate.orientationLock != UIInterfaceOrientationMask.all else { return }
        
        delegate.orientationLock = UIInterfaceOrientationMask.all
        UIDevice.current.setValue(lastOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
        print("UNLOCK orientation")
    }
}
