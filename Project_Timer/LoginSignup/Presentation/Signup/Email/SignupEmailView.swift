//
//  SignupEmailView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/10/18.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI

struct SignupEmailView: View {
    @StateObject private var model = SignupEmailModel()
    @ObservedObject private var keyboard = KeyboardResponder()
    
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
                    Text("Signup Password")
                }
            }
        }
        .configureForTextFieldRootView()
    }
    
    struct ContentView: View {
        @EnvironmentObject var environment: LoginSignupEnvironment
        @EnvironmentObject var signupInfo: SignupInfo
        @ObservedObject var model: SignupEmailModel
        @FocusState var focus: SignupTextFieldView.type?
        
        var body: some View {
            ZStack {
                ScrollViewReader { scrollViewProxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            SignupTitleView(title: "Enter your email address", subTitle: "Please enter your email address for verification")
                            
                            SignupTextFieldView(type: .email, text: $signupInfo.email, focus: $focus) {
                                model.emailCheck(signupInfo.email)
                                focusCheckAfterEmail()
                            }
                            .id(SignupTextFieldView.type.email)
                            .onChange(of: signupInfo.email) { newValue in
                                model.wrongEmail = nil
                            }
                            
                            SignupTextFieldUnderlineView(color: model.emailTintColor)
                            SignupTextFieldWarning(warning: "The format is incorrect. Please enter in the correct format", visible: model.wrongEmail == true)
                            
                            if model.wrongEmail == false {
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
                                
                                SignupTextFieldUnderlineView(color: model.authCodeTintColor)
                                SignupTextFieldWarning(warning: "The verification code is not valid. Please try again", visible: model.wrongAuthCode == true)
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
                            emailCheck()
                        case .authCode:
                            authCodeCheck()
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
            if model.wrongEmail == false {
                focus = .authCode
            } else {
                focus = .email
            }
        }
        
        func focusCheckAfterAuthCode() {
            if model.wrongAuthCode == false {
                signupInfo.setVerificationKey(to: "1234ABCD")
                environment.navigationPath.append(SignupEmailRoute.signupPassword)
            } else {
                focus = .authCode
            }
        }
    }
}

struct SignupEmailView_Previews: PreviewProvider {
    @State static private var navigationPath = NavigationPath()
    
    static var previews: some View {
        SignupEmailView().environmentObject(LoginSignupEnvironment())
        
        SignupEmailView().environmentObject(LoginSignupEnvironment())
            .environment(\.locale, .init(identifier: "en"))
    }
}
