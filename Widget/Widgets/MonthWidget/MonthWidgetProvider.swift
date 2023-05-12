//
//  MonthWidgetProvider.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/05/11.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation
import WidgetKit

// MARK: Timeline 및 Entry 반환 부분
struct MonthWidgetProvider: IntentTimelineProvider {
    func placeholder(in context: Context) -> MonthWidgetEntry {
        MonthWidgetEntry(data: MonthWidgetData(color: .D1))
    }

    func getSnapshot(for configuration: SelectColorIntent, in context: Context, completion: @escaping (MonthWidgetEntry) -> ()) {
        let entry = MonthWidgetEntry(data: MonthWidgetData(color: .D1))
        completion(entry)
    }

    func getTimeline(for configuration: SelectColorIntent, in context: Context, completion: @escaping (Timeline<MonthWidgetEntry>) -> ()) {
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        // MARK: 현재상태의 Entry만으로 Timeline을 만드는 경우
        let selectedIntent = color(for: configuration)
        let widgetData = MonthWidgetData(color: selectedIntent)
        let entry = MonthWidgetEntry(data: widgetData)
        let entries = [entry]
        
        // MARK: 5분이 지나면 tineline의 entries 가 모두 표시가 되기 전에 새로운 entry를 생성
        let term = Calendar.current.date(byAdding: .minute, value: 5, to: Date()) ?? Date()
        let timeline = Timeline(entries: entries, policy: .after(term))
        
        completion(timeline)
    }
}

extension MonthWidgetProvider {
    func color(for configuration: SelectColorIntent) -> MonthWidgetData.Color {
        switch configuration.Color {
        case .d1: return .D1
        case .d2: return .D2
        case .d3: return .D3
        default:
            return .D1
        }
    }
}
