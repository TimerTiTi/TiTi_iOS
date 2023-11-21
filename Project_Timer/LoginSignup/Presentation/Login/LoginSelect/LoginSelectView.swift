//
//  LoginSelectView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/09/24.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI

struct LoginSelectView: View {
    @EnvironmentObject var environment: LoginSignupEnvironment
    @StateObject private var model = LoginSelectModel()
    
    init() {
        //Use this if NavigationBarTitle is with displayMode = .inline
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        NavigationStack(path: $environment.navigationPath) {
            GeometryReader { geometry in
                ZStack {
                    TiTiColor.loginBackground.toColor
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
            .navigationDestination(for: LoginSelectRoute.self) { destination in
                switch destination {
                case .signupEmail:
                    let infos = model.signupInfosForEmail
                    SignupEmailView(
                        model: SignupEmailModel(infos: infos)
                    )
                case .login:
                    LoginView()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("")
        }
        .accentColor(UIColor.label.toColor)
    }
    
    struct ContentView: View {
        @ObservedObject var model: LoginSelectModel
        
        var body: some View {
            VStack(alignment: .center, spacing: 0) {
                Image(uiImage: TiTiImage.loginLogo)
                
                Spacer()
                    .frame(height: 8)
                
                Text(verbatim: "TimerTiTi")
                    .foregroundStyle(.black)
                    .font(TiTiFont.HGGGothicssiP80g(size: 15))
                
                Spacer()
                    .frame(height: 58)
                
                Text("#\("TimerTiTi".localized())")
                    .foregroundStyle(.black)
                    .font(TiTiFont.HGGGothicssiP80g(size: 33))
                
                Spacer()
                    .frame(height: 58)
                
                ButtonsView(model: model)
            }
            .frame(width: model.contentWidth)
        }
    }
    
    struct ButtonsView: View {
        @EnvironmentObject var environment: LoginSignupEnvironment
        @ObservedObject var model: LoginSelectModel
        
        var body: some View {
            VStack(alignment: .center, spacing: 24) {
                AppleLoginButton {
                    model.appleLogin()
                }
                GoogleLoginButton {
                    model.googleLogin()
                }
                EmailLoginButton {
                    environment.navigationPath.append(LoginSelectRoute.login)
                }
                Button {
                    environment.dismiss = true
                } label: {
                    Text("Using without Sign in")
                        .font(TiTiFont.HGGGothicssiP60g(size: 13))
                        .underline()
                        .foregroundColor(.black.opacity(0.5))
                        .padding(.all, 8)
                }
                .onReceive(model.$venderInfo) { venderInfo in
                    guard venderInfo != nil else { return }
                    environment.navigationPath.append(LoginSelectRoute.signupEmail)
                }
            }
        }
    }
}

struct LoginSelectView_Previews: PreviewProvider {
    static var previews: some View {
        LoginSelectView().environmentObject(LoginSignupEnvironment())
    }
}
