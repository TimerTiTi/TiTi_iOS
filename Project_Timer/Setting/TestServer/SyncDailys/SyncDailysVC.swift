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
    
    @IBOutlet weak var syncUserStatusView: SyncUserStatusView!
    @IBOutlet weak var syncDeviceStatusView: SyncDeviceStatusView!
    
    private var viewModel: SyncDailysVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewModel()
        // loading 구현
        // combine 구현
    }
    
    @IBAction func syncNow(_ sender: Any) {
        self.viewModel?.checkSyncDailys()
    }
}

extension SyncDailysVC {
    private func configureViewModel() {
        let targetDailys = self.syncDeviceStatusView.configureDailys()
        self.viewModel = SyncDailysVM(networkController: NetworkController(network: Network()), targetDailys: targetDailys)
    }
}
