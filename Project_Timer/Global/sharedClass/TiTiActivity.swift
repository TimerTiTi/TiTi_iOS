//
//  TiTiActivity.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/02/12.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation
import ActivityKit

@available(iOS 16.1, *)
final class TiTiActivity {
    static let shared = TiTiActivity()
    var activity: Activity<TiTiLockscreenAttributes>?
    private init() {}
}
