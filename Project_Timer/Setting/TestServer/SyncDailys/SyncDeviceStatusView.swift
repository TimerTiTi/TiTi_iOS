//
//  SyncDeviceStatusView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/12/23.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class SyncDeviceStatusView: UIView {
    @IBOutlet weak var deviceTotalDailysLabel: UILabel!
    @IBOutlet weak var uploadedDailysLabel: UILabel!
    @IBOutlet weak var createdDailysLabel: UILabel!
    @IBOutlet weak var editedDailysLabel: UILabel!
    @IBOutlet weak var useage1Label: UILabel!
    @IBOutlet weak var useage2Label: UILabel!
    @IBOutlet weak var deviceIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureLocalized()
        self.deviceIcon.image = UIImage(named: "macbookAndIphone")?.withRenderingMode(.alwaysTemplate)
    }
    
    private func configureLocalized() {
        self.useage1Label.text = "The number of Dailys stored on the server and the number of Dailys on the current device.".localized()
        self.useage2Label.text = "Created and Edited dailys are backed up at the time of synchronized.".localized()
    }
    
    func configureDailys() -> [Daily] {
        let dailys = RecordsManager.shared.dailys.dailys
        // device dailys
        self.deviceTotalDailysLabel.text = "\(dailys.count) Dailys"
        var targetDailys: [Daily] = []
        var uploaded: Int = 0
        var created: Int = 0
        var edited: Int = 0
        dailys.forEach { daily in
            if let status = daily.status {
                switch status {
                case Daily.Status.uploaded.rawValue:
                    uploaded += 1
                case Daily.Status.created.rawValue:
                    created += 1
                    targetDailys.append(daily)
                case Daily.Status.edited.rawValue:
                    edited += 1
                    targetDailys.append(daily)
                default:
                    print("daily status error")
                    return
                }
            } else {
                created += 1
                targetDailys.append(daily)
            }
        }
        // uploaded dailys
        self.uploadedDailysLabel.text = "\(uploaded) Dailys"
        // created dailys
        self.createdDailysLabel.text = "\(created) Dailys"
        // edited dailys
        self.editedDailysLabel.text = "\(edited) Dailys"
        
        return targetDailys
    }
}
