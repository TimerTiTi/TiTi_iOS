//
//  TimeOfTimerView.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/06/27.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

struct TimeOfTimerView: View {
    @ObservedObject var viewModel: TimeOfTimerViewModel
    
    var color: Color {
        // TODO: 컬러 상수화
        switch viewModel.timerState {
        case .normalRunning:
            return Color(TiTiColor.blue ?? .clear)
        case .lessThan60Sec:
            return Color(TiTiColor.text ?? .clear)
        case .stopped:
            return Color.white
        }
    }
    
    var body: some View {
        ZStack {
            if viewModel.finished {
                Text("FINISH".localized())
                .font(TiTiFont.HGGGothicssiP60g(size: 70))
                .foregroundColor(.white)
            } else {
                HStack(spacing: 0) {
                    if viewModel.time < 0 {
                        Text("+")
                    }
                    TimeLabelView(viewModel: viewModel.timeLabelViewModel)
                }
                .font(TiTiFont.HGGGothicssiP60g(size: 70))
                .foregroundColor(self.color)
            }
        }
    }
}
