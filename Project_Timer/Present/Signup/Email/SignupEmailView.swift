//
//  SignupEmailView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/10/18.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI

struct SignupEmailView: View {
    @ObservedObject private var keyboard = KeyboardResponder.shared
    @StateObject private var model: SignupEmailModel
    
    init(model: SignupEmailModel) {
        _model = StateObject(wrappedValue: model)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Colors.firstBackground.toColor
                    .ignoresSafeArea()
                
                ContentView(model: model)
                    .padding(.bottom, keyboard.keyboardHeight+16)
            }
            .onChange(of: geometry.size, perform: { value in
                model.updateContentWidth(size: value)
            })
            .navigationDestination(for: SignupEmailRoute.self) { destination in
                switch destination {
                case .signupPassword:
                    let infos = model.infosForPassword
                    SignupPasswordView(
                        model: SignupPasswordModel(infos: infos)
                    )
                case .signupNickname:
                    let infos = model.infosForNickname
                    SignupNicknameView(
                        model: SignupNicknameModel(infos: infos)
                    )
                }
            }
        }
        .configureForTextFieldRootView()
    }
    
    struct ContentView: View {
        @EnvironmentObject var environment: SigninSignupEnvironment
        @ObservedObject var model: SignupEmailModel
        @FocusState var focus: TTSignupTextFieldView.type?
        
        var body: some View {
            ZStack {
                ScrollViewReader { scrollViewProxy in
                    ScrollView {
                        HStack {
                            Spacer()
                            VStack(alignment: .leading, spacing: 0) {
                                TTSignupTitleView(title: Localized.string(.SignUp_Text_InputEmailTitle), subTitle: Localized.string(.SignUp_Text_InputEmailDesc))
                                
                                TTSignupTextFieldView(type: .email, keyboardType: .emailAddress, text: $model.email, focus: $focus) {
                                    model.checkEmail()
                                }
                                .onChange(of: model.email) { newValue in
                                    model.validEmail = nil
                                }
                                TTSignupTextFieldUnderlineView(color: model.emailTintColor)
                                TTSignupTextFieldWarning(warning: Localized.string(.SignUp_Error_WrongEmailFormat), visible: model.validEmail == false)
                                    .id(TTSignupTextFieldView.type.email)
                                
                                if model.stage == .verificationCode {
                                    NextContentView(model: model, focus: $focus)
                                }
                            }
                            .onAppear {
                                if model.stage == .email {
                                    focus = .email
                                }
                            }
                            .onChange(of: focus) { newValue in // @FocusState 변화 -> stage 반영
                                model.updateFocus(to: newValue)
                                scroll(scrollViewProxy, to: newValue)
                            }
                            .onReceive(model.$stage, perform: { stage in // stage 변화 -> @FocusState 반영
                                switch stage {
                                case .email:
                                    focus = .email
                                case .verificationCode:
                                    focus = .verificationCode
                                }
                                scroll(scrollViewProxy, to: focus)
                            })
                            .onReceive(model.$getVerificationSuccess) { success in
                                guard success else { return }
                                // MARK: infos.type에 따른 분기처리
                                switch model.infos.type {
                                case .normal:
                                    environment.navigationPath.append(SignupEmailRoute.signupPassword)
                                case .vender, .venderWithEmail:
                                    environment.navigationPath.append(SignupEmailRoute.signupNickname)
                                }
                               
                            }
                            .frame(width: model.contentWidth)
                            Spacer()
                        }
                    }
                    .scrollIndicators(.hidden)
                }
                
                #if targetEnvironment(macCatalyst)
                VStack {
                    Spacer()
                        .frame(maxHeight: .infinity)
                    
                    TTSignupNextButtonForMac(visible: focus != nil) {
                        switch focus {
                        case .email:
                            model.checkEmail()
                            checkFocusAfterEmail()
                        case .authCode:
                            model.checkAuthCode()
                            checkFocusAfterAuthCode()
                        default:
                            return
                        }
                    }
                    
                    Spacer()
                        .frame(height: 45)
                }
                .frame(width: model.contentWidth, alignment: .leading)
                #endif
            }
        }
    }
    
    struct NextContentView: View {
        @ObservedObject var model: SignupEmailModel
        @FocusState.Binding var focus: TTSignupTextFieldView.type?
        
        var body: some View {
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 35)
                
                HStack(alignment: .center, spacing: 16) {
                    TTSignupTextFieldView(type: .verificationCode, keyboardType: .alphabet, text: $model.verificationCode, focus: $focus) {
                        model.checkVerificationCode()
                    }
                    .frame(maxWidth: .infinity)
                    // MARK: Timer 구현 필요
                    Text("4 : 59")
                        .font(Fonts.HGGGothicssiP40g(size: 18))
                    // MARK: 재전송 구현 필요
                    Button {
                        // MARK: ViewModel 내에서 네트워킹이 필요한 부분
                        print("resend")
                    } label: {
                        Text(Localized.string(.SignUp_Button_Resend))
                            .font(Typographys.font(.normal_3, size: 18))
                    }
                }
                
                TTSignupTextFieldUnderlineView(color: model.authCodeTintColor)
                TTSignupTextFieldWarning(warning: Localized.string(.SignUp_Error_WrongCode), visible: model.validVerificationCode == false && model.verificationCode.isEmpty)
                    .id(TTSignupTextFieldView.type.verificationCode)
            }
        }
    }
}

struct SignupEmailView_Previews: PreviewProvider {
    static let infos = SignupInfosForEmail(type: .normal, venderInfo: nil)
    
    static var previews: some View {
        SignupEmailView(
            model: SignupEmailModel(infos: infos)
        ).environmentObject(SigninSignupEnvironment())
    }
}
