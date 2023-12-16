//
//  EmailSigninButton.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/09/24.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI

struct EmailSigninButton: View {
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack{
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.white)
                    .shadow(color: .gray.opacity(0.1), radius: 4, x: 1, y: 2)
                    .frame(maxWidth: .infinity)
                    .frame(height: 58)
                
                HStack(spacing: 12) {
                    Text("✉️")
                        .font(.system(size: 25))
                    Text(Localized.string(.SignIn_Button_SocialSignIn, op: Localized.string(.SignIn_Hint_Email)))
                        .font(.system(size: 20, weight: .bold, design: .default))
                }
            }
        }
        .foregroundColor(.black)
    }
}
#Preview {
    EmailSigninButton {
        print("Email")
    }
}
#Preview {
    EmailSigninButton {
        print("Email")
    }
    .environment(\.locale, .init(identifier: "en"))
}
