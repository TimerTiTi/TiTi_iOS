//
//  SignupNicknameView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/11/21.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI

struct SignupNicknameView: View {
    @ObservedObject private var keyboard = KeyboardResponder.shared
    @StateObject private var model: SignupNicknameModel
    
    init(model: SignupNicknameModel) {
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
            .navigationDestination(for: SignupNicknameRoute.self) { destination in
                switch destination {
                case .signupTermOfUse:
                    let infos = model.signupInfosForTermOfUse
                    Text("SignupTermOfUse")
                }
            }
        }
        .configureForTextFieldRootView()
    }
    
    struct ContentView: View {
        @EnvironmentObject var environment: SigninSignupEnvironment
        @ObservedObject var model: SignupNicknameModel
        @FocusState private var focus: SignupTextFieldView.type?
        
        var body: some View {
            ZStack {
                ScrollViewReader { ScrollViewProxy in
                    ScrollView {
                        HStack {
                            Spacer()
                            VStack {
                                SignupTitleView(title: Localized.string(.SignUp_Text_InputNicknameTitle), subTitle: Localized.string(.SignUp_Text_InputNicknameDesc))
                                
                                SignupTextFieldView(type: .nickname, keyboardType: .alphabet, text: $model.nickname, focus: $focus) {
                                    model.checkNickname()
                                }
                                .onChange(of: model.nickname) { newValue in
                                    model.validNickname = nil
                                }
                                SignupTextFieldUnderlineView(color: model.nicknameTintColor)
                                SignupTextFieldWarning(warning: Localized.string(.SignUp_Error_WrongNicknameFormat), visible: model.validNickname == false)
                                    .id(SignupTextFieldView.type.nickname)
                            }
                            .onAppear { // @FocusState 변화 반영
                                if model.validNickname == nil && model.nickname.isEmpty {
                                    focus = .nickname
                                }
                            }
                            .onChange(of: focus, perform: { value in
                                model.updateFocus(to: value)
                                scroll(ScrollViewProxy, to: value)
                            })
                            .onReceive(model.$validNickname, perform: { valid in
                                if valid == true {
                                    environment.navigationPath.append(SignupNicknameRoute.signupTermOfUse)
                                } else {
                                    focus = .nickname
                                    scroll(ScrollViewProxy, to: focus)
                                }
                            })
                            .frame(width: model.contentWidth)
                            Spacer()
                        }
                    }
                    .scrollIndicators(.hidden)
                }
            }
        }
    }
}

struct SignupNicknameView_Previews: PreviewProvider {
    static let infos = SignupInfosForNickname(
        type: .normal,
        venderInfo: nil,
        emailInfo: SignupEmailInfo(
            email: "freedeveloper97@gmail.com",
            verificationKey: "abcd1234"),
        passwordInfo: SignupPasswordInfo(
            password: "Abcd1234!")
    )
    
    static var previews: some View {
        SignupNicknameView(
            model: SignupNicknameModel(infos: infos))
        .environmentObject(SigninSignupEnvironment())
        
        SignupNicknameView(
            model: SignupNicknameModel(infos: infos))
        .environmentObject(SigninSignupEnvironment())
        .environment(\.locale, .init(identifier: "en"))
    }
}
