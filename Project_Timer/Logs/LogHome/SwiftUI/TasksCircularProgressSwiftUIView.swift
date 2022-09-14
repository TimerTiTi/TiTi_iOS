//
//  TasksCircularProgressSwiftUIView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/09/14.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

struct TasksCircularProgressSwiftUIView: View {
    private let blockValue = Float(0.003)
    private var progressValue: Float = 1
    private let fontSize: CGFloat = 28
    private let lineWidth: CGFloat = 19
    private let circleSize: CGFloat = 90
    private let tasks: [TaskInfo]
    private let isReverseColor: Bool
    private let colorIndex: Int
    
    init(tasks: [TaskInfo], isReverseColor: Bool, colorIndex: Int) {
        self.tasks = tasks
        self.isReverseColor = isReverseColor
        self.colorIndex = colorIndex
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(TiTiColor.graphColor(num: colorIndex).toColor.opacity(0.5),
                        lineWidth: lineWidth)
                .frame(width: circleSize, height: circleSize, alignment: .center)
            
            Circle()
                .trim(from: 0, to: 1)
                .stroke(TiTiColor.graphColor(num: colorIndex).toColor.opacity(1.0),
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .frame(width: circleSize, height: circleSize, alignment: .center)
                .rotationEffect(.degrees(-90))
            
            Text("\(totalHours)")
                .font(TiTiFont.HGGGothicssiP60g(size: fontSize))
                .foregroundColor(.primary)
        }
    }
}

extension TasksCircularProgressSwiftUIView {
    private var totalHours: Int {
        return tasks.reduce(0, { $0 + $1.taskTime })/3600
    }
}
