//
//  WeekView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/09/13.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

struct WeekView: View {
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
}
