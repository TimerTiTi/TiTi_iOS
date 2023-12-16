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
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(self.viewModel.weekTimes) { weekTime in
                VStack {
                    Spacer(minLength: 2)
                    Text(weekTime.sumTime != 0 ? weekTime.sumTime.toHM : "")
                        .foregroundColor(.primary)
                        .font(.system(size: 9))
                        .padding(.bottom, -6)
                    RoundedShape(radius: 6)
                        .fill(LinearGradient(gradient: .init(colors: [Colors.graphColor(num: viewModel.color1Index).toColor, Colors.graphColor(num: viewModel.color2Index).toColor]), startPoint: .top, endPoint: .bottom))
                        .frame(height: self.getHeight(value: weekTime.sumTime))
                        .padding(.bottom, -4)
                    Text(weekTime.day)
                        .font(.system(size: 9))
                        .foregroundColor(.primary)
                        .frame(height: 11)
                        .padding(.bottom, 6)
                }
                .frame(height: self.frameHeight)
            }
        }
        .padding(.leading, 6)
        .background(Color("Background_second")).edgesIgnoringSafeArea(.all)
    }
    
    private func getHeight(value: Int) -> CGFloat {
        guard let maxTime = self.viewModel.weekTimes.map(\.sumTime).max(),
              maxTime != 0 else { return 0 }
        return CGFloat(value) / CGFloat(maxTime) * (self.frameHeight - 40)
    }
}
