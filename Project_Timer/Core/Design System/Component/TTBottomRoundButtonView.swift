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
    let radius: CGFloat
    let height: CGFloat
    let action: () -> Void
    
    init(title: String, radius: CGFloat = 8, height: CGFloat = 60, action: @escaping () -> Void) {
        self.title = title
        self.radius = radius
        self.height = height
        self.action = action
    }
    
    var body: some View {
        VStack {
            Button {
                self.action()
            } label: {
                Text(self.title)
                    .foregroundStyle(.white)
                    .font(Fonts.PretendardSemiBold(size: 18))
                    .frame(height: height)
                    .frame(maxWidth: .infinity)
            }
            .background(Color(uiColor: Colors.Primary.value))
            .clipShape(RoundedRectangle(cornerRadius: radius))
        }
    }
}

#Preview {
    TTBottomRoundButtonView(title: "로그인하러 갈래요!") {
        print("tap")
    }
}
