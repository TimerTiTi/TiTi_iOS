//
//  CountDownTimeLabelView.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/07/08.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

struct CountdownTimeLabelView: View {
    @ObservedObject var viewModel: CountdownTimeLabelViewModel
    
    var color: Color {
        if viewModel.timeLabelViewModel.isRunning {
            return Color.white
        } else {
            return viewModel.isWhite ? .white : .black.opacity(0.5)
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            if viewModel.time < 0 {
                Text("+")
                    .foregroundColor(self.color)
            }
            TimeLabelView(viewModel: viewModel.timeLabelViewModel)
        }
        .font(TiTiFont.HGGGothicssiP60g(size: viewModel.fontSize))
    }
}
