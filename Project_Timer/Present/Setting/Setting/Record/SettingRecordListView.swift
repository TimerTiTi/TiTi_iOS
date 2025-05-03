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
                    title: "기록 날짜 갱신시간", subTitle: "갱신시간 기준으로 기록 날짜가 갱신됩니다", rightTitle: "\(String(format: "%02d", viewModel.resetHour))H") {
                        viewModel.action(.showInputPopup)
                    }
            }
        }
    }
}

#Preview {
    SettingRecordListView(viewModel: SettingRecordViewModel())
}
