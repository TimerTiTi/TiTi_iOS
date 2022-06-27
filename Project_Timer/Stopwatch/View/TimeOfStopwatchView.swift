//
//  TimeOfStopwatchView.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/06/27.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

struct TimeOfStopwatchView: View {
    @ObservedObject var viewModel: TimeOfStopwatchViewModel
    
    var color: Color {
        if viewModel.isRunning {
            return Color(UIColor(named: "Background2") ?? .clear)
        } else {
            return Color.white
        }
    }
    
    var body: some View {
        TimeLabelView(viewModel: viewModel.timeLabelViewModel)
            .foregroundColor(self.color)
    }
}
