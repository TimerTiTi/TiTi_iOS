//
//  TimeLabelView.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/06/24.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

struct TimeLabelView: View {
    @ObservedObject var viewModel: TimeLabelViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            if viewModel.timeLabel.hourTens > 0 {
                SingleTimeLabelView(viewModel: viewModel.hourTensViewModel)
            }
            SingleTimeLabelView(viewModel: viewModel.hourUnitsViewModel)
            Text(":")
            SingleTimeLabelView(viewModel: viewModel.minuteTensViewModel)
            SingleTimeLabelView(viewModel: viewModel.minuteUnitsViewModel)
            Text(":")
            SingleTimeLabelView(viewModel: viewModel.secondTensViewModel)
            SingleTimeLabelView(viewModel: viewModel.secondUnitsViewModel)
        }
        .font(TiTiFont.HGGGothicssiP60g(size: viewModel.fontSize))
    }
}
