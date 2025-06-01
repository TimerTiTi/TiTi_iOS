//
//  AdEvent.swift
//  Project_Timer
//
//  Created by Minsang on 5/28/25.
//  Copyright © 2025 FDEE. All rights reserved.
//

import Foundation

enum AdEvent: AnalyticsEvent {
    var emoji: String { "💰" }
    var category: String { "ad" }
    
    case ad_visit(screen: String, reason: String) // 광고가 존재하는 화면 진입
    case ad_declined(screen: String) // 광고 표출 거부
    case ad_request(screen: String) // 광고 표출 요청
    case ad_request_impression(screen: String) // 광고 표출 성공
    case ad_request_failed(screen: String, reason: String) // 광고 표출 실패
    
    var name: String {
        switch self {
        case .ad_visit: "ad_visit"
        case .ad_declined: "ad_declined"
        case .ad_request: "ad_request"
        case .ad_request_impression: "ad_request_impression"
        case .ad_request_failed: "ad_request_failed"
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case let .ad_visit(screen, reason),
                let .ad_request_failed(screen, reason):
            return [
                "screen": screen,
                "reason": reason
            ]
        case let .ad_declined(screen),
                let .ad_request(screen),
                let .ad_request_impression(screen):
            return [
                "screen": screen
            ]
        }
    }
}

enum AdScreen: String {
    case EditRecord
}
