//
//  TTSettingListCell.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/13.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI

struct TTSettingListCell: View {
    let title: String
    var subTitle: String? = nil
    var rightTitle: String? = nil
    var isSelectable: Bool = false
    var isSelected: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                UIColor.secondarySystemGroupedBackground.toColor
                
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(title)
                            .font(Typographys.autoFont(title, .semibold_4, size: 17))
                            .foregroundStyle(Color.primary)
                        if subTitle != nil {
                            Text(subTitle ?? "")
                                .font(Typographys.font(.semibold_4, size: 11))
                                .foregroundStyle(UIColor.lightGray.toColor)
                        }
                        
                    }
                    Spacer()
                    
                    if isSelectable {
                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                            .renderingMode(.template)
                            .foregroundStyle(Color.primary.opacity(0.85))
                    }
                    if let rightTitle {
                        Text(rightTitle)
                            .font(Typographys.autoFont(rightTitle, .normal_3, size: 16))
                            .foregroundStyle(Color.primary)
                    }
                }
                .padding(.horizontal, 16)
            }
            .frame(height: subTitle != nil ? 64 : 55)
        }
    }
}

#Preview {
    TTSettingListCell(title: "简体中文", subTitle: "한국어", isSelected: true) {
        print("tap")
    }
}
