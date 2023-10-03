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
            // TODO: server date 값과 device date 값이 같은 경우 불필요 로직 필요
            self.getDailys()
            return
        }
        
        self.uploadDailys()
    }
    
    func updateTargetDailys(to dailys: [Daily]) {
        self.targetDailys = dailys
    }
}

// MARK: Upload
extension SyncDailysVM {
    /// uploadDailys -> getDailys 진행
    private func uploadDailys() {
        self.loadingText = .uploadDailys
        self.loading = true
        self.networkController.uploadDailys(dailys: self.targetDailys) { [weak self] result in
            self?.loading = false
            switch result {
            case .success(_):
                self?.getDailys()
            case .failure(let error):
                switch error {
                case .CLIENTERROR(let message):
                    if let message = message {
                        print("[upload Dailys ERROR] \(message)")
                    }
                    self?.error = (title: "Upload Fail".localized(), text: "Please update to the latest version".localized())
                default:
                    self?.error = error.alertMessage
                }
            }
        }
    }
    
    /// uploadRecordTime -> getSyncLog 진행
    private func uploadRecordTime() {
        let recordTimes = RecordsManager.shared.recordTimes
        self.loadingText = .uploadRecordTime
        self.loading = true
        self.networkController.uploadRecordTimes(recordTimes: recordTimes) { [weak self] result in
            self?.loading = false
            switch result {
            case .success(_):
                self?.getSyncLog(afterUploaded: true)
            case .failure(let error):
                switch error {
                case .CLIENTERROR(let message):
                    if let message = message {
                        print("[upload Recordtime ERROR] \(message)")
                    }
                    self?.error = (title: "Upload Fail".localized(), text: "Please update to the latest version".localized())
                default:
                    self?.error = error.alertMessage
                }
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
        self.networkController.getDailys { [weak self] result in
            switch result {
            case .success(let dailys):
                self?.saveDailys(dailys)
                self?.loading = false
                self?.checkRecordTimes()
            case .failure(let error):
                self?.loading = false
                switch error {
                case .CLIENTERROR(let message):
                    if let message = message {
                        print("[get Dailys ERROR] \(message)")
                    }
                    self?.error = (title: "Download Fail".localized(), text: "Please update to the latest version".localized())
                default:
                    self?.error = error.alertMessage
                }
            }
        }
    }
    
    /// getRecordTime -> getSyncLog 진행
    private func getRecordtime() {
        self.loadingText = .getRecordTime
        self.loading = true
        self.networkController.getRecordTimes { [weak self] result in
            switch result {
            case .success(let recordTimes):
                self?.saveRecordTimes(recordTimes)
                self?.loading = false
                self?.getSyncLog(afterUploaded: true)
            case .failure(let error):
                switch error {
                case .CLIENTERROR(let message):
                    if let message = message {
                        print("[get RecordTimes ERROR] \(message)")
                    }
                    self?.error = (title: "Download Fail".localized(), text: "Please update to the latest version".localized())
                default:
                    self?.error = error.alertMessage
                }
            }
        }
    }
    
    /// sync 로직 후 getSyncLog, 또는 화면진입시 진행
    private func getSyncLog(afterUploaded: Bool) {
        self.loadingText = .getSyncLog
        self.loading = true
        self.networkController.getSyncLog { [weak self] result in
            self?.loading = false
            switch result {
            case .success(let syncLog):
                if (afterUploaded) {
                    self?.saveLastUploadedDate(to: syncLog.updatedAt)
                    self?.targetDailys = []
                    self?.saveDailysSuccess = true
                }
                self?.syncLog = syncLog
            case .failure(let error):
                switch error {
                case .CLIENTERROR(let message):
                    if let message = message {
                        print("[get SyncLog ERROR] \(message)")
                    }
                    self?.error = (title: "Download Fail".localized(), text: "Please update to the latest version".localized())
                default:
                    self?.error = error.alertMessage
                }
            }
        }
    }
}

// MARK: Save
extension SyncDailysVM {
    private func saveDailys(_ dailys: [Daily]) {
        // dailys 저장
        RecordsManager.shared.dailyManager.changeDailys(to: dailys)
        
        if let daily = RecordsManager.shared.dailyManager.dailys.last {
            RecordsManager.shared.currentDaily = daily
            RecordsManager.shared.currentDaily.save()
        }
    }
    
    private func saveRecordTimes(_ recordtimes: RecordTimes) {
        // TODO: 상단 날짜가 이상한점 확인 필요
        RecordsManager.shared.recordTimes = recordtimes
        RecordsManager.shared.recordTimes.save()
    }
    
    private func saveLastUploadedDate(to date: Date) {
        UserDefaultsManager.set(to: date, forKey: .lastUploadedDateV1)
    }
}

// MARK: Check
extension SyncDailysVM {
    private func checkRecordTimes() {
        guard let lastDaily = RecordsManager.shared.dailyManager.dailys.last,
              let dailyStartAt = lastDaily.taskHistorys?.values
            .flatMap({ $0 })
            .sorted(by: { $0.endDate < $1.endDate })
            .last?.startDate else { return }
        let localStartAt = RecordsManager.shared.recordTimes.recordStartAt
        
        if (dailyStartAt.YYYYMMDDHMSstyleString == localStartAt.YYYYMMDDHMSstyleString) {
            self.uploadRecordTime()
        } else {
            self.getRecordtime()
        }
    }
}
