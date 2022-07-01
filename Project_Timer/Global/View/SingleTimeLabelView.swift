//
//  TimeLabelView.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/06/23.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

struct SingleTimeLabelView: View {
    @ObservedObject var viewModel: SingleTimeLabelViewModel
    
    var body: some View {
        ZStack {
            Text("\(viewModel.oldValue)")
                .opacity(viewModel.isNewValueVisible ? 0 : 1)
            
            Text("\(viewModel.newValue)")
                .opacity(viewModel.isNewValueVisible ? 1 : 0)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .aspectRatio(0.55, contentMode: .fit)
    }
}
