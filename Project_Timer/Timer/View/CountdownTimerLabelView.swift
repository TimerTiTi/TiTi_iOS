//
//  CountdownTimerLabelView.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/06/27.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

struct CountdownTimerLabelView: View {
    @ObservedObject var viewModel: TimeOfTimerViewModel
    
    var color: Color {
        switch viewModel.timerState {
        case .normalRunning:
            return Color.timerColor
        case .lessThan60Sec:
            return Color(TiTiColor.text ?? .clear)
        case .stopped:
            return viewModel.isWhite ? .white : .black.opacity(0.6)
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
                    BaseTimeLabelView(viewModel: viewModel.timeLabelViewModel)
                }
            }
        }
        .font(TiTiFont.HGGGothicssiP60g(size: viewModel.fontSize))
        .foregroundColor(self.color)
    }
}
