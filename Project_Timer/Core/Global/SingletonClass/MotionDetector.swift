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
    private var isFaceDown: Bool? /// 직전값
    
    private init() {
        self.motion = CMMotionManager()
        self.isDetecting = false
    }
    
    func beginGeneratingMotionNotification() {
        /// 센서가 없는 경우 return
        guard self.motion.isDeviceMotionAvailable else { return }
        /// 동작과 상관없이 항상 계산이 진행되는 코드
        self.isDetecting = true
        self.motion.deviceMotionUpdateInterval = 0.1 /// 0.1초 간격으로 detect
        self.motion.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: OperationQueue()) { [weak self] data, error  in
            guard error == nil,
                  let self = self,
                  let gravity = data?.gravity else { return }
            
            let isFaceDownNow = gravity.z > 0.65 /// 독서대에서 뒤집는 각을 고려한 뒤집었다고 판정되는 vector 기준값
            let isFaceUpNow = !isFaceDownNow
            let isFaceDownBefore = self.isFaceDown ?? isFaceDownNow
            let isFaceUpBefore = !isFaceDownBefore
            
            if !isFaceUpBefore && isFaceUpNow { /// faceDown -> faceUp 변화시
                NotificationCenter.default.post(name: Self.orientationDidChangeToFaceUpNotification, object: self)
            }
            if !isFaceDownBefore && isFaceDownNow { /// faceUp -> faceDown 변화시
                NotificationCenter.default.post(name: Self.orientationDidChangeToFaceDownNotification, object: self)
            }
            
            self.isFaceDown = isFaceDownNow /// 직건값 update
        }
    }
    
    func stopGeneratingMotionNotification() {
        self.motion.stopDeviceMotionUpdates()
        self.isDetecting = false
    }
}
