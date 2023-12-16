//
//  TimerTimeLabelView.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/06/27.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

struct TimerTimeLabelView: View {
    @ObservedObject var viewModel: TimerTimeLabelVM
    @ObservedObject var baseViewModel: BaseTimeLabelVM
    
    init(viewModel: TimerTimeLabelVM) {
        self.viewModel = viewModel
        self.baseViewModel = viewModel.timeLabelVM
    }
    
    var color: Color {
        switch viewModel.timerState {
        case .normalRunning:
            return Color.timerColor
        case .lessThan60Sec:
            return Color(Colors.warningRed ?? .clear)
        case .stopped:
            return baseViewModel.isWhite ? .white : .black.opacity(0.55)
        }
    }
    
    var body: some View {
        ZStack {
            if viewModel.finished {
                Text("FINISH".localized())
            } else {
                HStack(spacing: 0) {
                    if viewModel.time < 0 {
                        Text("+")
                    }
                    BaseTimeLabelView(viewModel: baseViewModel)
                }
            }
        }
        .font(Fonts.HGGGothicssiP60g(size: baseViewModel.fontSize))
        .foregroundColor(self.color)
    }
}
