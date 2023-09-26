//
//  CalendarWidgetView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/05/08.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI
import WidgetKit

// MARK: CalendarWidget SwiftUI 뷰
struct CalendarWidgetView: View {
    var data: CalendarWidgetData
    let isApp: Bool
    
    init(_ data: CalendarWidgetData, isApp: Bool = false) {
        self.data = data
        self.isApp = isApp
    }
    
    var body: some View {
        ZStack {
            HStack {
                CalendarWidgetTasksView(data: data, isKorean: isKorean)
                Spacer(minLength: 10)
                CalendarWidgetCalendarView(data: data, isKorean: isKorean)
            }
            .padding(.all)
        }
        .widgetBackground(backgroundView: UIColor.systemBackground.toColor)
        .if(isApp) { view in
            view.background(UIColor.secondarySystemGroupedBackground.toColor)
        }
    }
    
    var isKorean: Bool {
        return Language.currentLanguage == .ko
    }
}

struct CalendarWidgetTasksView: View {
    let data: CalendarWidgetData
    let isKorean: Bool
    
    var body: some View {
        VStack(alignment: .center) {
            Text(month)
                .font(Font.system(size: 16, weight: .bold))
            Spacer()
            if data.tasksData.count != 0 {
                VStack(alignment: .leading) {
                    ForEach(0..<data.tasksData.count, id: \.self) { index in
                        CalendarWidgetTaskRowView(data: data.tasksData[index], color: color(index))
                            .frame(height: 10)
                    }
                }
                .frame(maxWidth: .infinity)
            } else {
                CalendarWidgetNoDataInfoView(color: "D\(data.color)")
                    .frame(maxWidth: .infinity)
            }
            
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
        if data.isReverseColor {
            let newColorNum = (data.color-index+12)%12
            return newColorNum != 0 ? "D\(newColorNum)" : "D12"
        } else {
            let newColorNum = (data.color+index)%12
            return newColorNum != 0 ? "D\(newColorNum)" : "D12"
        }
    }
}

struct CalendarWidgetTaskRowView: View {
    let data: CalendarWidgetTaskData
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

struct CalendarWidgetNoDataInfoView: View {
    let color: String
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            Text("There's no record this month!".localizedForWidget())
                .multilineTextAlignment(.center)
                .font(Font.system(size: 8.8, weight: .semibold))
                .foregroundColor(Color(UIColor(named: color)!))
            Text("🥺")
                .font(Font.system(size: 30))
        }
    }
}

struct CalendarWidgetCalendarView: View {
    let data: CalendarWidgetData
    let isKorean: Bool
    let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    
    var body: some View {
        VStack(alignment: .center, spacing: 1) {
            CalendarWidgetHeaderView(isKorean: isKorean)
            
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
                        CalendarWidgetDayCell(now: data.now, day: day, color: "D\(data.color)", targetTime: data.targetTime, data: getCalendarWidgetCellData(day))
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
    
    func getCalendarWidgetCellData(_ day: Date) -> CalendarWidgetCellData? {
        if let target = self.data.cellsData.first(where: { $0.recordDay == day }) {
            return target
        } else {
            return nil
        }
    }
}

struct CalendarWidgetHeaderView: View {
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

struct CalendarWidgetDayCell: View {
    let now: Date
    let day: Date
    let color: String
    let targetTime: Int
    let data: CalendarWidgetCellData?
    
    var body: some View {
        HStack(alignment: .top, spacing: 1) {
            Text("\(day.dayInt)")
                .font(Font.system(size: 7, weight: isToday ? .heavy : .regular))
                .foregroundColor(isToday ? Color.red : Color(UIColor(named: "dayColor")!))
                .frame(width: 11, alignment: .trailing)
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
        } else if time < Int(Double(targetTime)*Double(2)/Double(6)) {
            return 0.3
        } else if time < Int(Double(targetTime)*Double(3)/Double(6)) {
            return 0.5
        } else if time < Int(Double(targetTime)*Double(4)/Double(6)) {
            return 0.6
        } else if time < Int(Double(targetTime)*Double(5)/Double(6)) {
            return 0.7
        } else if time < Int(Double(targetTime)*Double(6)/Double(6)) {
            return 0.8
        } else {
            return 1
        }
    }
}

//struct CalendarWidgetView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalendarWidgetView(CalendarWidgetData.snapshot)
//            .previewDevice("iPad (9th generation)")
//            .previewContext(WidgetPreviewContext(family: .systemMedium))
//    }
//}
