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
            return Color(UIColor(named: "Blue") ?? .clear)
        case .lessThan60Sec:
            return Color(UIColor(named: "Text") ?? .clear)
        case .stopped:
            return Color.white
        }
    }
    
    var body: some View {
        ZStack {
            if viewModel.finished {
                Text("FINISH".localized())
                .font(Font.custom("HGGGothicssiP60g", size: 300))
                .foregroundColor(.white)
                .minimumScaleFactor(0.1)
            } else {
                HStack {
                    if viewModel.time < 0 {
                        Text("+")
                            .font(Font.custom("HGGGothicssiP60g", size: 300))
                            .minimumScaleFactor(0.1)
                    }
                    
                    TimeLabelView(viewModel: viewModel.timeLabelViewModel)
                }
                .foregroundColor(self.color)
            }
        }
    }
}
