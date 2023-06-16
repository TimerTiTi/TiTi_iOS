//
//  CalendarWidget.swift
//  CalendarWidget
//
//  Created by Kang Minsang on 2023/02/08.
//  Copyright © 2023 FDEE. All rights reserved.
//

import WidgetKit
import SwiftUI

// MARK: Widget 내용 및 설정 부분
struct CalendarWidget: Widget {
    let kind: String = "CalendarWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CalendarWidgetProvider()) { entry in
            CalendarWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Calendar widget".localizedForWidget())
        .description("Widget shows the top 5 tasks and the recording time by date.".localizedForWidget())
        .supportedFamilies([.systemMedium])
    }
}

// MARK: Entry를 받아 상황에 맞는 SwiftUI 뷰를 반환하는 부분
struct CalendarWidgetEntryView: View {
    var entry: CalendarWidgetEntry
    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View {
        // MARK: 만약 동일한 위젯을 사이즈별로 제공하고 싶은 경우: switch family 로 분기처리 하면 된다.
        CalendarWidgetView(entry.data)
            .widgetURL(entry.data.url)
    }
}

struct CalendarWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CalendarWidgetEntryView(entry: CalendarWidgetEntry(date: Date(), relevance: nil, data: CalendarWidgetData.snapshot))
                .previewDevice("iPad (9th generation)")
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            CalendarWidgetEntryView(entry: CalendarWidgetEntry(date: Date(), relevance: nil, data: CalendarWidgetData.snapshot))
                .previewDevice("iPhone 13 Pro")
                .previewContext(WidgetPreviewContext(family: .systemMedium))
//                .environment(\.sizeCategory, .large)
            
            CalendarWidgetEntryView(entry: CalendarWidgetEntry(date: Date(), relevance: nil, data: CalendarWidgetData.snapshot))
                .redacted(reason: .placeholder)
                .previewDevice("iPhone 13 Pro")
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            CalendarWidgetEntryView(entry: CalendarWidgetEntry(date: Date(), relevance: nil, data: CalendarWidgetData.snapshot))
                .previewDevice("iPad Pro (12.9-inch) (6th generation)")
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}

