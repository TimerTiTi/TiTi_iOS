//
//  SyncDailysVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/12/23.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit
import Combine

final class SyncDailysVC: UIViewController {
    static let identifier = "SyncDailysVC"
    enum LoadingStatus: String {
        case getSyncLog = "Get SyncLog..."
        case uploadDailys = "Upload Dailys..."
        case getDailys = "Get Dailys..."
        case uploadRecordTime = "Upload RecordTime..."
        case getRecordTime = "Get RecordTime..."
    }
    
    @IBOutlet weak var syncUserStatusView: SyncUserStatusView!
    @IBOutlet weak var serverDailysCountLabel: UILabel!
    @IBOutlet weak var syncDeviceStatusView: SyncDeviceStatusView!
    @IBOutlet weak var syncButton: UIButton!
    
    private var viewModel: SyncDailysVM?
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureLocalized()
        self.configureViewModel()
        self.bindAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let targetDailys = self.syncDeviceStatusView.configureDailys()
        self.viewModel?.updateTargetDailys(to: targetDailys)
    }
    
    @IBAction func syncNow(_ sender: Any) {
        if UserDefaultsManager.get(forKey: .lastUploadedDateV1) == nil {
            self.showAlertWithOKAfterHandler(title: Localized.string(.SyncDaily_Popup_InfoFirstSyncTitle), text: Localized.string(.SyncDaily_Popup_InfoFirstSyncDesc)) { [weak self] in
                self?.viewModel?.checkSyncDailys()
            }
        } else {
            self.viewModel?.checkSyncDailys()
        }
    }
}

extension SyncDailysVC {
    private func configureLocalized() {
        self.syncButton.setTitle(Localized.string(.SyncDaily_Button_SyncNow), for: .normal)
    }
    
    private func bindAll() {
        self.bindSyncLog()
        self.bindSaveDailysSuccess()
        self.bindLoading()
        self.bindError()
    }
    
    private func bindSyncLog() {
        self.viewModel?.$syncLog
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] userInfo in
                guard let userInfo = userInfo else { return }
                
                self?.syncUserStatusView.showServerDate(to: userInfo.updatedAt)
                self?.serverDailysCountLabel.text = "\(userInfo.dailysCount) Dailys"
                LoadingIndicator.hideLoading()
            })
            .store(in: &self.cancellables)
    }
    
    private func bindSaveDailysSuccess() {
        self.viewModel?.$saveDailysSuccess
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] success in
                if success {
                    let _ = self?.syncDeviceStatusView.configureDailys()
                }
            })
            .store(in: &self.cancellables)
    }
    
    private func bindLoading() {
        self.viewModel?.$isLoading
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] isLoading in
                if isLoading {
                    let loadingText = self?.viewModel?.loadingText?.rawValue
                    LoadingIndicator.showLoading(text: loadingText)
                } else {
                    LoadingIndicator.hideLoading()
                }
            })
            .store(in: &self.cancellables)
    }
    
    private func bindError() {
        self.viewModel?.$alert
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] error in
                LoadingIndicator.hideLoading()
                self?.showAlertWithOK(title: error.title, text: error.text)
            })
            .store(in: &self.cancellables)
    }
}

extension SyncDailysVC {
    private func configureViewModel() {
        let dailysUseCase = DailysUseCase(repository: DailysRepository())
        let recordTimesUseCase = RecordTimesUseCase(repository: RecordTimesRepository())
        let syncLogUseCase = SyncLogUseCase(repository: SyncLogRepository())
        let targetDailys = self.syncDeviceStatusView.configureDailys()
        
        self.viewModel = SyncDailysVM(
            dailysUseCase: dailysUseCase,
            recordTimesUseCase: recordTimesUseCase,
            syncLogUseCase: syncLogUseCase,
            targetDailys: targetDailys)
    }
}
