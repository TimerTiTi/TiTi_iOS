//
//  SignupEmailView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/10/18.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI

struct SignupEmailView: View {
    @ObservedObject private var keyboard = KeyboardResponder()
    @StateObject private var model: SignupEmailModel
    
    init(model: SignupEmailModel) {
        _model = StateObject(wrappedValue: model)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                TiTiColor.firstBackground.toColor
                    .ignoresSafeArea()
                
                ContentView(model: model)
                    .onAppear {
                        keyboard.addObserver()
                    }
                    .onDisappear {
                        keyboard.removeObserver()
                    }
                    .padding(.bottom, keyboard.keyboardHeight)
            }
            .onChange(of: geometry.size, perform: { value in
                model.updateContentWidth(size: value)
            })
            .navigationDestination(for: SignupEmailRoute.self) { destination in
                switch destination {
                case .signupPassword:
                    let emailInfo = model.emailInfo
                    VStack {
                        Text("Signup Password")
                        Text(emailInfo.email)
                        Text(emailInfo.verificationKey)
                    }
                }
            }
        }
        .configureForTextFieldRootView()
    }
    
    struct ContentView: View {
        @EnvironmentObject var environment: LoginSignupEnvironment
        @ObservedObject var model: SignupEmailModel
        @FocusState var focus: SignupTextFieldView.type?
        
        var body: some View {
            ZStack {
                ScrollViewReader { scrollViewProxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            SignupTitleView(title: "Enter your email address", subTitle: "Please enter your email address for verification")
                            
                            SignupTextFieldView(type: .email, text: $model.email, focus: $focus) {
                                model.emailCheck()
                                focusCheckAfterEmail()
                            }
                            .id(SignupTextFieldView.type.email)
                            .onChange(of: model.email) { newValue in
                                model.wrongEmail = nil
                            }
                            
                            SignupTextFieldUnderlineView(color: model.emailTintColor)
                            SignupTextFieldWarning(warning: "The format is incorrect. Please enter in the correct format", visible: model.wrongEmail == true)
                            
                            if model.wrongEmail == false {
                                NextContentView(model: model, focus: $focus, focusCheckAfterAuthCode: focusCheckAfterAuthCode)
                            }
                        }
                        .onAppear {
                            if model.wrongAuthCode == nil {
                                focus = .email
                            }
                        }
                        .onChange(of: focus) { newValue in
                            model.updateFocus(to: focus)
                            #if targetEnvironment(macCatalyst)
                            #else
                            scrollViewProxy.scrollTo(newValue, anchor: .top)
                            #endif
                        }
                        .onReceive(model.$getVerificationSuccess) { success in
                            guard success else { return }
                            environment.navigationPath.append(SignupEmailRoute.signupPassword)
                        }
                    }
                    .scrollIndicators(.hidden)
                }
                
                #if targetEnvironment(macCatalyst)
                VStack {
                    Spacer()
                        .frame(maxHeight: .infinity)
                    
                    SignupNextButtonForMac(visible: focus != nil) {
                        switch focus {
                        case .email:
                            model.emailCheck()
                            focusCheckAfterEmail()
                        case .authCode:
                            model.authCodeCheck()
                            focusCheckAfterAuthCode()
                        default:
                            return
                        }
                    }
                    
                    Spacer()
                        .frame(height: 45)
                }
                #endif
            }
            .frame(width: model.contentWidth, alignment: .leading)
        }
        
        func focusCheckAfterEmail() {
            if model.wrongEmail == true {
                focus = .email
            } 
        }
        
        func focusCheckAfterAuthCode() {
            if model.wrongAuthCode == true {
                focus = .authCode
            }
        }
    }
    
    struct NextContentView: View {
        @ObservedObject var model: SignupEmailModel
        @FocusState.Binding var focus: SignupTextFieldView.type?
        var focusCheckAfterAuthCode: () -> Void
        
        var body: some View {
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 35)
                
                HStack(alignment: .center, spacing: 16) {
                    SignupTextFieldView(type: .authCode, text: $model.authCode, focus: $focus) {
                        model.authCodeCheck()
                        focusCheckAfterAuthCode()
                    }
                    .id(SignupTextFieldView.type.authCode)
                    .onChange(of: model.authCode) { newValue in
                        model.wrongAuthCode = nil
                    }
                    .frame(maxWidth: .infinity)
                    
                    // MARK: Timer 구현 필요
                    Text("4 : 59")
                        .font(TiTiFont.HGGGothicssiP40g(size: 18))
                    
                    // MARK: 재전송 구현 필요
                    Button {
                        // MARK: ViewModel 내에서 네트워킹이 필요한 부분
                        print("resend")
                    } label: {
                        Text("resend")
                            .font(TiTiFont.HGGGothicssiP40g(size: 18))
                    }
                }
                .onAppear {
                    if model.wrongAuthCode != false {
                        focus = .authCode
                    }
                }
                
                SignupTextFieldUnderlineView(color: model.authCodeTintColor)
                SignupTextFieldWarning(warning: "The verification code is not valid. Please try again", visible: model.wrongAuthCode == true)
            }
        }
    }
}

struct SignupEmailView_Previews: PreviewProvider {
    static var previews: some View {
        SignupEmailView(model: SignupEmailModel(type: .normal, venderInfo: nil)).environmentObject(LoginSignupEnvironment())
        
        SignupEmailView(model: SignupEmailModel(type: .normal, venderInfo: nil)).environmentObject(LoginSignupEnvironment())
            .environment(\.locale, .init(identifier: "en"))
    }
}
