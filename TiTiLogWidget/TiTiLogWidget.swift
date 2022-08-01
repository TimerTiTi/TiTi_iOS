//
//  TiTiLogWidget.swift
//  TiTiLogWidget
//
//  Created by 최수정 on 2022/08/01.
//  Copyright © 2022 FDEE. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),
                    configuration: ConfigurationIntent(),
                    progress: 0)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(),
                                configuration: configuration,
                                progress: 0)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate,
                                    configuration: configuration,
                                    progress: hourOffset*10+3)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let progress: Int
}

struct TiTiLogWidgetEntryView : View {
    var entry: Provider.Entry
    
    private let titleFontSize: CGFloat = 15
    private let progressFontSize: CGFloat = 23
    private let lineWidth: CGFloat = 13
    private let circleSize: CGFloat = 100
    private let circleTopPadding: CGFloat = 7
    private let circleBottompadding: CGFloat = 10
    
    var body: some View {
        VStack {
            Text("Month")
                .font(TiTiFont.HGGGothicssi(size: titleFontSize, weight: .heavy))
                .foregroundColor(.primary)
            
            ZStack {
                Circle()
                    .stroke(TiTiColor.graphColor(num: 3).toColor.opacity(0.5),
                            lineWidth: lineWidth)
                    .frame(width: circleSize, height: circleSize, alignment: .center)
                
                Circle()
                    .trim(from: 0, to: CGFloat(Double(entry.progress)*0.01))
                    .stroke(TiTiColor.graphColor(num: 3).toColor.opacity(1.0),
                            style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .frame(width: circleSize, height: circleSize, alignment: .center)
                    .rotationEffect(.degrees(-90))
                
                Text("\(entry.progress)%")
                    .font(TiTiFont.HGGGothicssi(size: progressFontSize, weight: .heavy))
                    .foregroundColor(.primary)
            }
            .padding(.top, circleTopPadding)
            .padding(.bottom, circleBottompadding)
        }
    }
}

@main
struct TiTiLogWidget: Widget {
    let kind: String = "TiTiLogWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            TiTiLogWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall])
    }
}

struct TiTiLogWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TiTiLogWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), progress: 33))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}
