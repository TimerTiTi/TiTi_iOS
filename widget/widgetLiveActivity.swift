//
//  widgetLiveActivity.swift
//  widget
//
//  Created by Kang Minsang on 2023/02/08.
//  Copyright © 2023 FDEE. All rights reserved.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TiTiLockscreenAttributes: ActivityAttributes {
    public typealias titiStatus = ContentState
    
    public struct ContentState: Codable, Hashable {
        var taskName: String
        var timer: ClosedRange<Date>
    }
    
    var isTimer: Bool
    var colorIndex: Int
}

struct widgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TiTiLockscreenAttributes.self) { context in
            // Create the presentation that appears on the Lock Screen and as a
            // banner on the Home Screen of devices that don't support the
            // Dynamic Island.
            LockScreenLiveActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T")
            } minimal: {
                Text("Min")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

struct LockScreenLiveActivityView: View {
    let context: ActivityViewContext<TiTiLockscreenAttributes>
    
    var body: some View {
        VStack(spacing: -3) {
            Spacer(minLength: 14)
            Text("\(context.state.taskName)")
            Text(timerInterval: context.state.timer, countsDown: context.attributes.isTimer)
                .multilineTextAlignment(.center)
                .monospacedDigit()
                .font(.system(size: 44, weight: .semibold))
                .foregroundColor(Color(UIColor(named: "D\(context.attributes.colorIndex)")!))
//                .shadow(color: .black, radius: 1)
            Spacer()
        }
        .background(Color(UIColor.systemBackground).opacity(0.6))
    }
}

struct widgetLiveActivity_Previews: PreviewProvider {
    static let attributes = TiTiLockscreenAttributes(isTimer: true, colorIndex: 6)
    static let contentState = TiTiLockscreenAttributes.ContentState(taskName: "TiTi 개발", timer: (Date()...Calendar.current.date(byAdding: .hour, value: 3, to: Date())!))

    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}
