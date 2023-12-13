//
//  SignupPasswordView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/10/30.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI

struct SignupPasswordView: View {
    @ObservedObject private var keyboard = KeyboardResponder.shared
    @StateObject private var model: SignupPasswordModel
    
    init(model: SignupPasswordModel) {
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
            .navigationDestination(for: SignupPasswordRoute.self) { destination in
                switch destination {
                case .signupNickname:
                    let infos = self.model.infosForNickname
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
        @ObservedObject var model: SignupPasswordModel
        @FocusState private var focus: SignupTextFieldView.type?
        
        var body: some View {
            ZStack {
                ScrollViewReader { scrollViewProxy in
                    ScrollView {
                        HStack {
                            Spacer()
                            VStack(alignment: .leading, spacing: 0) {
                                SignupTitleView(title: Localized.string(.SignUp_Text_InputPasswordTitle), subTitle: Localized.string(.SignUp_Text_InputPasswordDesc))
                                
                                SignupSecureFieldView(type: .password, keyboardType: .alphabet, text: $model.password, focus: $focus) {
                                    model.checkPassword()
                                }
                                SignupTextFieldUnderlineView(color: model.passwordTintColor)
                                SignupTextFieldWarning(warning: Localized.string(.SignUp_Error_PasswordFormat), visible: model.validPassword == false && model.password.isEmpty)
                                    .id(SignupTextFieldView.type.password)
                                
                                if model.stage == .password2 {
                                    NextContentView(model: model, focus: $focus)
                                }
                            }
                            .onAppear {
                                if model.stage == .password {
                                    focus = .password
                                }
                            }
                            .onChange(of: focus) { newValue in // @FocusState 변화 -> stage 반영
                                model.updateFocus(to: newValue)
                                scroll(scrollViewProxy, to: newValue)
                            }
                            .onReceive(model.$stage) { status in // stage 변화 -> @FocusState 반영
                                switch status {
                                case .password:
                                    focus = .password
                                case .password2:
                                    focus = .password2
                                }
                                scroll(scrollViewProxy, to: focus)
                            }
                            .onReceive(model.$validPassword2) { valid in
                                if valid == true {
                                    environment.navigationPath.append(SignupPasswordRoute.signupNickname)
                                }
                            }
                            .frame(width: model.contentWidth)
                            Spacer()
                        }
                    }
                    .scrollIndicators(.hidden)
                }
            }
        }
    }
    
    struct NextContentView: View {
        @ObservedObject var model: SignupPasswordModel
        @FocusState.Binding var focus: SignupTextFieldView.type?
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                    .frame(height: 35)
                Text(Localized.string(.SignUp_Text_ConfirmPasswordDesc))
                    .font(Typographys.font(.semibold_4, size: 14))
                    .foregroundStyle(Color.primary)
                Spacer()
                    .frame(height: 16)
                
                SignupSecureFieldView(type: .password2, keyboardType: .alphabet, text: $model.password2, focus: $focus) {
                    model.checkPassword2()
                }
                SignupTextFieldUnderlineView(color: model.password2TintColor)
                SignupTextFieldWarning(warning: Localized.string(.SignUp_Error_PasswordMismatch), visible: model.validPassword2 == false && model.password2.isEmpty)
                    .id(SignupTextFieldView.type.password2)
            }
        }
    }
}

struct SignupPasswordView_Previews: PreviewProvider {
    static let infos = SignupInfosForPassword(type: .normal, venderInfo: nil, emailInfo: SignupEmailInfo(email: "freedeveloper97@gmail.com", verificationKey: "abcd1234"))
    
    static var previews: some View {
        SignupPasswordView(
            model: SignupPasswordModel(infos: infos)
        ).environmentObject(SigninSignupEnvironment())
    }
}
