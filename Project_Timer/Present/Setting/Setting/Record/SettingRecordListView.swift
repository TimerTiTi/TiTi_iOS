//
//  SettingRecordListView.swift
//  Project_Timer
//
//  Created by Minsang on 5/3/25.
//  Copyright © 2025 FDEE. All rights reserved.
//

import SwiftUI

struct SettingRecordListView: View {
    
    @ObservedObject var viewModel: SettingRecordViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 1) {
                TTSettingListCell(
                    title: Localized.string(.SettingRecord_Text_RecordResetTimeTitle), subTitle: Localized.string(.SettingRecord_Text_RecordResetTimeDesc), rightTitle: "\(String(format: "%02d", viewModel.resetHour))H") {
                        viewModel.action(.showInputPopup)
                    }
            }
        }
    }
}

#Preview {
    SettingRecordListView(viewModel: SettingRecordViewModel())
}
