//
//  TTBottomRoundButtonView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/03/17.
//  Copyright © 2024 FDEE. All rights reserved.
//

import SwiftUI

struct TTBottomRoundButtonView: View {
    let title: String
    let action: () -> Void
    
    init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        VStack {
            Button {
                self.action()
            } label: {
                Text(self.title)
                    .foregroundStyle(UIColor.label.toColor)
                    .font(Typographys.font(.bold_5, size: 20))
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
            }
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Spacer()
                .frame(height: 45)
        }
    }
}

#Preview {
    TTBottomRoundButtonView(title: "로그인하러 갈래요!") {
        print("tap")
    }
}
