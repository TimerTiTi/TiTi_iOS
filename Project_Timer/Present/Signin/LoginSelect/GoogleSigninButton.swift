//
//  GoogleSigninButton.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/09/24.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI

struct GoogleSigninButton: View {
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
                    Image(uiImage: UIImage(named: "googleLogo")!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 23)
                    Text(Localized.string(.SignIn_Button_SocialSignIn, op: "Google"))
                        .font(.system(size: 20, weight: .bold, design: .default))
                }
            }
        }
        .foregroundColor(.black)
    }
}

#Preview {
    GoogleSigninButton {
        print("Google")
    }
}
#Preview {
    GoogleSigninButton {
        print("Google")
    }
    .environment(\.locale, .init(identifier: "en"))
}
