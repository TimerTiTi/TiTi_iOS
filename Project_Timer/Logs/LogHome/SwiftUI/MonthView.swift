//
//  MonthView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/09/10.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

struct MonthView: View {
    private let totalTimeFontSize: CGFloat = 28
    private let totalTimeLineWidth: CGFloat = 19
    private let circleSize: CGFloat = 90
    @ObservedObject var viewModel: MonthVM
    
    init(viewModel: MonthVM) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            ZStack {
                Circle()
                    .stroke(TiTiColor.graphColor(num: viewModel.colorIndex).toColor.opacity(0.5),
                            lineWidth: totalTimeLineWidth)
                    .frame(width: circleSize, height: circleSize, alignment: .center)
                
                Circle()
                    .trim(from: 0, to: 1)
                    .stroke(TiTiColor.graphColor(num: viewModel.colorIndex).toColor.opacity(1.0),
                            style: StrokeStyle(lineWidth: totalTimeLineWidth, lineCap: .round))
                    .frame(width: circleSize, height: circleSize, alignment: .center)
                    .rotationEffect(.degrees(-90))
                
                Text("\(totalHours)")
                    .font(TiTiFont.HGGGothicssiP60g(size: totalTimeFontSize))
                    .foregroundColor(.primary)
            }
            .padding(10)
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
