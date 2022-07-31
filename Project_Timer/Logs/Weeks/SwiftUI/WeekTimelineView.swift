//
//  WeekTimelineView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/07/30.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

struct WeekTimeBlock : Identifiable {
    var id : Int
    var day: String
    var sumTime : Int
}

struct WeekTimelineView: View {
    var frameHeight: CGFloat = 130
    @ObservedObject var viewModel: WeekTimelineVM
    
    init(frameHeight: CGFloat, viewModel: WeekTimelineVM) {
        self.frameHeight = frameHeight - 20
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack(spacing: 15) {
            ForEach(self.viewModel.weekTimes) { weekTime in
                VStack {
                    Spacer(minLength: 0)
                    Text(weekTime.sumTime.toHM)
                        .foregroundColor(.primary)
                        .font(.system(size: 12))
                        .padding(.bottom, -6)
                    RoundedShape(radius: 12)
                        .fill(LinearGradient(gradient: .init(colors: [TiTiColor.graphColor(num: viewModel.color1Index).toColor, TiTiColor.graphColor(num: viewModel.color2Index).toColor]), startPoint: .top, endPoint: .bottom))
                        .frame(height: self.getHeight(value: weekTime.sumTime))
                        .padding(.bottom, -4)
                    Text(weekTime.day)
                        .font(.system(size: 12))
                        .foregroundColor(.primary)
                        .frame(height: 12)
                }
                .frame(height: self.frameHeight)
            }
        }
    }
    
    private func getHeight(value: Int) -> CGFloat {
        guard let maxTime = self.viewModel.weekTimes.map(\.sumTime).max() else { return 0 }
        return CGFloat(value) / CGFloat(maxTime) * (self.frameHeight - 35)
    }
}

struct WeekTimelineView_Previews: PreviewProvider {
    static var previews: some View {
        let dummyTimes = (0...6).map { idx in
            WeekTimeBlock(id: idx, day: "7/\(idx)", sumTime: Int.random(in: (10800..<21600)))
        }
        WeekTimelineView(frameHeight: 130, viewModel: WeekTimelineVM(weekTimes: dummyTimes))
    }
}
