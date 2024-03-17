//
//  ResetPasswordView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/03/16.
//  Copyright © 2024 FDEE. All rights reserved.
//

import SwiftUI

struct ResetPasswordView: View {
    @ObservedObject private var keyboard = KeyboardResponder.shared
    @StateObject private var model: ResetPasswordModel
    
    init(model: ResetPasswordModel) {
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
            .navigationDestination(for: ResetPasswordRoute.self) { destination in
                switch destination {
                case .resetPasswordComplete:
                    Text("변경이 완료되었어요!")
                }
            }
        }
        .configureForTextFieldRootView()
    }
    
    struct ContentView: View {
        @EnvironmentObject var environment: ResetPasswordEnvironment
        @ObservedObject var model: ResetPasswordModel
        @FocusState private var focus: TTSignupTextFieldView.type?
        
        var body: some View {
            ZStack {
                ScrollViewReader { scrollViewProxy in
                    ScrollView {
                        HStack {
                            Spacer()
                            VStack(alignment: .leading, spacing: 0) {
                                TTSignupTitleView(title: "새로운 비밀번호를 입력해 주세요", subTitle: Localized.string(.SignUp_Text_InputPasswordDesc)) // TODO: TLR 반영
                                
                                TTSignupSecureFieldView(type: .password, keyboardType: .alphabet, text: $model.password, focus: $focus) {
                                    self.model.checkPassword()
                                }
                                TTSignupTextFieldUnderlineView(color: self.model.passwordTintColor)
                                TTSignupTextFieldWarning(warning: Localized.string(.SignUp_Error_PasswordFormat), visible: self.model.passwordWarningVisible)
                                    .id(TTSignupTextFieldView.type.password)
                                
                                if self.model.stage == .password2 {
                                    NextContentView(model: self.model, focus: $focus)
                                }
                            }
                            .onAppear {
                                if self.model.stage == .password {
                                    self.focus = .password
                                }
                            }
                            .onChange(of: self.focus) { newValue in // @FocusState 변화 -> stage 반영
                                self.model.updateFocus(to: newValue)
                                self.scroll(scrollViewProxy, to: newValue)
                            }
                            .onReceive(self.model.$stage) { status in // stage 변화 -> @FocusState 반영
                                switch status {
                                case .password:
                                    self.focus = .password
                                case .password2:
                                    self.focus = .password2
                                }
                                self.scroll(scrollViewProxy, to: focus)
                            }
                            .onReceive(model.$validPassword2) { valid in
                                if valid == true {
                                    self.environment.navigationPath.append(ResetPasswordRoute.resetPasswordComplete)
                                }
                            }
                            .frame(width: self.model.contentWidth)
                            Spacer()
                        }
                    }
                    .scrollIndicators(.hidden)
                }
            }
        }
    }
    
    struct NextContentView: View {
        @ObservedObject var model: ResetPasswordModel
        @FocusState.Binding var focus: TTSignupTextFieldView.type?
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                    .frame(height: 35)
                Text(Localized.string(.SignUp_Text_ConfirmPasswordDesc))
                    .font(Typographys.font(.semibold_4, size: 14))
                    .foregroundStyle(Color.primary)
                Spacer()
                    .frame(height: 16)
                
                TTSignupSecureFieldView(type: .password2, keyboardType: .alphabet, text: $model.password2, focus: $focus) {
                    self.model.checkPassword2()
                }
                TTSignupTextFieldUnderlineView(color: self.model.password2TintColor)
                TTSignupTextFieldWarning(warning: self.model.errorMessage?.message ?? "", visible: self.model.password2WarningVisible)
                    .id(TTSignupTextFieldView.type.password2)
            }
        }
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static let infos = SignupInfosForPassword(type: .normal, venderInfo: nil, emailInfo: SignupEmailInfo(email: "freedeveloper97@gmail.com", verificationKey: "abcd1234"))
    
    static var previews: some View {
        ResetPasswordView(
            model: ResetPasswordModel(authUseCase: AuthUseCase(repository: AuthRepository()), infos: ResetPasswordInfosForPassword(nickname: "minsang", email: "freedeveloper97@gmail.com"))
        ).environmentObject(ResetPasswordEnvironment())
    }
}
