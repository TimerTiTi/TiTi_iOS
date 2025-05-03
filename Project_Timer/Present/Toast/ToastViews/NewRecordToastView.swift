//
//  NewRecordToastView.swift
//  Project_Timer
//
//  Created by Minsang on 5/2/25.
//  Copyright © 2024 FDEE. All rights reserved.
//

import SwiftUI

struct NewRecordToastView: ToastView {
    let height: CGFloat = 40
    let topConstraint: CGFloat = 8
    let recordDate: String
    
    var body: some View {
        ZStack(alignment: .center) {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color(uiColor: Colors.Primary.value))
                    .frame(width: 16, height: 16)
                
                Text(recordDate)
                    .font(Fonts.PretendardMedium(size: 16))
                    .foregroundStyle(Color(uiColor: Colors.Primary.value))
                
                Text(Localized.string(.Toast_Text_NewRecord))
                    .font(Fonts.PretendardMedium(size: 16))
                    .foregroundStyle(Color(uiColor: Colors.TextPrimary.value))
            }
            .padding(
                EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 16)
            )
        }
        .zIndex(1)
    }
}

#Preview {
    NewRecordToastView(recordDate: "25.05.01")
}
