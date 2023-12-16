//
//  StopwatchTimeLabelView.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/06/27.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

struct StopwatchTimeLabelView: View {
    @ObservedObject var viewModel: StopwatchTimeLabelVM
    @ObservedObject var baseViewModel: BaseTimeLabelVM
    
    init(viewModel: StopwatchTimeLabelVM) {
        self.viewModel = viewModel
        self.baseViewModel = viewModel.timeLabelVM
    }
    
    var color: Color {
        if baseViewModel.isRunning {
            return Color.stopWatchColor
        } else {
            return baseViewModel.isWhite ? .white : .black.opacity(0.55)
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            if baseViewModel.timeLabelData.hourTens > 0 {
                BaseSingleTimeLabelView(viewModel: baseViewModel.hourTensViewModel)
            }
            BaseSingleTimeLabelView(viewModel: baseViewModel.hourUnitsViewModel)
            Text(":")
            BaseSingleTimeLabelView(viewModel: baseViewModel.minuteTensViewModel)
            BaseSingleTimeLabelView(viewModel: baseViewModel.minuteUnitsViewModel)
            Text(":")
            BaseSingleTimeLabelView(viewModel: baseViewModel.secondTensViewModel)
            BaseSingleTimeLabelView(viewModel: baseViewModel.secondUnitsViewModel)
        }
        .font(Fonts.HGGGothicssiP60g(size: baseViewModel.fontSize))
        .foregroundColor(self.color)
    }
}
