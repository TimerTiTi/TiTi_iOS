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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct widget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            widgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
                .previewDevice("iPad (9th generation)")
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
