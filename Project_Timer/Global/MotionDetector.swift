//
//  MotionManager.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/07/18.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import CoreMotion

final class MotionDetector {
    static let shared = MotionDetector()
    
    static let orientationDidChangeToFaceDownNotification = Notification.Name("orientationDidChangeToFaceDownNotification")
    static let orientationDidChangeToFaceUpNotification = Notification.Name("orientationDidChangeToFaceUpNotification")
    
    private let motion: CMMotionManager
    private(set) var isDetecting: Bool
    private var isFaceDown: Bool?
    
    private init() {
        self.motion = CMMotionManager()
        self.isDetecting = false
    }
    
    func beginGeneratingMotionNotification() {
        guard self.motion.isDeviceMotionAvailable else { return }
        
        self.isDetecting = true
        self.motion.deviceMotionUpdateInterval = 0.05
        self.motion.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: OperationQueue()) { [weak self] motion, error  in
            guard error == nil,
                  let self = self,
                  let gravity = motion?.gravity else { return }
            
            let isFaceDownNow = gravity.z > 0.85
            let isFaceUpNow = !isFaceDownNow
            let isFaceDownBefore = self.isFaceDown ?? isFaceDownNow
            let isFaceUpBefore = !isFaceDownBefore
            
            if !isFaceUpBefore && isFaceUpNow {
                NotificationCenter.default.post(name: Self.orientationDidChangeToFaceUpNotification, object: self)
            }
            if !isFaceDownBefore && isFaceDownNow {
                NotificationCenter.default.post(name: Self.orientationDidChangeToFaceDownNotification, object: self)
            }
            
            self.isFaceDown = isFaceDownNow
        }
    }
    
    func endGeneratingMotionNotification() {
        self.motion.stopDeviceMotionUpdates()
        self.isDetecting = false
    }
}
