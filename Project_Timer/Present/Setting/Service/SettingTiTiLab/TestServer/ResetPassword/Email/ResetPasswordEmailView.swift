//
//  ResetPasswordEmailView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/03/16.
//  Copyright © 2024 FDEE. All rights reserved.
//

import SwiftUI

struct ResetPasswordEmailView: View {
    @ObservedObject private var keyboard = KeyboardResponder.shared
    @StateObject private var model: ResetPasswordEmailModel
    @EnvironmentObject var environment: ResetPasswordEnvironment
    
    init(model: ResetPasswordEmailModel) {
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
            .onChange(of: geometry.size) { newValue in
                model.updateContentWidth(size: newValue)
            }
            .navigationDestination(for: ResetPasswordEmailRoute.self) { destination in
                switch destination {
                case .resetPassword:
                    let authUseCase = self.model.authUseCase
                    let infos = self.model.resetPasswordInfosForPassword
                    let viewModel = ResetPasswordModel(
                        authUseCase: authUseCase,
                        infos: infos
                    )
                    ResetPasswordView(model: viewModel)
                }
            }
        }
        .configureForTextFieldRootView()
    }
    
    struct ContentView: View {
        @EnvironmentObject var environment: ResetPasswordEnvironment
        @ObservedObject var model: ResetPasswordEmailModel
        @FocusState private var focus: TTSignupTextFieldView.type?
        
        var body: some View {
            ZStack {
                ScrollViewReader { ScrollViewProxy in
                    ScrollView {
                        HStack {
                            Spacer()
                            VStack {
                                TTSignupTitleView(title: "비밀번호 찾기", subTitle: "기존 계정의 이메일을 입력해 주세요") // TODO: TLR 반영
                                
                                TTSignupTextFieldView(type: .email, keyboardType: .alphabet, text: $model.email, focus: $focus) {
                                    self.model.checkEmail()
                                }
                                .onChange(of: self.model.email) { newValue in
                                    self.model.validEmail = nil
                                }
                                TTSignupTextFieldUnderlineView(color: self.model.emailTintColor)
                                TTSignupTextFieldWarning(warning: model.errorMessage?.message ?? "", visible: self.model.emailWarningVisible)
                                    .id(TTSignupTextFieldView.type.email)
                            }
                            .onAppear { // @FocusState 변화 반영
                                if self.model.validEmail == nil && self.model.email.isEmpty {
                                    self.focus = .email
                                }
                            }
                            .onChange(of: focus, perform: { value in
                                self.model.updateFocus(to: value)
                                self.scroll(ScrollViewProxy, to: value)
                            })
                            .onReceive(model.$validEmail, perform: { valid in
                                if valid == true {
                                    self.environment.navigationPath.append(ResetPasswordEmailRoute.resetPassword)
                                } else {
                                    self.focus = .email
                                    self.scroll(ScrollViewProxy, to: focus)
                                }
                            })
                            .frame(width: self.model.contentWidth)
                            Spacer()
                        }
                    }
                    .scrollIndicators(.hidden)
                }
            }
        }
    }
}

struct ResetPasswordEmailView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordEmailView(
            model: ResetPasswordEmailModel(authUseCase: AuthUseCase(repository: AuthRepository()), infos: ResetPasswordInfosForEmail(nickname: "minsang")))
        .environmentObject(ResetPasswordEnvironment())
        
        ResetPasswordEmailView(
            model: ResetPasswordEmailModel(authUseCase: AuthUseCase(repository: AuthRepository()), infos: ResetPasswordInfosForEmail(nickname: "minsang")))
        .environmentObject(ResetPasswordEnvironment())
        .environment(\.locale, .init(identifier: "en"))
    }
}
