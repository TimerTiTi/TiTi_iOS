//
//  SyncUserStatusView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/12/23.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class SyncUserStatusView: UIView {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var deviceDateLabel: UILabel!
    @IBOutlet weak var serverDateLabel: UILabel!
    @IBOutlet weak var useage1Label: UILabel!
    @IBOutlet weak var useage2Label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureLocalized()
        self.configureUsername()
    }
    
    private func configureLocalized() {
        self.useage1Label.text = Localized.string(.SyncDaily_Text_InfoSync1)
        self.useage2Label.text = Localized.string(.SyncDaily_Text_InfoSync2)
    }
    
    private func configureUsername() {
        guard let username = KeyChain.shared.get(key: .username) else { return }
        self.usernameLabel.text = username
    }
    
    private func showDeviceDate() {
        guard let deviceDate = UserDefaultsManager.get(forKey: .lastUploadedDateV1) as? Date else { return }
        self.deviceDateLabel.text = deviceDate.serverDateString
    }
}

extension SyncUserStatusView {
    func showServerDate(to date: Date) {
        self.showDeviceDate()
        self.serverDateLabel.text = date.serverDateString
    }
}
