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
    
    var body: some View {
        HStack(spacing: 0) {
            if viewModel.time < 0 {
                Text("+")
            }
            TimeLabelView(viewModel: viewModel.timeLabelViewModel)
        }
        .font(TiTiFont.HGGGothicssi(size: viewModel.fontSize, weight: .bold))
    }
}
