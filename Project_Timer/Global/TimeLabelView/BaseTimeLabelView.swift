//
//  BaseTimeLabelView.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/06/24.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

struct BaseTimeLabelView: View {
    @ObservedObject var viewModel: BaseTimeLabelVM
    
    var body: some View {
        HStack(spacing: 0) {
            if viewModel.timeLabel.hourTens > 0 {
                BaseSingleTimeLabelView(viewModel: viewModel.hourTensViewModel)
            }
            BaseSingleTimeLabelView(viewModel: viewModel.hourUnitsViewModel)
            Text(":")
            BaseSingleTimeLabelView(viewModel: viewModel.minuteTensViewModel)
            BaseSingleTimeLabelView(viewModel: viewModel.minuteUnitsViewModel)
            Text(":")
            BaseSingleTimeLabelView(viewModel: viewModel.secondTensViewModel)
            BaseSingleTimeLabelView(viewModel: viewModel.secondUnitsViewModel)
        }
        .font(TiTiFont.HGGGothicssiP60g(size: viewModel.fontSize))
    }
}
