//
//  CalendarWidgetProvider.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/05/11.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation
import WidgetKit

// MARK: Timeline 및 Entry 반환 부분
struct CalendarWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> CalendarWidgetEntry {
        CalendarWidgetEntry(data: CalendarWidgetData.snapshot)
    }

    func getSnapshot(in context: Context, completion: @escaping (CalendarWidgetEntry) -> ()) {
        let entry = CalendarWidgetEntry(data: CalendarWidgetData.snapshot)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CalendarWidgetEntry>) -> ()) {
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let widgetData = Storage.retrive(CalendarWidgetData.fileName, from: .sharedContainer, as: CalendarWidgetData.self) ?? CalendarWidgetData.snapshot
        let entry = CalendarWidgetEntry(data: widgetData)
        let entries = [entry]
        
        // MARK: 5분이 지나면 tineline의 entries 가 모두 표시가 되기 전에 새로운 entry를 생성
        let term = Calendar.current.date(byAdding: .minute, value: 5, to: Date()) ?? Date()
        let timeline = Timeline(entries: entries, policy: .after(term))
        
        completion(timeline)
    }
}
