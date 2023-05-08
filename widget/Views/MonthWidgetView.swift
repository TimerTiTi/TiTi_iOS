//
//  MonthWidgetView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/05/08.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI
import WidgetKit

struct MonthWidgetView: View {
    var body: some View {
        HStack {
            MonthWidgetLeftView()
            Spacer(minLength: 10)
            MonthWidgetRightView()
        }
        .padding(.all)
        .background(Color(UIColor.systemBackground))
    }
}

struct MonthWidgetLeftView: View {
    var body: some View {
        VStack(alignment: .center) {
            Text("4월")
                .font(Font.system(size: 16, weight: .bold))
            Spacer()
            VStack(alignment: .leading) {
                ForEach(0..<5) { index in
                    TaskRowView(index: index)
                        .frame(height: 10)
                }
            }
            .frame(maxWidth: .infinity)
            Spacer()
        }
        .frame(width: 80)
    }
}

struct MonthWidgetRightView: View {
    let day: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    var body: some View {
        VStack(alignment: .center, spacing: 1) {
            HStack(spacing: 0) {
                ForEach(day, id: \.self) { d in
                    Text(d)
                        .font(Font.system(size: 10, weight: .regular))
                        .foregroundColor(Color(UIColor.secondaryLabel))
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(height: 12)
            }
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(UIColor.placeholderText))
            Spacer()
                .frame(height: 2)
            VStack(alignment: .center, spacing: 1) {
                HStack(spacing: 0) {
                    ForEach(1..<8) { day in
                        if day < 7 {
                            Spacer()
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            MonthWidgetDayCell(day: day)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
                Spacer(minLength: 0)
                HStack(spacing: 0) {
                    ForEach(8..<15) { day in
                        MonthWidgetDayCell(day: day)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                Spacer(minLength: 0)
                HStack(spacing: 0) {
                    ForEach(15..<22) { day in
                        MonthWidgetDayCell(day: day)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                Spacer(minLength: 0)
                HStack(spacing: 0) {
                    ForEach(22..<29) { day in
                        MonthWidgetDayCell(day: day)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                Spacer(minLength: 0)
                HStack(spacing: 0) {
                    ForEach(29..<36) { day in
                        MonthWidgetDayCell(day: day)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                ExtraView()
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct TaskRowView: View {
    let index: Int
    var body: some View {
        HStack() {
            RoundedRectangle(cornerRadius: 1)
                .fill(Color(UIColor(named: "D1")!))
                .frame(width: 3)
            Spacer()
                .frame(width: 3)
            Text("TiTi 개발")
                .font(Font.system(size: 9, weight: .semibold))
                .padding(.horizontal, 1.0)
                .background(Color(UIColor(named: "D1")!).opacity(0.5))
                .cornerRadius(1)
            Spacer()
            Text("\(23)")
                .font(Font.system(size: 8, weight: .bold))
                .foregroundColor(Color(UIColor(named: "D1")!))
        }
    }
}

struct MonthWidgetDayCell: View {
    let day: Int
    var body: some View {
        HStack(alignment: .top, spacing: 1) {
            Text("\(day - 6)")
                .font(Font.system(size: 7, weight: .regular))
                .frame(width: 10, alignment: .trailing)
            ZStack {
                Circle()
                    .fill(Color(UIColor(named: "D1")!))
                    .frame(width: 16, height: 16)
                Text("6")
                    .font(Font.system(size: 9.5, weight: .bold))
                    .foregroundColor(Color(UIColor.systemBackground))
            }
        }
    }
}

struct ExtraView: View {
    var body: some View {
        Spacer(minLength: 0)
        HStack(spacing: 0) {
            ForEach(36..<43) { day in
                if day > 36 {
                    Spacer()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    MonthWidgetDayCell(day: day)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
    }
}

struct MonthWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MonthWidgetView()
                .previewLayout(.fixed(width: 338, height: 158))
        }
    }
}
