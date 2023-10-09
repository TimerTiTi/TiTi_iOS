//
//  LoginView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/09/24.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var listener: LoginSignupEventListener
    @Binding var navigationPath: [LoginSignupRoute]
    @State private var superViewSize: CGSize = .zero
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            GeometryReader { geometry in
                ZStack {
                    TiTiColor.loginBackground?.toColor
                        .ignoresSafeArea()
                    
                    VStack(alignment: .center) {
                        Spacer()
                        
                        ContentView(navigationPath: $navigationPath, superViewSize: $superViewSize)
                        
                        Spacer()
                    }
                }
                .onChange(of: geometry.size, perform: { value in
                    self.superViewSize = value
                })
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
    }
    
    struct ContentView: View {
        @Binding var navigationPath: [LoginSignupRoute]
        @Binding var superViewSize: CGSize
        
        var body: some View {
            VStack(alignment: .center, spacing: 0) {
                Image(uiImage: TiTiImage.loginLogo)
                
                Spacer()
                    .frame(height: 8)
                
                Text(verbatim: "TimerTiTi")
                    .foregroundStyle(.black)
                    .font(TiTiFont.HGGGothicssiP80g(size: 15))
                
                Spacer()
                    .frame(height: 58)
                
                Text("#\("TimerTiTi".localized())")
                    .foregroundStyle(.black)
                    .font(TiTiFont.HGGGothicssiP80g(size: 33))
                
                Spacer()
                    .frame(height: 58)
                
                TextFieldsView(navigationPath: $navigationPath)
                
                Spacer()
                    .frame(height: 16)
            }
            .frame(width: self.width)
        }
        
        // 화면크기에 따른 width 크기조정
        var width: CGFloat {
            let size = superViewSize
            switch size.deviceDetailType {
            case .iPhoneMini:
                return 300
            case .iPhonePro, .iPhoneMax:
                return size.minLength - 96
            default:
                return 400
            }
        }
    }
    
    struct TextFieldsView: View {
        @EnvironmentObject var listener: LoginSignupEventListener
        @Binding var navigationPath: [LoginSignupRoute]
        @State var email: String = ""
        @State var password: String = ""
        @State var postable: Bool = false
        
        var body: some View {
            VStack(alignment: .center, spacing: 24) {
                LoginTextFieldView(type: .email, text: $email)
                
                LoginTextFieldView(type: .password, text: $password)
                
                Button {
                    print("login")
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.white)
                            .shadow(color: .gray.opacity(0.1), radius: 4, x: 1, y: 2)
                            .frame(maxWidth: .infinity)
                            .frame(height: 58)
                        
                        Text("Log in")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.gray)
                    }
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    @State static private var navigationPath: [LoginSignupRoute] = []
    
    static var previews: some View {
        LoginView(navigationPath: $navigationPath).environmentObject(LoginSignupEventListener())
    }
}
