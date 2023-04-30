//
//  widget.swift
//  widget
//
//  Created by Kang Minsang on 2023/02/08.
//  Copyright © 2023 FDEE. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct widgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        MonthWidgetMiddleView()
    }
}

struct widget: Widget {
    let kind: String = "widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            widgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct MonthWidgetMiddleView: View {
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

struct widget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            widgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
                .previewDevice("iPad (9th generation)")
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            widgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
                .previewDevice("iPad Pro (11-inch) (4th generation)")
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            widgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
                .previewDevice("iPhone 13 Pro")
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            widgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
                .previewDevice("iPad Pro (12.9-inch) (6th generation)")
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
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
