//
//  CMAttitude+Extension.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/07/19.
//  Copyright © 2022 FDEE. All rights reserved.
//

import CoreMotion

extension CMAttitude {
    var isFaceDown: Bool {
        let isRollFaceDown = abs(roll) > 2.35
        let isPitchFaceDown = abs(pitch) < 0.8
        
        return isRollFaceDown && isPitchFaceDown
    }
    
    var isFaceUp: Bool {
        return !isFaceDown
    }
}
