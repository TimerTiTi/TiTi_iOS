//
//  TotalView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/09/07.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

struct TotalView: View {
    private let totalTimeFontSize: CGFloat = 28
    private let totalTimeLineWidth: CGFloat = 19
    private let circleSize: CGFloat = 90
    @ObservedObject var viewModel: TotalVM
    
    init(viewModel: TotalVM) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            self.CircularProgressView
            VStack(alignment: .leading, spacing: 0) {
                ForEach(0..<viewModel.top5Tasks.count, id: \.self) { index in
                    LogHomeTaskCellView(rank: index+1,
                                      taskName: viewModel.top5Tasks[index].taskName,
                                      taskTime: viewModel.top5Tasks[index].taskTime,
                                      colorIndex: colorIndex(row: index))
                }
            }
        }
        .background(Color("Background_second").edgesIgnoringSafeArea(.all))
    }
    
    var totalHours: Int {
        return viewModel.totalTime/3600
    }
    
    func colorIndex(row: Int) -> Int {
        if viewModel.reverseColor {
            let colorIndex = (viewModel.colorIndex-row+12)%12
            return colorIndex != 0 ? colorIndex : 12
        } else {
            let colorIndex = (viewModel.colorIndex+row)%12
            return colorIndex != 0 ? colorIndex : 12
        }
    }
}

extension TotalView {
    private var CircularProgressView: some View {
        TasksCircularProgressSwiftUIView(tasks: viewModel.top5Tasks, isReverseColor: viewModel.reverseColor, colorIndex: viewModel.colorIndex)
            .padding(10)
    }
}
