//
//  WeekView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/09/13.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

struct WeekView: View {
    let frameHeight: CGFloat = 120
    @ObservedObject var viewModel: WeekVM
    
    init(viewModel: WeekVM) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .bottom, spacing: 12) {
                self.MonthTextView
                self.WeekTextView
                self.WeekTermTextView
            }
            HStack(alignment: .bottom, spacing: 6) {
                self.TimelineGraphView
                self.TimeView
            }
            .padding(.horizontal, 12)
            .frame(height: self.frameHeight)
        }
    }
}

// MARK: CustomViews
extension WeekView {
    var MonthTextView: some View {
        Text(self.monthText)
            .font(TiTiFont.HGGGothicssiP80g(size: 25))
            .foregroundColor(.primary)
    }
    
    var WeekTextView: some View {
        Text(self.weekText)
            .font(TiTiFont.HGGGothicssiP80g(size: 25))
            .foregroundColor(.primary)
    }
    
    var WeekTermTextView: some View {
        Text(self.weekTerm)
            .font(TiTiFont.HGGGothicssiP60g(size: 14))
            .foregroundColor(.primary)
            .padding(.bottom, 3)
    }
    
    var TimelineGraphView: some View {
        HStack(alignment: .bottom, spacing: 6) {
            ForEach(viewModel.weekTimes) { weekTime in
                VStack {
                    Spacer(minLength: 2)
                    Text(weekTime.sumTime != 0 ? weekTime.sumTime.toHM : "")
                        .foregroundColor(.primary)
                        .font(.system(size: 9))
                        .padding(.bottom, -6)
                    RoundedShape(radius: 6)
                        .fill(LinearGradient(gradient: .init(colors: [TiTiColor.graphColor(num: viewModel.color1Index).toColor, TiTiColor.graphColor(num: viewModel.color2Index).toColor]), startPoint: .top, endPoint: .bottom))
                        .frame(height: self.getHeight(value: weekTime.sumTime))
                        .padding(.bottom, -4)
                    Text(weekTime.day)
                        .font(.system(size: 9))
                        .foregroundColor(.primary)
                        .frame(height: 11)
                        .padding(.bottom, 6)
                }
            }
        }
        .background(Color("Background_second")).edgesIgnoringSafeArea(.all)
    }
    
    var TimeView: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("Total")
                .font(TiTiFont.HGGGothicssiP60g(size: 12))
                .foregroundColor(.primary)
            Text(self.totalTime)
                .font(TiTiFont.HGGGothicssiP80g(size: 22))
                .foregroundColor(TiTiColor.graphColor(num: viewModel.color2Index).toColor)
                .padding(.bottom, 4)
            Text("Average")
                .font(TiTiFont.HGGGothicssiP60g(size: 12))
                .foregroundColor(.primary)
            Text(self.averageTime)
                .font(TiTiFont.HGGGothicssiP80g(size: 22))
                .foregroundColor(TiTiColor.graphColor(num: viewModel.color2Index).toColor)
                .padding(.bottom, 16)
        }
        .background(Color("Background_second")).edgesIgnoringSafeArea(.all)
    }
}

// MARK: propertys
extension WeekView {
    private var monthText: String {
        guard let day = viewModel.weekDates.last else { return "0000.00" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM"
        return dateFormatter.string(from: day)
    }
    
    private var weekText: String {
        return "WEEK \(viewModel.weekNum)"
    }
    
    private var weekTerm: String {
        let mon = viewModel.weekDates[0]
        let sun = viewModel.weekDates[6]
        
        return "\(mon.MMDDstyleString) ~ \(sun.MMDDstyleString)"
    }
    
    private func getHeight(value: Int) -> CGFloat {
        guard let maxTime = self.viewModel.weekTimes.map(\.sumTime).max(),
              maxTime != 0 else { return 0 }
        return CGFloat(value) / CGFloat(maxTime) * (self.frameHeight - 35)
    }
    
    private var totalTime: String {
        return viewModel.totalTime.toTimeString
    }
    
    private var averageTime: String {
        return viewModel.averageTime.toTimeString
    }
}
