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
            leftView
            Spacer(minLength: 10)
            MonthWidgetRightView(now: self.now, color: "D\(data.color.rawValue)", isKorean: isKorean)
        }
        .padding(.all)
        .background(Color(UIColor.systemBackground))
    }
    
    var leftView: some View {
        VStack(alignment: .center) {
            Text(month)
                .font(Font.system(size: 16, weight: .bold))
            Spacer()
            VStack(alignment: .leading) {
                ForEach(randomTaskDatas, id: \.self) { data in
                    TaskRowView(data: data)
                        .frame(height: 10)
                }
            }
            .frame(maxWidth: .infinity)
            Spacer()
        }
        .frame(width: 80)
    }
    
    var now: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return Int(dateFormatter.string(from: self.data.now)) ?? 0
    }
    
    var randomTaskDatas: [MonthWidgetTaskData] {
        var datas: [MonthWidgetTaskData] = []
        let tasks: [(String, Int)] = randomTasks
        for i in 0..<5 {
            datas.append(MonthWidgetTaskData(taskName: tasks[i].0, taskTime: tasks[i].1, color: color(i)))
        }
        
        return datas
    }
    
    var randomTasks: [(String, Int)] {
        let task1 = "TiTi 개발"
        let task2 = "졸업프로젝트 개발"
        let task3 = "코딩테스트"
        let task4 = "TiTi 회의"
        let task5 = "독서"
        
        return [(task1, randomInt), (task2, randomInt), (task3, randomInt), (task4, randomInt), (task5, randomInt)].sorted { $0.1 > $1.1 }
    }
    
    var randomInt: Int {
        return Int.random(in: 1...30)
    }
    
    func color(_ index: Int) -> String {
        let newColorNum = (data.color.rawValue + index)%12
        return newColorNum != 0 ? "D\(newColorNum)" : "D12"
    }
    
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        dateFormatter.locale = Locale(identifier: isKorean ? "ko_KR" : "en_US")
        return dateFormatter.string(from: data.now)
    }
    
    var isKorean: Bool {
        let languageCode = Locale.current.language.languageCode?.identifier ?? "en"
        return languageCode == "ko"
    }
}

struct MonthWidgetRightView: View {
    let now: Int
    let color: String
    let isKorean: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 1) {
            HStack(spacing: 0) {
                ForEach(weekDays, id: \.self) { d in
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
                        if day < 2 {
                            Spacer()
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            MonthWidgetDayCell(data: MonthWidgetCellData(day: day, now: now, time: randomTime, color: color))
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
                Spacer(minLength: 0)
                HStack(spacing: 0) {
                    ForEach(8..<15) { day in
                        MonthWidgetDayCell(data: MonthWidgetCellData(day: day, now: now, time: randomTime, color: color))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                Spacer(minLength: 0)
                HStack(spacing: 0) {
                    ForEach(15..<22) { day in
                        MonthWidgetDayCell(data: MonthWidgetCellData(day: day, now: now, time: randomTime, color: color))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                Spacer(minLength: 0)
                HStack(spacing: 0) {
                    ForEach(22..<29) { day in
                        MonthWidgetDayCell(data: MonthWidgetCellData(day: day, now: now, time: randomTime, color: color))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                Spacer(minLength: 0)
                HStack(spacing: 0) {
                    ForEach(29..<36) { day in
                        if day < 33 {
                            MonthWidgetDayCell(data: MonthWidgetCellData(day: day, now: now, time: randomTime, color: color))
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            Spacer()
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    var randomTime: Int {
        return Int.random(in: 1...6)
    }
    
    var weekDays: [String] {
        if isKorean {
            return ["일", "월", "화", "수", "목", "금", "토"]
        } else {
            return ["S", "M", "T", "W", "T", "F", "S"]
        }
    }
}

struct TaskRowView: View {
    let data: MonthWidgetTaskData
    
    var body: some View {
        HStack() {
            RoundedRectangle(cornerRadius: 1)
                .fill(Color(UIColor(named: data.color)!))
                .frame(width: 3)
            Spacer()
                .frame(width: 3)
            Text(data.taskName)
                .font(Font.system(size: 9, weight: .semibold))
                .padding(.horizontal, 1.0)
                .background(Color(UIColor(named: data.color)!).opacity(0.5))
                .cornerRadius(1)
            Spacer()
            Text("\(data.taskTime)")
                .font(Font.system(size: 8, weight: .bold))
                .foregroundColor(Color(UIColor(named: data.color)!))
        }
    }
}

struct MonthWidgetDayCell: View {
    let data: MonthWidgetCellData
    
    var body: some View {
        HStack(alignment: .top, spacing: 1) {
            Text("\(data.day)")
                .font(Font.system(size: 7, weight: isToday ? .heavy : .regular))
                .foregroundColor(isToday ? Color.red : Color(UIColor(named: "dayColor")!))
                .frame(width: 10, alignment: .trailing)
            ZStack {
                Circle()
                    .fill(Color(UIColor(named: data.color)!).opacity(opacity(isBeforeToday ? data.time : 0)))
                    .frame(width: 16, height: 16)
                
                Text("\(isBeforeToday ? data.time : 0)")
                    .font(Font.system(size: 9.5, weight: .bold))
                    .foregroundColor(isBeforeToday ? Color(UIColor.black) : Color(UIColor.placeholderText))
            }
        }
    }
    
    var isToday: Bool {
        return data.day == data.now
    }
    
    var isBeforeToday: Bool {
        return data.day < data.now
    }
    
    func opacity(_ time: Int) -> Double {
        if time == 0 {
            return 0
        } else if time < 2 {
            return 0.3
        } else if time < 3 {
            return 0.5
        } else if time < 4 {
            return 0.6
        } else if time < 5 {
            return 0.7
        } else if time < 6 {
            return 0.8
        } else {
            return 1
        }
    }
}

struct MonthWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        MonthWidgetView(MonthWidgetData(color: .D2))
            .previewLayout(.fixed(width: 338, height: 158))
    }
}
