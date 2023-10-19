//
//  SignupEmailView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/10/18.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI

struct SignupEmailView: View {
    @State private var superViewSize: CGSize = .zero
    @ObservedObject private var keyboard = KeyboardResponder()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                TiTiColor.firstBackground.toColor
                    .ignoresSafeArea()
                
                ContentView(superViewSize: $superViewSize)
                    .onAppear {
                        keyboard.addObserver()
                    }
                    .onDisappear {
                        keyboard.removeObserver()
                    }
                    .padding(.bottom, keyboard.keyboardHeight)
            }
            .onChange(of: geometry.size, perform: { value in
                self.superViewSize = value
            })
        }
        .onTapGesture {
            hideKeyboard()
        }
        .navigationTitle("")
        .ignoresSafeArea(.keyboard)
    }
    
    struct ContentView: View {
        @EnvironmentObject var environment: LoginSignupEnvironment
        @Binding var superViewSize: CGSize
        @FocusState var focus: SignupTextFieldView.type?
        @State var email: String = ""
        @State var authCode: String = ""
        @State var wrongEmail: Bool?
        @State var wrongAuthCode: Bool?
        
        var body: some View {
            ZStack {
                ScrollViewReader { scrollViewProxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            Spacer()
                                .frame(height: 29)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("이메일을 입력해 주세요")
                                    .font(TiTiFont.HGGGothicssiP80g(size: 22))
                                Text("인증받기 위한 이메일을 입력해 주세요")
                                    .font(TiTiFont.HGGGothicssiP60g(size: 14))
                                    .foregroundStyle(UIColor.secondaryLabel.toColor)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer()
                                .frame(height: 72)
                            
                            SignupTextFieldView(type: .email, text: $email, focus: $focus) {
                                emailCheck()
                            }
                            .id(SignupTextFieldView.type.email)
                            .onChange(of: email) { newValue in
                                wrongEmail = nil
                            }
                            
                            Spacer()
                                .frame(height: 12)
                            
                            Rectangle()
                                .frame(height: 2)
                                .foregroundStyle(emailTintColor)
                            
                            Spacer()
                                .frame(height: 2)
                            
                            Text("잘못된 형식입니다. 올바른 형식으로 입력해 주세요")
                                .font(TiTiFont.HGGGothicssiP40g(size: 12))
                                .foregroundStyle(TiTiColor.wrongTextField.toColor)
                                .opacity(wrongEmail == true ? 1.0 : 0)
                            
                            if wrongEmail == false {
                                Spacer()
                                    .frame(height: 35)
                                
                                HStack(alignment: .center, spacing: 16) {
                                    SignupTextFieldView(type: .authCode, text: $authCode, focus: $focus) {
                                        authCodeCheck()
                                    }
                                    .id(SignupTextFieldView.type.authCode)
                                    .onChange(of: authCode) { newValue in
                                        wrongAuthCode = nil
                                    }
                                    .frame(maxWidth: .infinity)
                                    
                                    Text("4 : 59")
                                        .font(TiTiFont.HGGGothicssiP40g(size: 18))
                                    
                                    Button {
                                        print("재전송")
                                    } label: {
                                        Text("재전송")
                                            .font(TiTiFont.HGGGothicssiP40g(size: 18))
                                    }
                                }
                                
                                Spacer()
                                    .frame(height: 12)
                                
                                Rectangle()
                                    .frame(height: 2)
                                    .foregroundStyle(authCodeTintColor)
                                
                                Spacer()
                                    .frame(height: 2)
                                
                                Text("인증코드가 올바르지 않습니다. 다시 입력해 주세요")
                                    .font(TiTiFont.HGGGothicssiP40g(size: 12))
                                    .foregroundStyle(TiTiColor.wrongTextField.toColor)
                                    .opacity(wrongAuthCode == true ? 1.0 : 0)
                            }
                        }
                        .onAppear {
                            focus = .email
                        }
                        
                        .onChange(of: focus) { newValue in
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
                    
                    Button {
                        switch focus {
                        case .email:
                            emailCheck()
                        case .authCode:
                            authCodeCheck()
                        default:
                            return
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .foregroundColor(.blue)
                                .shadow(color: .gray.opacity(0.1), radius: 4, x: 1, y: 2)
                                .frame(height: 60)
                            
                            Text("Next")
                                .font(TiTiFont.HGGGothicssiP60g(size: 20))
                        }
                    }
                    .opacity(focus != nil ? 1.0 : 0)
                    
                    Spacer()
                        .frame(height: 45)
                }
                #endif
            }
            .frame(width: abs(self.width), alignment: .leading)
        }
        
        // 화면크기에 따른 width 크기조정
        var width: CGFloat {
            let size = superViewSize
            switch size.deviceDetailType {
            case .iPhoneMini, .iPhonePro, .iPhoneMax:
                return size.minLength - 48
            default:
                return 400
            }
        }
        
        // emailTextField underline 컬러
        var emailTintColor: Color {
            if wrongEmail == true {
                return TiTiColor.wrongTextField.toColor
            } else if focus == .email {
                return Color.blue
            } else {
                return UIColor.placeholderText.toColor
            }
        }
        
        var authCodeTintColor: Color {
            if wrongAuthCode == true {
                return TiTiColor.wrongTextField.toColor
            } else if focus == .authCode {
                return Color.blue
            } else {
                return UIColor.placeholderText.toColor
            }
        }
        
        // 이메일 done 액션
        func emailCheck() {
            let emailValid = PredicateChecker.isValidEmail(email)
            self.wrongEmail = !emailValid
            
            if emailValid {
                focus = .authCode
            } else {
                focus = .email
            }
        }
        
        // 인증코드 done 액션
        func authCodeCheck() {
            let authCodeValid = authCode.count > 7
            self.wrongAuthCode = !authCodeValid
            
            if authCodeValid {
                print("next step")
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
