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
    private let totalTimeLineWidth: CGFloat = 20
    private let circleSize: CGFloat = 95
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
            .padding()
            VStack(alignment: .leading, spacing: 0) {
                ForEach(0..<viewModel.top5Tasks.count, id: \.self) { index in
                    HStack(alignment: .center, spacing: 0) {
                        Text("Top\(index+1) \(viewModel.top5Tasks[index].taskName)")
                        Spacer()
                        Text("\(viewModel.top5Tasks[index].taskTime.toTimeString)")
                    }
                    .font(TiTiFont.HGGGothicssiP60g(size: 11.5))
                    .frame(width: 180, height: 25, alignment: .trailing)
                }
            }
        }
        .background(Color("Background_second").edgesIgnoringSafeArea(.all))
    }
    
    var totalHours: Int {
        return viewModel.totalTime/3600
    }
}
