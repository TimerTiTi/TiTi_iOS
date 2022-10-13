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
    @ObservedObject var baseViewModel: BaseTimeLabelVM
    
    init(viewModel: CountdownTimeLabelViewModel) {
        self.viewModel = viewModel
        self.baseViewModel = viewModel.timeLabelVM
    }
    
    var color: Color {
        if baseViewModel.isRunning {
            return Color.white
        } else {
            return baseViewModel.isWhite ? .white : .black.opacity(0.6)
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            if viewModel.time < 0 {
                Text("+")
            }
            BaseTimeLabelView(viewModel: baseViewModel)
        }
        .font(TiTiFont.HGGGothicssiP60g(size: baseViewModel.fontSize))
        .foregroundColor(self.color)
    }
}
