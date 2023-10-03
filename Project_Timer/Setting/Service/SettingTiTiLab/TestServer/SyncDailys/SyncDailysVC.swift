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
    
    private var viewModel: SyncDailysVM?
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            self.showAlertWithOKAfterHandler(title: "First Sync".localized(), text: "For the first synchronization, it may take a long time for all Daily information to be reflected (10s), so please wait without shutting down the app.".localized()) { [weak self] in
                self?.viewModel?.checkSyncDailys()
            }
        } else {
            self.viewModel?.checkSyncDailys()
        }
    }
}

extension SyncDailysVC {
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
        self.viewModel?.$loading
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] loading in
                switch loading {
                case true:
                    let loadingText = self?.viewModel?.loadingText?.rawValue
                    LoadingIndicator.showLoading(text: loadingText)
                case false:
                    LoadingIndicator.hideLoading()
                }
            })
            .store(in: &self.cancellables)
    }
    
    private func bindError() {
        self.viewModel?.$error
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] error in
                LoadingIndicator.hideLoading()
                guard let error = error else { return }
                self?.showAlertWithOK(title: error.title, text: error.text)
            })
            .store(in: &self.cancellables)
    }
}

extension SyncDailysVC {
    private func configureViewModel() {
        let targetDailys = self.syncDeviceStatusView.configureDailys()
        self.viewModel = SyncDailysVM(networkController: NetworkController(network: Network()), targetDailys: targetDailys)
    }
}
