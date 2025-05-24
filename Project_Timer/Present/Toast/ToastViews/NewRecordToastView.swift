//
//  NewRecordToastView.swift
//  Project_Timer
//
//  Created by Minsang on 5/2/25.
//  Copyright © 2024 FDEE. All rights reserved.
//

import SwiftUI

struct NewRecordToastView: ToastView {
    let height: CGFloat = 48
    let topConstraint: CGFloat = 0
    let recordDate: String
    @State var scale: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .center) {
            HStack(spacing: 16) {
                Circle()
                    .scaleEffect(scale)
                    .foregroundStyle(Color(uiColor: Colors.Primary.value))
                    .frame(width: 16, height: 16)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
                                scale = 1.0
                            }
                        }
                    }
                
                HStack(spacing: 8) {
                    Text(recordDate)
                        .font(Fonts.PretendardSemiBold(size: 16))
                        .foregroundStyle(Color(UIColor.label))
                    
                    Text(Localized.string(.Toast_Text_NewRecord))
                        .font(Fonts.PretendardMedium(size: 16))
                        .foregroundStyle(Color(uiColor: Colors.TextPrimary.value))
                }
            }
            .padding(
                EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 18)
            )
        }
        .zIndex(1)
    }
}

#Preview {
    NewRecordToastView(recordDate: "25.05.01")
}
