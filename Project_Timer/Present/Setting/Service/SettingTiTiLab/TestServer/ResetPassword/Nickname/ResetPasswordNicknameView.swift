//
//  ResetPasswordNicknameView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/03/16.
//  Copyright © 2024 FDEE. All rights reserved.
//

import SwiftUI

struct ResetPasswordNicknameView: View {
    @ObservedObject private var keyboard = KeyboardResponder.shared
    @StateObject private var model: ResetPasswordNicknameModel
    @EnvironmentObject var environment: ResetPasswordEnvironment
    
    init(model: ResetPasswordNicknameModel) {
        _model = StateObject(wrappedValue: model)
    }
    
    var body: some View {
        NavigationStack(path: $environment.navigationPath) {
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
            }
            .navigationDestination(for: ResetPasswordNicknameRoute.self) { destination in
                switch destination {
                case .resetPasswordEmail:
                    let authUseCase = self.model.authUseCase
                    let infos = model.resetPasswordInfosForEmail
                    let viewModel = ResetPasswordEmailModel(
                        authUseCase: authUseCase,
                        infos: infos
                    )
                    ResetPasswordEmailView(model: viewModel)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("")
            .configureForTextFieldRootView()
        }
        .accentColor(UIColor.label.toColor)
    }
    
    struct ContentView: View {
        @EnvironmentObject var environment: ResetPasswordEnvironment
        @ObservedObject var model: ResetPasswordNicknameModel
        @FocusState private var focus: TTSignupTextFieldView.type?
        
        var body: some View {
            ZStack {
                ScrollViewReader { ScrollViewProxy in
                    ScrollView {
                        HStack {
                            Spacer()
                            VStack {
                                TTSignupTitleView(title: "비밀번호 찾기", subTitle: "기존 계정의 닉네임을 입력해 주세요") // TODO: TLR 반영
                                
                                TTSignupTextFieldView(type: .nickname, keyboardType: .alphabet, text: $model.nickname, focus: $focus) {
                                    self.model.checkNickname()
                                }
                                .onChange(of: self.model.nickname) { newValue in
                                    self.model.validNickname = nil
                                }
                                TTSignupTextFieldUnderlineView(color: self.model.nicknameTintColor)
                                TTSignupTextFieldWarning(warning: model.errorMessage?.message ?? "", visible: self.model.nicknameWarningVisible)
                                    .id(TTSignupTextFieldView.type.nickname)
                            }
                            .onAppear { // @FocusState 변화 반영
                                if self.model.validNickname == nil && self.model.nickname.isEmpty {
                                    self.focus = .nickname
                                }
                            }
                            .onChange(of: focus, perform: { value in
                                self.model.updateFocus(to: value)
                                self.scroll(ScrollViewProxy, to: value)
                            })
                            .onReceive(model.$validNickname, perform: { valid in
                                if valid == true {
                                    self.environment.navigationPath.append(ResetPasswordNicknameRoute.resetPasswordEmail)
                                } else {
                                    self.focus = .nickname
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

struct ResetPasswordNicknameView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordNicknameView(
            model: ResetPasswordNicknameModel(authUseCase: AuthUseCase(repository: AuthRepository())))
        .environmentObject(ResetPasswordEnvironment())
        
        ResetPasswordNicknameView(
            model: ResetPasswordNicknameModel(authUseCase: AuthUseCase(repository: AuthRepository())))
        .environmentObject(ResetPasswordEnvironment())
        .environment(\.locale, .init(identifier: "en"))
    }
}
