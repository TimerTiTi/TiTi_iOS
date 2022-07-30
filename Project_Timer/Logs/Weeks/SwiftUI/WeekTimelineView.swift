//
//  WeekTimelineView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/07/30.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

struct WeekTimeBlock : Identifiable {
    var id : Int
    var day: String
    var sumTime : Int
}

struct WeekTimelineView: View {
    var frameHeight: CGFloat = 130
    @ObservedObject var viewModel: WeekTimelineVM
    
    init(frameHeight: CGFloat, viewModel: WeekTimelineVM) {
        self.frameHeight = frameHeight - 20
        self.viewModel = viewModel
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct WeekTimelineView_Previews: PreviewProvider {
    static var previews: some View {
        let dummyTimes = (0...6).map { idx in
            WeekTimeBlock(id: idx, day: "7/\(idx)", sumTime: Int.random(in: 10800..<21600))
        }
        WeekTimelineView(frameHeight: 130, viewModel: WeekTimelineVM(weekTimes: dummyTimes))
    }
}
