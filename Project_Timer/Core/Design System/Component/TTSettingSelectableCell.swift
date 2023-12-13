//
//  TTSettingSelectableCell.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/13.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI

struct TTSettingSelectableCell: View {
    let title: String
    let subTitle: String?
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                UIColor.secondarySystemBackground.toColor
                
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(title)
                            .font(Typographys.font(.semibold_4, size: 17))
                            .foregroundStyle(Color.primary)
                        if subTitle != nil {
                            Text(subTitle ?? "")
                                .font(Typographys.font(.semibold_4, size: 11))
                                .foregroundStyle(UIColor.lightGray.toColor)
                        }
                        
                    }
                    Spacer()
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .renderingMode(.template)
                        .foregroundStyle(Color.primary.opacity(0.85))
                }
                .padding(.horizontal, 16)
            }
            .frame(height: subTitle != nil ? 64 : 55)
        }

    }
}

#Preview {
    TTSettingSelectableCell(title: "System 언어", subTitle: "한국어", isSelected: true) {
        print("tap")
    }
}
