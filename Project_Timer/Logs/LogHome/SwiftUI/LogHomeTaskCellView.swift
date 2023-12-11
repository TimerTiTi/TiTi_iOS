//
//  LogHomeTaskCellView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/09/10.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

struct LogHomeTaskCellView: View {
    let rank: Int
    let taskName: String
    let taskTime: Int
    let colorIndex: Int
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            HStack(alignment: .center, spacing: 0) {
                Text("Top\(rank)")
                    .font(Fonts.HGGGothicssiP80g(size: 10.5))
                    .foregroundColor(TiTiColor.graphColor(num: colorIndex).toColor)
                    .frame(width: 24, alignment: .leading)
                Text("\(taskName)")
                    .font(Fonts.HGGGothicssiP60g(size: 11))
                    .padding(.horizontal, 2)
                    .background(TiTiColor.graphColor(num: colorIndex).withAlphaComponent(0.5).toColor)
                    .frame(width: 134, alignment: .leading)
                    .lineLimit(1)
                Spacer(minLength: 2)
                Text("\(taskTime/3600) H")
                    .font(Fonts.HGGGothicssiP80g(size: 10.5))
                    .foregroundColor(TiTiColor.graphColor(num: colorIndex).toColor)
            }
            Divider()
                .frame(height: 1)
                .background(UIColor(named: "System_border")?.toColor)
        }
        .frame(width: 188, height: 25, alignment: .trailing)
    }
}
