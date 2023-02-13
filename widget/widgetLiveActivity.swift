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

struct widgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TiTiLockscreenAttributes.self) { context in
            // Presentation on Lock Screen and as a banner on the Home Screen
            LockScreenLiveActivityView(context: context)
        } dynamicIsland: { context in
            // Create the presentations that appear in the Dynamic Island.
            DynamicIsland {
                // Create the expanded presentation.
                DynamicIslandExpandedRegion(.center) {
                    Text("\(context.state.taskName)")
                        .lineLimit(1)
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    Text(timerInterval: context.state.timer, countsDown: context.attributes.isTimer)
                        .multilineTextAlignment(.center)
                        .monospacedDigit()
                        .font(.system(size: 44, weight: .semibold))
                        .foregroundColor(color(context: context))
                }
            } compactLeading: {
                Image("titiIcon")
            } compactTrailing: {
                Text(timerInterval: context.state.timer, countsDown: context.attributes.isTimer)
                    .monospacedDigit()
                    .frame(width: 50)
                    .font(.system(size: 12.7, weight: .semibold))
                    .foregroundColor(Color(UIColor(named: "tintColor")!))
            } minimal: {
                Image("titiIcon")
            }
            .contentMargins(.all, 8, for: .expanded)
        }
    }
    
    func color(context: ActivityViewContext<TiTiLockscreenAttributes>) -> Color {
        if let color = UserDefaults.shared.colorForKey(key: context.attributes.isTimer ? .timerBackground : .stopwatchBackground) {
            return Color(color)
        } else {
            return Color(UIColor(named: "D1")!)
        }
    }
}

struct LockScreenLiveActivityView: View {
    let context: ActivityViewContext<TiTiLockscreenAttributes>
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    
    var body: some View {
        if isLuminanceReduced {
            VStack(spacing: -3) {
                Spacer(minLength: 14)
                Text("\(context.state.taskName)")
                    .foregroundColor(.primary.opacity(0.5))
                Text(timerInterval: context.state.timer, countsDown: context.attributes.isTimer)
                    .multilineTextAlignment(.center)
                    .monospacedDigit()
                    .font(.system(size: 44, weight: .semibold))
                    .foregroundColor(color(context: context).opacity(0.5))
                Spacer()
            }
            .background(Color(UIColor.systemBackground).opacity(0.6))
        } else {
            VStack(spacing: -3) {
                Spacer(minLength: 14)
                Text("\(context.state.taskName)")
                Text(timerInterval: context.state.timer, countsDown: context.attributes.isTimer)
                    .multilineTextAlignment(.center)
                    .monospacedDigit()
                    .font(.system(size: 44, weight: .semibold))
                    .foregroundColor(color(context: context))
                Spacer()
            }
            .background(Color(UIColor.systemBackground).opacity(0.6))
        }
    }
    
    func color(context: ActivityViewContext<TiTiLockscreenAttributes>) -> Color {
        if let color = UserDefaults.shared.colorForKey(key: context.attributes.isTimer ? .timerBackground : .stopwatchBackground) {
            return Color(color)
        } else {
            return Color(UIColor(named: "D1")!)
        }
    }
}

struct widgetLiveActivity_Previews: PreviewProvider {
    static let attributes = TiTiLockscreenAttributes(isTimer: true)
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
