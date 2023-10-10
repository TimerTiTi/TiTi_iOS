//
//  LoginView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/09/24.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI
import Combine

struct LoginView: View {
    @EnvironmentObject var listener: LoginSignupEventListener
    @Binding var navigationPath: NavigationPath
    @State private var superViewSize: CGSize = .zero
    
    var body: some View {
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
            .navigationDestination(for: LoginRoute.self) { destination in
                switch destination {
                case .findEmail:
                    Text("findEmail")
                case .findPassword:
                    Text("findPassword")
                case .signup:
                    Text("signup")
                }
            }
        }
    }
    
    struct ContentView: View {
        @Binding var navigationPath: NavigationPath
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
                    .frame(height: 24)

                FooterView(navigationPath: $navigationPath)
                
                Spacer()
                    .frame(height: 30)
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
        @Binding var navigationPath: NavigationPath
        @State var email: String = ""
        @State var password: String = ""
        @State var postable: Bool = false
        @State var loginSuccess: Bool = false
        
        var body: some View {
            VStack(alignment: .center, spacing: 24) {
                LoginTextFieldView(type: .email, text: $email)
                    .onReceive(Just(email), perform: { _ in
                        check()
                    })
                
                LoginTextFieldView(type: .password, text: $password)
                    .onReceive(Just(password), perform: { _ in
                        check()
                    })
                
                Button {
                    loginSuccess = true
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(postable ? Color.accentColor : Color.white)
                            .shadow(color: .gray.opacity(0.1), radius: 4, x: 1, y: 2)
                            .frame(maxWidth: .infinity)
                            .frame(height: 58)
                        
                        Text("Log in")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(postable ? Color.white : Color.gray)
                    }
                }
                .allowsHitTesting(postable)
            }
            .alert("Login Success", isPresented: $loginSuccess) {
                Button {
                    listener.loginSuccess = true
                } label: {
                    Text("OK")
                }
            }
        }
        
        // 정규식 체크
        func check() {
            let emailValid = PredicateChecker.isValidEmail(email)
            let passwordValid = PredicateChecker.isValidPassword(password)
            self.postable = emailValid && passwordValid
        }
    }
    
    struct FooterView: View {
        @Binding var navigationPath: NavigationPath
        
        var body: some View {
            VStack(alignment: .center, spacing: 0) {
                HStack {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.black.opacity(0.5))
                    Text("OR")
                        .font(TiTiFont.HGGGothicssiP60g(size: 13))
                        .foregroundStyle(.black.opacity(0.5))
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.black.opacity(0.5))
                }
                
                Spacer()
                    .frame(height: 16)
                
                ButtonsView(navigationPath: $navigationPath)
            }
        }
    }
    
    struct ButtonsView: View {
        @Binding var navigationPath: NavigationPath

        var body: some View {
            HStack(spacing: 0) {
                Button {
                    navigationPath.append(LoginRoute.findEmail)
                } label: {
                    Text("이메일 찾기")
                        .font(TiTiFont.HGGGothicssiP60g(size: 13))
                        .foregroundStyle(.black.opacity(0.5))
                        .underline()
                        .padding(.vertical, 8)
                }

                Spacer()
                Rectangle()
                    .frame(width: 1, height: 14)
                    .foregroundStyle(.black.opacity(0.5))
                Spacer()

                Button {
                    navigationPath.append(LoginRoute.findPassword)
                } label: {
                    Text("비밀번호 찾기")
                        .font(TiTiFont.HGGGothicssiP60g(size: 13))
                        .foregroundStyle(.black.opacity(0.5))
                        .underline()
                        .padding(.vertical, 8)
                }

                Spacer()
                Rectangle()
                    .frame(width: 1, height: 14)
                    .foregroundStyle(.black.opacity(0.5))
                Spacer()

                Button {
                    navigationPath.append(LoginRoute.signup)
                } label: {
                    Text("회원가입")
                        .font(TiTiFont.HGGGothicssiP60g(size: 13))
                        .foregroundStyle(.black.opacity(0.5))
                        .underline()
                        .padding(.vertical, 8)
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    @State static private var navigationPath = NavigationPath()
    
    static var previews: some View {
        LoginView(navigationPath: $navigationPath).environmentObject(LoginSignupEventListener())
    }
}
