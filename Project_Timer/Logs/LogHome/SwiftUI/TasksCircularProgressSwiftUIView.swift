//
//  TasksCircularProgressSwiftUIView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/09/14.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

struct TasksCircularProgressSwiftUIView: View {
    private let blockValue = CGFloat(0.003)
    private let fontSize: CGFloat = 28
    private let lineWidth: CGFloat = 19
    private let circleSize: CGFloat = 90
    private let tasksAndBlocks: [Float]
    private let isReverseColor: Bool
    private let colorIndex: Int
    private let totalHours: Int
    
    private let totalValue: CGFloat
    private var progressValue: CGFloat = 1
    
    init(totalTime: Int, tasks: [TaskInfo], isReverseColor: Bool, colorIndex: Int) {
        let tasksInfos = TasksCircularProgressDTO(tasks: tasks)
        self.tasksAndBlocks = tasksInfos.tasksAndBlocks
        self.isReverseColor = isReverseColor
        self.colorIndex = colorIndex
        self.totalHours = totalTime/3600
        self.totalValue = CGFloat(tasks.reduce(0, { $0 + $1.taskTime })/3600) + self.blockValue*CGFloat(tasks.count)
    }
    
    var body: some View {
        if self.tasksAndBlocks.isEmpty {
            ZStack {
                Circle()
                    .stroke(TiTiColor.graphColor(num: colorIndex).toColor.opacity(0.5),
                            lineWidth: lineWidth)
                    .frame(width: circleSize, height: circleSize, alignment: .center)
                Text("\(totalHours)")
                    .font(Fonts.HGGGothicssiP60g(size: fontSize))
                    .foregroundColor(.primary)
            }
        } else {
            ZStack {
                ForEach(0..<tasksAndBlocks.count, id: \.self) { index in
                    self.getProgress(index: index, value: tasksAndBlocks[index], isBlock: index%2 == 0)
                }
                Text("\(totalHours)")
                    .font(Fonts.HGGGothicssiP60g(size: fontSize))
                    .foregroundColor(.primary)
            }
        }
    }
}

extension TasksCircularProgressSwiftUIView {
    private func getProgress(index: Int, value: Float, isBlock: Bool) -> some View {
        return Circle()
            .trim(from: 0, to: CGFloat(value))
            .stroke(self.getProgressColor(index: index/2, isBlock: isBlock), style: StrokeStyle(lineWidth: lineWidth, lineCap: .butt))
            .frame(width: circleSize, height: circleSize, alignment: .center)
            .rotationEffect(.degrees(-90))
    }
}

extension TasksCircularProgressSwiftUIView {
    private func getProgressColor(index: Int, isBlock: Bool) -> Color {
        if isBlock {
            return Color(UIColor.systemBackground)
        } else {
            var progressColorIndex = 0
            if isReverseColor {
                progressColorIndex = (colorIndex - (tasksAndBlocks.count/2-1) + index + 12)%12
            } else {
                progressColorIndex = (colorIndex + (tasksAndBlocks.count/2-1) - index + 12)%12
            }
            return TiTiColor.graphColor(num: progressColorIndex == 0 ? 12 : progressColorIndex).toColor
        }
    }
}
