//
//  SigninView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/09/24.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI

struct SigninView: View {
    @ObservedObject private var keyboard = KeyboardResponder.shared
    @State private var superViewSize: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                TiTiColor.signinBackground.toColor
                    .ignoresSafeArea()
                
                VStack(alignment: .center) {
                    Spacer()
                    
                    ContentView(superViewSize: $superViewSize)
                    
                    Spacer()
                }
                .offset(y: keyboardOffset(keyboard.keyboardShow))
                .animation(.easeIn(duration: keyboard.keyboardShow || keyboard.keyboardHide ? 0.2 : 0))
            }
            .onChange(of: geometry.size, perform: { value in
                self.superViewSize = value
            })
            .navigationDestination(for: SigninRoute.self) { destination in
                switch destination {
                case .findEmail:
                    Text("findEmail")
                case .findPassword:
                    Text("findPassword")
                case .signup:
                    let infos = SignupInfosForEmail(type: .normal, venderInfo: nil)
                    SignupEmailView(
                        model: SignupEmailModel(infos: infos)
                    )
                }
            }
        }
        .configureForTextFieldRootView()
    }
    
    func keyboardOffset(_ keyboardShow: Bool) -> CGFloat {
        if keyboardShow == false || keyboard.keyboardHeight < 260 {
            return 0
        } else {
            switch superViewSize.deviceDetailType {
            case .iPhoneMini:
                return -100
            case .iPhonePro:
                return -84
            case .iPhoneMax:
                return -54
            case .iPadMini:
                switch UIDevice.current.orientation {
                case .landscapeLeft, .landscapeRight:
                    return -225
                default:
                    return 0
                }
            case .iPad11:
                switch UIDevice.current.orientation {
                case .landscapeLeft, .landscapeRight:
                    return -180
                default:
                    return 0
                }
            case .iPad12:
                switch UIDevice.current.orientation {
                case .landscapeLeft, .landscapeRight:
                    return -155
                default:
                    return 0
                }
            }
        }
    }
    
    struct ContentView: View {
        @Binding var superViewSize: CGSize
        
        var body: some View {
            VStack(alignment: .center, spacing: 0) {
                Image(uiImage: TiTiImage.signinLogo)
                
                Spacer()
                    .frame(height: 8)
                
                Text(verbatim: "TimerTiTi")
                    .foregroundStyle(.black)
                    .font(Fonts.HGGGothicssiP80g(size: 15))
                
                Spacer()
                    .frame(height: 58)
                
                Text("#\(Localized.string(.SignIn_Text_TimerTiTi))")
                    .foregroundStyle(.black)
                    .font(Typographys.font(.bold_5, size: 33))
                
                Spacer()
                    .frame(height: 58)
                
                TextFieldsView()
                
                Spacer()
                    .frame(height: 24)

                FooterView()
                
                Spacer()
                    .frame(height: 14)
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
        @EnvironmentObject var environment: SigninSignupEnvironment
        @FocusState private var focus: SigninTextFieldView.type?
        @State var email: String = ""
        @State var password: String = ""
        @State var postable: Bool = false
        @State var signinSuccess: Bool = false
        
        var body: some View {
            VStack(alignment: .center, spacing: 24) {
                SigninTextFieldView(type: .email, text: $email, focus: $focus)
                    .onChange(of: email, perform: { _ in
                        check()
                    })
                
                SigninTextFieldView(type: .password, text: $password, focus: $focus)
                    .onChange(of: password, perform: { _ in
                        check()
                    })
                
                Button {
                    signinSuccess = true
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(postable ? Color.blue : Color.white)
                            .shadow(color: .gray.opacity(0.1), radius: 4, x: 1, y: 2)
                            .frame(maxWidth: .infinity)
                            .frame(height: 58)
                        
                        Text(Localized.string(.SignIn_Button_TiTiSingIn))
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(postable ? Color.white : Color.gray)
                    }
                }
                .allowsHitTesting(postable)
            }
            .alert("Signin Success", isPresented: $signinSuccess) {
                Button {
                    environment.signinSuccess = true
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
        var body: some View {
            VStack(alignment: .center, spacing: 0) {
                HStack {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.black.opacity(0.5))
                    Text(Localized.string(.SignIn_Text_OR))
                        .font(Typographys.font(.semibold_4, size: 13))
                        .foregroundStyle(.black.opacity(0.5))
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.black.opacity(0.5))
                }
                
                Spacer()
                    .frame(height: 16)
                
                ButtonsView()
            }
        }
    }
    
    struct ButtonsView: View {
        @EnvironmentObject var environment: SigninSignupEnvironment

        var body: some View {
            HStack(spacing: 0) {
                Button {
                    environment.navigationPath.append(SigninRoute.findEmail)
                } label: {
                    Text(Localized.string(.SignIn_Button_FindEmail))
                        .font(Typographys.font(.semibold_4, size: 13))
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
                    environment.navigationPath.append(SigninRoute.findPassword)
                } label: {
                    Text(Localized.string(.SignIn_Button_FindPassword))
                        .font(Typographys.font(.semibold_4, size: 13))
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
                    environment.navigationPath.append(SigninRoute.signup)
                } label: {
                    Text(Localized.string(.SignUp_Button_SignUp))
                        .font(Typographys.font(.semibold_4, size: 13))
                        .foregroundStyle(.black.opacity(0.5))
                        .underline()
                        .padding(.vertical, 8)
                }
            }
        }
    }
}

struct SigninView_Previews: PreviewProvider {
    static var previews: some View {
        SigninView().environmentObject(SigninSignupEnvironment())
    }
}

extension View {
  func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
