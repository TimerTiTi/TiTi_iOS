//
//  SignupPasswordView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/10/30.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI

struct SignupPasswordView: View {
    @EnvironmentObject var environment: LoginSignupEnvironment
    @StateObject private var model: SignupPasswordModel
    
    init(model: SignupPasswordModel) {
        _model = StateObject(wrappedValue: model)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                TiTiColor.firstBackground.toColor
                    .ignoresSafeArea()
                
                ContentView(model: model)
            }
            .onChange(of: geometry.size, perform: { value in
                model.updateContentWidth(size: value)
            })
            .navigationDestination(for: SignupPasswordRoute.self) { destination in
                switch destination {
                case .signupNickname:
                    Text("SignupNickName")
                }
            }
        }
        .configureForTextFieldRootView()
    }
    
    struct ContentView: View {
        @EnvironmentObject var environment: LoginSignupEnvironment
        @ObservedObject var model: SignupPasswordModel
        @FocusState private var focus: SignupTextFieldView.type?
        
        var body: some View {
            ZStack {
                ScrollViewReader { scrollViewProxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            SignupTitleView(title: "비밀번호를 입력해주세요", subTitle: "8자리 이상 비밀번호를 입력해주세요")
                            
                            SignupTextFieldView(type: .password, text: $model.password, focus: $focus) {
                                model.checkPassword()
                            }
                            .id(SignupTextFieldView.type.password)
                            .onChange(of: model.password, perform: { value in
                                model.wrongPassword = nil
                            })
                            SignupTextFieldUnderlineView(color: model.passwordTintColor)
                            SignupTextFieldWarning(warning: "영문, 숫자, 또는 10가지 특수문자 내에서 입력해 주세요", visible: model.wrongPassword == true)
                            
                            if model.wrongPassword == false {
                                NextContentView(focus: $focus, model: model, checkFocusAfterPassword2: checkFocusAfterPassword2)
                            }
                        }
                        .onAppear {
                            if model.wrongPassword == nil {
                                focus = .password
                            }
                        }
                        .onChange(of: focus) { newValue in
                            model.updateFocus(to: focus)
                            #if targetEnvironment(macCatalyst)
                            #else
                            scrollViewProxy.scrollTo(newValue, anchor: .top)
                            #endif
                        }
                        .onReceive(model.$passwordSuccess) { success in
                            guard success else { return }
                            environment.navigationPath.append(SignupPasswordRoute.signupNickname)
                        }
                    }
                }
            }
            .frame(width: 393-48)
        }
        
        func checkFocusAfterPassword() {
            if model.wrongPassword == true {
                focus = .password
            }
        }
        
        func checkFocusAfterPassword2() {
            if model.passwordSuccess == false {
                focus = .password2
            }
        }
    }
    
    struct NextContentView: View {
        @FocusState.Binding var focus: SignupTextFieldView.type?
        @ObservedObject var model: SignupPasswordModel
        var checkFocusAfterPassword2: () -> Void
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                    .frame(height: 35)
                Text("다시 한번 입력해 주세요")
                    .font(TiTiFont.HGGGothicssiP60g(size: 14))
                    .foregroundStyle(Color.primary)
                Spacer()
                    .frame(height: 16)
                
                SignupTextFieldView(type: .password2, text: $model.password2, focus: $focus) {
                    model.checkPassword2()
                    checkFocusAfterPassword2()
                }
                .id(SignupTextFieldView.type.password2)
                .onChange(of: model.password2, perform: { value in
                    model.wrongPassword2 = nil
                })
                SignupTextFieldUnderlineView(color: model.password2TintColor)
                SignupTextFieldWarning(warning: "동일하지 않습니다. 다시 입력해 주세요", visible: model.wrongPassword2 == true)
            }
            .onAppear {
                if model.wrongPassword2 != false {
                    focus = .password2
                }
            }
        }
    }
}

struct SignupPasswordView_Previews: PreviewProvider {
    static let prevInfos: SignupSelectInfos = (type: .normal, venderInfo: nil)
    static let emailInfo: SignupEmailInfo = SignupEmailInfo(email: "freedeveloper97@gmail.com", verificationKey: "abcd1234")
    
    static var previews: some View {
        SignupPasswordView(model: SignupPasswordModel(infos: (prevInfos: prevInfos, emailInfo: emailInfo))).environmentObject(LoginSignupEnvironment())
    }
}
