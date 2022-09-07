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
                    TotalTaskCellView(rank: index+1,
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

struct TotalTaskCellView : View {
    let rank: Int
    let taskName: String
    let taskTime: Int
    let colorIndex: Int
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            HStack(alignment: .center, spacing: 0) {
                Text("Top\(rank)")
                    .font(TiTiFont.HGGGothicssiP80g(size: 10))
                    .foregroundColor(TiTiColor.graphColor(num: colorIndex).toColor)
                    .frame(width: 24, alignment: .leading)
                Text("\(taskName)")
                    .font(TiTiFont.HGGGothicssiP60g(size: 10.5))
                    .padding(.horizontal, 2)
                    .background(TiTiColor.graphColor(num: colorIndex).withAlphaComponent(0.5).toColor)
                    .frame(width: 134, alignment: .leading)
                    .lineLimit(1)
                Spacer(minLength: 2)
                Text("\(taskTime/3600) H")
                    .font(TiTiFont.HGGGothicssiP80g(size: 10))
                    .foregroundColor(TiTiColor.graphColor(num: colorIndex).toColor)
            }
            Divider()
                .background(UIColor.lightGray.withAlphaComponent(0.5).toColor)
        }
        .frame(width: 188, height: 25, alignment: .trailing)
    }
}
