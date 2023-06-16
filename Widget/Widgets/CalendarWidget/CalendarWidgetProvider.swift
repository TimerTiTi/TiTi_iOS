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
        CalendarWidgetEntry(date: Date(), relevance: nil, data: CalendarWidgetData.snapshot)
    }

    func getSnapshot(in context: Context, completion: @escaping (CalendarWidgetEntry) -> ()) {
        let entry = CalendarWidgetEntry(date: Date(), relevance: nil, data: CalendarWidgetData.snapshot)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CalendarWidgetEntry>) -> ()) {
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        let widgetData = Storage.retrive(CalendarWidgetData.fileName, from: .sharedContainer, as: CalendarWidgetData.self) ?? CalendarWidgetData.snapshot
        let entry = CalendarWidgetEntry(date: currentDate, relevance: TimelineEntryRelevance(score: 1), data: widgetData)
        let entries = [entry]
        
        // MARK: 1시간이 지나면 tineline의 entries 가 모두 표시가 되기 전에 새로운 entry를 생성
        let term = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
        let timeline = Timeline(entries: entries, policy: .after(term))
        
        completion(timeline)
    }
}
