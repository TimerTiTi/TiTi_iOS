//
//  TimeLabelView.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/06/23.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

struct SingleTimeLabelView: View {
    private var update: Bool
    private var oldValue: Int
    private var newValue: Int
    
    init(oldValue: Int, newValue: Int, update: Bool) {
        self.oldValue = oldValue
        self.newValue = newValue
        self.update = update
    }
    
    var body: some View {
        GeometryReader { geometry  in
            VStack(spacing: 0) {
                Group {
                    Text("\(oldValue)")
                    Text("\(newValue)")
                }
                .font(Font.custom("HGGGothicssiP60g", size: 70))
                .foregroundColor(.white)
                .minimumScaleFactor(0.1)
                .frame(width: geometry.size.width,
                       height: geometry.size.height)
            }
            .offset(x: 0, y: update ? -geometry.size.height : 0)
            .frame(maxHeight: geometry.size.height,
                   alignment: .top)
            .clipped()
        }
    }
}
