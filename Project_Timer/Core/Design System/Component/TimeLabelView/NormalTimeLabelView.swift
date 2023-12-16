//
//  NormalTimeLabelView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/10/13.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

struct NormalTimeLabelView: View {
    @ObservedObject var viewModel: NormalTimeLabelVM
    @ObservedObject var baseViewModel: BaseTimeLabelVM
    
    init(viewModel: NormalTimeLabelVM) {
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
        BaseTimeLabelView(viewModel: baseViewModel)
            .foregroundColor(self.color)
    }
}
