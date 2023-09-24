//
//  LoginSelectView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/09/24.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI

struct LoginSelectView: View {
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                Spacer()
                
                ContentView()
                
                Spacer()
            }
            .background(TiTiColor.loginBackground?.toColor)
        }
    }
    
    struct ContentView: View {
        var body: some View {
            VStack(alignment: .center, spacing: 0) {
                Image(uiImage: UIImage(named: "loginLogo")!)
                
                Spacer()
                    .frame(height: 8)
                
                Text("TimerTiTi")
                    .font(.custom("HGGGothicssiP80g", size: 15))
                
                Spacer()
                    .frame(height: 58)
                
                Text("#타이머티티")
                    .font(.custom("HGGGothicssiP80g", size: 33))
                
                Spacer()
                    .frame(height: 58)
                
                ButtonsView()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 48)
        }
    }
    
    struct ButtonsView: View {
        var body: some View {
            VStack(alignment: .center, spacing: 24) {
                AppleLoginButton {
                    print("Apple")
                }
                GoogleLoginButton {
                    print("Google")
                }
                EmailLoginButton {
                    print("Email")
                }
                Button {
                    print("without login")
                } label: {
                    Text("로그인없이 서비스 이용하기")
                        .font(.custom("HGGGothicssiP60g", size: 13))
                        .underline()
                        .foregroundColor(.black.opacity(0.5))
                        .padding(.all, 8)
                }
            }
        }
    }

}

#Preview {
    LoginSelectView()
}
