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

// MARK: Widget 내용 및 설정 부분
struct MonthWidget: Widget {
    let kind: String = "MonthWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: SelectColorIntent.self, provider: MonthWidgetProvider()) { entry in
            MonthWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Month widget".localized())
        .description("Widget shows the top 5 tasks and the recording time by date.".localized())
        .supportedFamilies([.systemMedium])
    }
}

// MARK: Entry를 받아 상황에 맞는 SwiftUI 뷰를 반환하는 부분
struct MonthWidgetEntryView: View {
    var entry: MonthWidgetEntry
    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View {
        // MARK: 만약 동일한 위젯을 사이즈별로 제공하고 싶은 경우: switch family 로 분기처리 하면 된다.
        MonthWidgetView(entry.data)
    }
}

struct MonthWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MonthWidgetEntryView(entry: MonthWidgetEntry(data: MonthWidgetData(color: .D1)))
                .previewDevice("iPad (9th generation)")
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            MonthWidgetEntryView(entry: MonthWidgetEntry(data: MonthWidgetData(color: .D1)))
                .previewDevice("iPhone 13 Pro")
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            MonthWidgetEntryView(entry: MonthWidgetEntry(data: MonthWidgetData(color: .D1)))
                .redacted(reason: .placeholder)
                .previewDevice("iPhone 13 Pro")
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            MonthWidgetEntryView(entry: MonthWidgetEntry(data: MonthWidgetData(color: .D1)))
                .previewDevice("iPad Pro (12.9-inch) (6th generation)")
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}

