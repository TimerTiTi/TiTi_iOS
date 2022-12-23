//
//  SyncDailysVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/12/23.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Combine

typealias DailysSyncable = (TestServerUserDailysInfoFetchable & TestServerDailyFetchable)

final class SyncDailysVM {
    private let networkController: DailysSyncable
    private let targetDailys: [Daily]
    @Published private(set) var userDailysInfo: UserDailysInfo?
    @Published private(set) var error: (title: String, text: String)?
    @Published private(set) var loading: Bool = false
    
    init(networkController: DailysSyncable, targetDailys: [Daily]) {
        self.networkController = networkController
        self.targetDailys = targetDailys
        
        self.getUserDailysInfo()
    }
}

extension SyncDailysVM {
    func uploadDailys() {
        self.loading = true
        self.networkController.uploadDailys(dailys: self.targetDailys) { [weak self] status in
            switch status {
            case .SUCCESS:
                self?.getDailys()
            default:
                self?.loading = false
                self?.error = ("Network Error", "status: \(status.rawValue)")
            }
        }
    }
}

extension SyncDailysVM {
    private func getUserDailysInfo() {
        self.networkController.getUserDailysInfo { [weak self] status, userDailysInfo in
            switch status {
            case .SUCCESS:
                guard let userDailysInfo = userDailysInfo else {
                    self?.error = ("Network Error", "get userDailysInfo Error")
                    return
                }
                self?.loading = false
                self?.userDailysInfo = userDailysInfo
            case .DECODEERROR:
                self?.error = ("Decode Error", "Decode UserDailysInfo Error")
            default:
                self?.error = ("Network Error", "status: \(status.rawValue)")
            }
        }
    }
    
    private func getDailys() {
        self.networkController.getDailys { [weak self] status, dailys in
            switch status {
            case .SUCCESS:
                guard dailys.isEmpty == false else {
                    self?.loading = false
                    self?.error = ("Empty Dailys", "Check the Server's Dailys count")
                    return
                }
                
                self?.store(dailys)
            case .DECODEERROR:
                self?.loading = false
                self?.error = ("Decode Error", "Decode Dailys Error")
            default:
                self?.loading = false
                self?.error = ("Network Error", "status: \(status.rawValue)")
            }
        }
    }
}

extension SyncDailysVM {
    private func store(_ dailys: [Daily]) {
        // dailys 저장
        RecordController.shared.dailys.changeDailys(to: dailys)
        // userDailysInfo fetch
        self.getUserDailysInfo()
    }
}
