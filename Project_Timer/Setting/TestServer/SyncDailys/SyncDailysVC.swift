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
        case getUserInfo = "Get UserInfo..."
        case uploadDailys = "Upload Dailys..."
        case getDailys = "Get Dailys..."
    }
    
    @IBOutlet weak var syncUserStatusView: SyncUserStatusView!
    @IBOutlet weak var serverDailysCountLabel: UILabel!
    @IBOutlet weak var syncDeviceStatusView: SyncDeviceStatusView!
    
    private var viewModel: SyncDailysVM?
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadingIndicator.showLoading(text: LoadingStatus.getUserInfo.rawValue)
        self.configureViewModel()
        self.bindAll()
    }
    
    @IBAction func syncNow(_ sender: Any) {
        self.viewModel?.checkSyncDailys()
    }
}

extension SyncDailysVC {
    private func bindAll() {
        self.bindUserDailysInfo()
        self.bindError()
    }
    
    private func bindUserDailysInfo() {
        self.viewModel?.$userDailysInfo
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] userInfo in
                guard let userInfo = userInfo else { return }
                
                self?.syncUserStatusView.showServerDate(to: userInfo.updatedAt)
                self?.serverDailysCountLabel.text = "\(userInfo.dailysCount) Dailys"
                LoadingIndicator.hideLoading()
            })
            .store(in: &self.cancellables)
    }
    
    private func bindError() {
        self.viewModel?.$error
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] error in
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
