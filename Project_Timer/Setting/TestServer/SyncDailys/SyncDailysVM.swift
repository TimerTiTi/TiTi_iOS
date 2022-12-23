//
//  SyncDailysVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/12/23.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Combine

typealias DailysSyncable = (TestServerUserInfoFetchable & TestServerDailyFetchable)

final class SyncDailysVM {
    private let networkController: DailysSyncable
    private let targetDailys: [Daily]
    @Published private(set) var userInfo: UserDailysStatus?
    
    init(networkController: DailysSyncable, targetDailys: [Daily]) {
        self.networkController = networkController
        self.targetDailys = targetDailys
    }
}
