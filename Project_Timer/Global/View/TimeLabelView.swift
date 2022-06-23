//
//  TimeLabelView.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/06/24.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

struct TimeLabelView: View {
    @ObservedObject var viewModel: TimeLabelViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            SingleTimeLabelView(oldValue: viewModel.oldValue, newValue: viewModel.newValue, update: viewModel.update)
                
            SingleTimeLabelView(oldValue: viewModel.oldValue, newValue: viewModel.newValue, update: viewModel.update)

            Text(":")
                .font(Font.custom("HGGGothicssiP60g", size: 70))
                .foregroundColor(.white)

            SingleTimeLabelView(oldValue: viewModel.oldValue, newValue: viewModel.newValue, update: viewModel.update)
            
            SingleTimeLabelView(oldValue: viewModel.oldValue, newValue: viewModel.newValue, update: viewModel.update)

            Text(":")
                .font(Font.custom("HGGGothicssiP60g", size: 70))
                .foregroundColor(.white)

            SingleTimeLabelView(oldValue: viewModel.oldValue, newValue: viewModel.newValue, update: viewModel.update)

            SingleTimeLabelView(oldValue: viewModel.oldValue, newValue: viewModel.newValue, update: viewModel.update)
        }
        .frame(width: 300, height: 100, alignment: .center)
        
    }
}
