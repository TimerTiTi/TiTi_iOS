//
//  SignupEmailView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/10/18.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI

struct SignupEmailView: View {
    @EnvironmentObject var listener: LoginSignupEventListener
    @Binding var navigationPath: NavigationPath
    @State private var superViewSize: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                TiTiColor.firstBackground.toColor
                    .ignoresSafeArea()
                
                ContentView(navigationPath: $navigationPath, superViewSize: $superViewSize)
            }
            .onChange(of: geometry.size, perform: { value in
                self.superViewSize = value
            })
        }
        .navigationTitle("")
        .ignoresSafeArea(.keyboard)
    }
    
    struct ContentView: View {
        @Binding var navigationPath: NavigationPath
        @Binding var superViewSize: CGSize
        @FocusState var focus: SignupTextFieldView.type?
        @State var email: String = ""
        @State var wrongEmail: Bool = false
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                    .frame(height: 29)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("이메일을 입력해주세요")
                        .font(TiTiFont.HGGGothicssiP80g(size: 22))
                    Text("인증받기 위한 이메일을 입력해주세요")
                        .font(TiTiFont.HGGGothicssiP60g(size: 14))
                        .foregroundStyle(UIColor.secondaryLabel.toColor)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                    .frame(height: 72)
                
                SignupTextFieldView(type: .email, text: $email, focus: $focus) {
                    emailCheck()
                }
                .onChange(of: email) { newValue in
                    wrongEmail = false
                }
                
                Spacer()
                    .frame(height: 12)
                
                Rectangle()
                    .frame(height: 2)
                    .foregroundStyle(emailTintColor)
                
                Spacer()
                    .frame(height: 2)
                
                Text("잘못된 형식입니다. 올바른 형식으로 입력해 주세요")
                    .font(TiTiFont.HGGGothicssiP40g(size: 12))
                    .foregroundStyle(TiTiColor.wrongTextField.toColor)
                    .opacity(wrongEmail ? 1.0 : 0)
                
                Spacer()
            }
            .onAppear {
                focus = .email
            }
            .frame(width: abs(self.width), alignment: .leading)
        }
        
        // 화면크기에 따른 width 크기조정
        var width: CGFloat {
            let size = superViewSize
            switch size.deviceDetailType {
            case .iPhoneMini, .iPhonePro, .iPhoneMax:
                return size.minLength - 48
            default:
                return 400
            }
        }
        
        // 정규식 체크
        func emailCheck() {
            let emailValid = PredicateChecker.isValidEmail(email)
            self.wrongEmail = !emailValid
            
            if emailValid {
                // next step
                print("next step")
                focus = nil
            } else {
                focus = .email
            }
        }
        
        var emailTintColor: Color {
            if wrongEmail {
                return TiTiColor.wrongTextField.toColor
            } else if focus == .email {
                return Color.blue
            } else {
                return UIColor.placeholderText.toColor
            }
        }
    }
}

struct SignupEmailView_Previews: PreviewProvider {
    @State static private var navigationPath = NavigationPath()
    
    static var previews: some View {
        SignupEmailView(navigationPath: $navigationPath).environmentObject(LoginSignupEventListener())
        
        SignupEmailView(navigationPath: $navigationPath).environmentObject(LoginSignupEventListener())
            .environment(\.locale, .init(identifier: "en"))
    }
}
