//
//  MonthWidget.swift
//  MonthWidget
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

struct MonthWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        MonthWidgetView()
    }
}

struct MonthWidget: Widget {
    let kind: String = "MonthWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            MonthWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Month widget".localized())
        .description("상위 5가지 Task 내용과 날짜별 기록시간을 보여줍니다.")
        .supportedFamilies([.systemMedium])
    }
}

struct MonthWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MonthWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
                .previewDevice("iPad (9th generation)")
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            MonthWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
                .previewDevice("iPad Pro (11-inch) (4th generation)")
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            MonthWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
                .previewDevice("iPhone 13 Pro")
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            MonthWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
                .previewDevice("iPad Pro (12.9-inch) (6th generation)")
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}

