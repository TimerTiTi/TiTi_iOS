//
//  SyncDailysVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/12/23.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Combine

typealias DailysSyncable = (TestServerSyncLogFetchable & TestServerDailyFetchable & TestServerRecordTimesFetchable)

final class SyncDailysVM {
    private let networkController: DailysSyncable
    private var targetDailys: [Daily]
    @Published private(set) var syncLog: SyncLog?
    @Published private(set) var error: (title: String, text: String)?
    @Published private(set) var loading: Bool = false
    @Published private(set) var saveDailysSuccess: Bool = false
    private(set) var loadingText: SyncDailysVC.LoadingStatus?
    
    init(networkController: DailysSyncable, targetDailys: [Daily]) {
        self.networkController = networkController
        self.targetDailys = targetDailys
        // fetch 서버 syncLog
        self.getSyncLog(afterUploaded: false)
    }
}

extension SyncDailysVM {
    /// 동기화 버튼 클릭시 동기화 가능상태 확인 후 uploadDailys -> getDailys -> checkRecordTimes -> (uploadRecordTime or getRecordTime) -> getSyncLog 진행
    func checkSyncDailys() {
        guard self.targetDailys.isEmpty == false else {
            self.getDailys()
            return
        }
        
        self.uploadDailys()
    }
}

// MARK: Upload
extension SyncDailysVM {
    /// uploadDailys -> getDailys 진행
    private func uploadDailys() {
        self.loadingText = .uploadDailys
        self.loading = true
        self.networkController.uploadDailys(dailys: self.targetDailys) { [weak self] status in
            self?.loading = false
            switch status {
            case .SUCCESS:
                self?.getDailys()
            default:
                self?.error = ("Network Error", "UPLOAD SyncLog status: \(status.rawValue)")
            }
        }
    }
    
    /// uploadRecordTime -> getSyncLog 진행
    private func uploadRecordTime() {
        let recordTimes = RecordController.shared.recordTimes
        self.loadingText = .uploadRecordTime
        self.loading = true
        self.networkController.uploadRecordTimes(recordTimes: recordTimes) { [weak self] status in
            self?.loading = false
            switch status {
            case .SUCCESS:
                self?.getSyncLog(afterUploaded: true)
            default:
                self?.error = ("Network Error", "UPLOAD RecordTime status: \(status.rawValue)")
            }
        }
    }
}

// MARK: Get
extension SyncDailysVM {
    /// getDailys -> checkRecordTimes 진행
    private func getDailys() {
        self.loadingText = .getDailys
        self.loading = true
        self.networkController.getDailys { [weak self] status, dailys in
            switch status {
            case .SUCCESS:
                guard dailys.isEmpty == false else {
                    self?.loading = false
                    self?.error = ("Empty Dailys", "Check the Server's Dailys count")
                    return
                }
                
                self?.saveDailys(dailys)
                self?.loading = false
                self?.checkRecordTimes()
            case .DECODEERROR:
                self?.loading = false
                self?.error = ("Decode Error", "Decode Dailys")
            default:
                self?.loading = false
                self?.error = ("Network Error", "GET Dailys status: \(status.rawValue)")
            }
        }
    }
    
    /// getRecordTime -> getSyncLog 진행
    private func getRecordtime() {
        self.loadingText = .getRecordTime
        self.loading = true
        self.networkController.getRecordTimes { [weak self] status, recordTimes in
            switch status {
            case .SUCCESS:
                guard let recordTimes = recordTimes else {
                    self?.loading = false
                    self?.error = ("Network Error", "GET Recordtime")
                    return
                }
                
                self?.saveRecordTimes(recordTimes)
                self?.loading = false
                self?.getSyncLog(afterUploaded: true)
            case .DECODEERROR:
                self?.loading = false
                self?.error = ("Decode Error", "Decode RecordTimes")
            default:
                self?.loading = false
                self?.error = ("Network Error", "GET RecordTimes status: \(status.rawValue)")
            }
        }
    }
    
    /// sync 로직 후 getSyncLog, 또는 화면진입시 진행
    private func getSyncLog(afterUploaded: Bool) {
        self.loadingText = .getSyncLog
        self.loading = true
        self.networkController.getSyncLog { [weak self] status, syncLog in
            self?.loading = false
            switch status {
            case .SUCCESS:
                guard let syncLog = syncLog else {
                    if (afterUploaded) {
                        self?.error = ("Network Error", "GET SyncLog")
                    }
                    // server 상에 아직 정보가 없는 경우 nil 상태
                    return
                }
                
                if (afterUploaded) {
                    self?.saveLastUploadedDate(to: syncLog.updatedAt)
                    self?.saveDailysSuccess = true
                }
                self?.syncLog = syncLog
            case .DECODEERROR:
                self?.error = ("Decode Error", "Decode SyncLog")
            default:
                self?.error = ("Network Error", "GET SyncLog status: \(status.rawValue)")
            }
        }
    }
}

// MARK: Save
extension SyncDailysVM {
    private func saveDailys(_ dailys: [Daily]) {
        // dailys 저장
        RecordController.shared.dailys.changeDailys(to: dailys)
        // MARK: daily 반영 로직 구현
        
    }
    
    private func saveRecordTimes(_ recordtimes: RecordTimes) {
        
    }
    
    private func saveLastUploadedDate(to date: Date) {
        UserDefaultsManager.set(to: date, forKey: .lastUploadedDateV1)
    }
}

// MARK: Check
extension SyncDailysVM {
    private func checkRecordTimes() {
        guard let lastDaily = RecordController.shared.dailys.dailys.last,
              let dailyStartAt = lastDaily.taskHistorys?.values
            .flatMap({ $0 })
            .sorted(by: { $0.endDate < $1.endDate })
            .last?.startDate else { return }
        let localStartAt = RecordController.shared.recordTimes.recordStartAt
        print(dailyStartAt, localStartAt)
        
        if (dailyStartAt == localStartAt) {
            // update RecordTime
            self.uploadRecordTime()
        } else {
            // get RecordTime
            self.getRecordtime()
        }
    }
}
