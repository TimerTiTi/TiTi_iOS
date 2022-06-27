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
        Text("\(viewModel.value)")
            .frame(minWidth: 0, maxWidth: .infinity)
            .aspectRatio(0.5, contentMode: .fit)
            .transition(.opacity)
            .id(viewModel.uuid.uuidString + "\(viewModel.value)")
    }
}
