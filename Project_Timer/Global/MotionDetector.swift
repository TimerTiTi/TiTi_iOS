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
    private var isDetecting: Bool
    private var lastAttitude: CMAttitude?
    
    private init() {
        self.motion = CMMotionManager()
        self.isDetecting = false
    }
    
    func beginGeneratingMotionNotification() {
        guard self.motion.isDeviceMotionAvailable,
              self.isDetecting == false else { return }
        
        self.isDetecting = true
        self.motion.deviceMotionUpdateInterval = 0.1
        self.motion.startDeviceMotionUpdates(to: OperationQueue()) { [weak self] motion, error in
            guard error == nil,
                  let self = self,
                  let newAttitude = motion?.attitude else { return }
            
            let oldAttitude = self.lastAttitude ?? newAttitude
            self.lastAttitude = newAttitude
            
            if !oldAttitude.isFaceUp && newAttitude.isFaceUp {
                NotificationCenter.default.post(name: Self.orientationDidChangeToFaceUpNotification, object: self)
            }
            if !oldAttitude.isFaceDown && newAttitude.isFaceDown {
                NotificationCenter.default.post(name: Self.orientationDidChangeToFaceDownNotification, object: self)
            }
        }
    }
    
    func endGeneratingMotionNotification() {
        guard isDetecting == true else { return }
        
        self.motion.stopDeviceMotionUpdates()
        self.isDetecting = false
    }
}
