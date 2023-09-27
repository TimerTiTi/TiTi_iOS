//
//  LoginSelectView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/09/24.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI

struct LoginSelectView: View {
    @EnvironmentObject var listener: LoginSignupEventListener
    @State private var navigationPath: [LoginSignupRoute] = []
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                TiTiColor.loginBackground?.toColor
                    .ignoresSafeArea()
                
                VStack(alignment: .center) {
                    Spacer()
                    
                    ContentView(navigationPath: $navigationPath)
                    
                    Spacer()
                }
            }
        }
        .navigationDestination(for: LoginSignupRoute.self) { destination in
            switch destination {
            case .nickname:
                SignupNicknameView(navigationPath: $navigationPath)
            case .login:
                LoginView(navigationPath: $navigationPath)
            }
        }
    }
    
    struct ContentView: View {
        @Binding var navigationPath: [LoginSignupRoute]
        
        var body: some View {
            VStack(alignment: .center, spacing: 0) {
                Image(uiImage: TiTiImage.loginLogo)
                
                Spacer()
                    .frame(height: 8)
                
                Text("TimerTiTi")
                    .foregroundStyle(.black)
                    .font(.custom("HGGGothicssiP80g", size: 15))
                
                Spacer()
                    .frame(height: 58)
                
                Text("#타이머티티")
                    .foregroundStyle(.black)
                    .font(.custom("HGGGothicssiP80g", size: 33))
                
                Spacer()
                    .frame(height: 58)
                
                ButtonsView(navigationPath: $navigationPath)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 48)
        }
    }
    
    struct ButtonsView: View {
        @EnvironmentObject var listener: LoginSignupEventListener
        @Binding var navigationPath: [LoginSignupRoute]
        
        var body: some View {
            VStack(alignment: .center, spacing: 24) {
                AppleLoginButton {
                    print("Apple")
                }
                GoogleLoginButton {
                    print("Google")
                }
                EmailLoginButton {
                    navigationPath.append(.login)
                }
                Button {
                    listener.dismiss = true
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

struct LoginSelectView_Previews: PreviewProvider {
    static var previews: some View {
        LoginSelectView()
    }
}
