//
//  CalendarWidgetEntry.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/05/11.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation
import WidgetKit

// MARK: CalendarWidget 표시를 위한 데이터 부분
struct CalendarWidgetEntry: TimelineEntry {
    var date: Date
    let relevance: TimelineEntryRelevance?
    let data: CalendarWidgetData
}
