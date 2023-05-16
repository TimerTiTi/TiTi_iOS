//
//  MonthWidgetView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/05/08.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI
import WidgetKit

// MARK: MonthWidget SwiftUI 뷰
struct MonthWidgetView: View {
    var data: MonthWidgetData
    
    init(_ data: MonthWidgetData) {
        self.data = data
    }
    
    var body: some View {
        HStack {
            MonthWidgetTasksView(data: data, isKorean: isKorean)
            Spacer(minLength: 10)
            MonthWidgetCalendarView(data: data, isKorean: isKorean)
        }
        .padding(.all)
        .background(Color(UIColor.systemBackground))
    }
    
    var isKorean: Bool {
        if #available(iOS 16.0, *){
            let languageCode = Locale.current.language.languageCode?.identifier ?? "en"
            return languageCode == "ko"
        } else {
            let languageCode = Locale.current.languageCode ?? "en"
            return languageCode == "ko"
        }
    }
}

struct MonthWidgetTasksView: View {
    let data: MonthWidgetData
    let isKorean: Bool
    
    var body: some View {
        VStack(alignment: .center) {
            Text(month)
                .font(Font.system(size: 16, weight: .bold))
            Spacer()
            VStack(alignment: .leading) {
                ForEach(0..<data.tasksData.count, id: \.self) { index in
                    MonthWidgetTaskRowView(data: data.tasksData[index], color: color(index))
                        .frame(height: 10)
                }
            }
            .frame(maxWidth: .infinity)
            Spacer()
        }
        .frame(width: 80)
    }
    
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        dateFormatter.locale = Locale(identifier: isKorean ? "ko_KR" : "en_US")
        return dateFormatter.string(from: data.now)
    }
    
    func color(_ index: Int) -> String {
        if data.isRightDirection {
            let newColorNum = (data.color+index)%12
            return newColorNum != 0 ? "D\(newColorNum)" : "D12"
        } else {
            let newColorNum = (data.color-index+12)%12
            return newColorNum != 0 ? "D\(newColorNum)" : "D12"
        }
    }
}

struct MonthWidgetTaskRowView: View {
    let data: MonthWidgetTaskData
    let color: String
    
    var body: some View {
        HStack() {
            RoundedRectangle(cornerRadius: 1)
                .fill(Color(UIColor(named: color)!))
                .frame(width: 3)
            Spacer()
                .frame(width: 3)
            Text(data.taskName)
                .font(Font.system(size: 9, weight: .semibold))
                .padding(.horizontal, 1.0)
                .background(Color(UIColor(named: color)!).opacity(0.5))
                .cornerRadius(1)
            Spacer(minLength: 2)
            Text("\((data.taskTime/3600))")
                .font(Font.system(size: 8, weight: .bold))
                .foregroundColor(Color(UIColor(named: color)!))
        }
    }
}

struct MonthWidgetCalendarView: View {
    let data: MonthWidgetData
    let isKorean: Bool
    let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    
    var body: some View {
        VStack(alignment: .center, spacing: 1) {
            MonthWidgetCalendarHeaderView(isKorean: isKorean)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(UIColor.placeholderText))
            Spacer()
                .frame(height: 2)
            
            LazyVGrid(columns: columns, spacing: calendarSpacing()) {
                ForEach(calanderDates, id: \.self) { day in
                    if day.monthInt != data.now.monthInt {
                        Spacer()
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        MonthWidgetDayCell(now: data.now, day: day, color: "D\(data.color)", data: getMonthWidgetCellData(day))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    var calanderDates: [Date] {
        var dates: [Date] = []
        var date = data.now.startMondayForCalendar
        
        while date <= data.now.lastDayOfMonth {
            dates.append(date)
            date = date.nextDay
        }
        return dates
    }
    
    func calendarSpacing() -> CGFloat {
        return calanderDates.count > 7*5 ? 2 : 5
    }
    
    func getMonthWidgetCellData(_ day: Date) -> MonthWidgetCellData? {
        if let target = self.data.cellsData.first(where: { $0.recordDay == day }) {
            return target
        } else {
            return nil
        }
    }
}

struct MonthWidgetCalendarHeaderView: View {
    let isKorean: Bool

    var body: some View {
        HStack(spacing: 0) {
            ForEach(weekDays, id: \.self) { day in
                Text(day)
                    .font(Font.system(size: 10, weight: .regular))
                    .foregroundColor(Color(UIColor.secondaryLabel))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(height: 12)
        }
    }
    
    var weekDays: [String] {
        if isKorean {
            return ["월", "화", "수", "목", "금", "토", "일"]
        } else {
            return ["M", "T", "W", "T", "F", "S", "S"]
        }
    }
}

struct MonthWidgetDayCell: View {
    let now: Date
    let day: Date
    let color: String
    let data: MonthWidgetCellData?
    
    var body: some View {
        HStack(alignment: .top, spacing: 1) {
            Text("\(day.dayInt)")
                .font(Font.system(size: 7, weight: isToday ? .heavy : .regular))
                .foregroundColor(isToday ? Color.red : Color(UIColor(named: "dayColor")!))
                .frame(width: 10, alignment: .trailing)
            ZStack {
                Circle()
                    .fill(Color(UIColor(named: color)!).opacity(opacity(isRecorded ? data!.totalTime : 0)))
                    .frame(width: 16, height: 16)
                
                Text("\(isRecorded ? Int(data!.totalTime/3600) : 0)")
                    .font(Font.system(size: 9.5, weight: .bold))
                    .foregroundColor(isRecorded ? Color(UIColor.black) : Color(UIColor.placeholderText))
            }
        }
    }
    
    var isToday: Bool {
        return day.dayInt == now.dayInt
    }
    
    var isRecorded: Bool {
        return data != nil
    }
    
    func opacity(_ time: Int) -> Double {
        if time == 0 {
            return 0
        } else if time < 2*3600 {
            return 0.3
        } else if time < 3*3600 {
            return 0.5
        } else if time < 4*3600 {
            return 0.6
        } else if time < 5*3600 {
            return 0.7
        } else if time < 6*3600 {
            return 0.8
        } else {
            return 1
        }
    }
}

struct MonthWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        MonthWidgetView(MonthWidgetData.snapshot)
            .previewDevice("iPad (9th generation)")
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
