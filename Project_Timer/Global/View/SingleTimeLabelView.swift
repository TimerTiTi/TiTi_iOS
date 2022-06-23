//
//  TimeLabelView.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/06/23.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

struct SingleTimeLabelView: View {
    @ObservedObject var viewModel: TimeLabelViewModel
    
    var body: some View {
        GeometryReader { geometry  in
            VStack(spacing: 0) {
                Group {
                    Text("\(viewModel.oldValue)")
                    Text("\(viewModel.newValue)")
                }
                .font(.system(size: 30))
                .minimumScaleFactor(0.1)
                .frame(width: geometry.size.width,
                       height: geometry.size.height)
            }
            .offset(x: 0, y: viewModel.update ? -geometry.size.height : 0)
            .frame(maxHeight: geometry.size.height, alignment: .top)
            .clipped()
        }
    }
}
