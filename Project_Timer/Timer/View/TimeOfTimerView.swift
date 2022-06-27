//
//  TimeOfTimerView.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/06/27.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

struct TimeOfTimerView: View {
    @ObservedObject var viewModel: TimeLabelViewModel
    var finished: Bool {
        viewModel.time == 0
    }
    
    var body: some View {
        ZStack {
            if finished {
                Text("FINISH".localized())
                .font(Font.custom("HGGGothicssiP60g", size: 300))
                .foregroundColor(.white)
                .minimumScaleFactor(0.1)
            } else {
                TimeLabelView(viewModel: viewModel)
            }
        }
    }
}
