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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureLocalized()
    }
    
    private func configureLocalized() {
        self.useage1Label.text = "The number of Dailys stored on the server and the number of Dailys on the current device.".localized()
        self.useage2Label.text = "Created and Edited dailys are backed up at the time of synchronized.".localized()
    }
}
