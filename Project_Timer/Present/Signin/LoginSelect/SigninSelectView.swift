//
//  SigninSelectView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/09/24.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI

struct SigninSelectView: View {
    @EnvironmentObject var environment: SigninSignupEnvironment
    @StateObject private var model = SigninSelectModel()
    
    init() {
        //Use this if NavigationBarTitle is with displayMode = .inline
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        NavigationStack(path: $environment.navigationPath) {
            GeometryReader { geometry in
                ZStack {
                    Colors.signinBackground.toColor
                        .ignoresSafeArea()
                    
                    VStack(alignment: .center) {
                        Spacer()
                        
                        ContentView(model: model)
                        
                        Spacer()
                    }
                }
                .onChange(of: geometry.size, perform: { value in
                    model.updateContentWidth(size: value)
                })
            }
            .navigationDestination(for: SigninSelectRoute.self) { destination in
                switch destination {
                case .signupEmail:
                    let infos = model.signupInfosForEmail
                    SignupEmailView(
                        model: SignupEmailModel(infos: infos)
                    )
                case .signin:
                    SigninView()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("")
            .alert(model.errorMessage.title, isPresented: $model.showAleret) {
                Button(role: .none) {
                    print("close alert")
                } label: {
                    Text(Localized.string(.ok))
                }
            } message: {
                Text(model.errorMessage.text)
            }
        }
        .accentColor(UIColor.label.toColor)
    }
    
    struct ContentView: View {
        @ObservedObject var model: SigninSelectModel
        
        var body: some View {
            VStack(alignment: .center, spacing: 0) {
                Image(uiImage: TiTiImage.signinLogo)
                
                Spacer()
                    .frame(height: 8)
                
                Text(verbatim: "TimerTiTi")
                    .foregroundStyle(.black)
                    .font(Fonts.HGGGothicssiP80g(size: 15))
                
                Spacer()
                    .frame(height: 58)
                
                Text("#\(Localized.string(.SignIn_Text_TimerTiTi))")
                    .foregroundStyle(.black)
                    .font(Typographys.font(.bold_5, size: 33))
                
                Spacer()
                    .frame(height: 58)
                
                ButtonsView(model: model)
            }
            .frame(width: model.contentWidth)
        }
    }
    
    struct ButtonsView: View {
        @EnvironmentObject var environment: SigninSignupEnvironment
        @ObservedObject var model: SigninSelectModel
        
        var body: some View {
            VStack(alignment: .center, spacing: 24) {
                AppleSigninButton {
                    model.performAppleSignIn()
                }
                GoogleSigninButton {
                    model.performGoogleSignIn(rootVC: environment.rootVC)
                }
                EmailSigninButton {
                    environment.navigationPath.append(SigninSelectRoute.signin)
                }
                Button {
                    environment.dismiss = true
                } label: {
                    Text(Localized.string(.SignIn_Button_WithoutSocialSingIn))
                        .font(Typographys.font(.semibold_4, size: 13))
                        .underline()
                        .foregroundColor(.black.opacity(0.5))
                        .padding(.all, 8)
                }
                .onReceive(model.$venderInfo) { venderInfo in
                    guard venderInfo != nil else { return }
                    environment.navigationPath.append(SigninSelectRoute.signupEmail)
                }
            }
        }
    }
}

struct SigninSelectView_Previews: PreviewProvider {
    static var previews: some View {
        SigninSelectView().environmentObject(SigninSignupEnvironment())
            .environment(\.locale, .init(identifier: "en"))
    }
}
