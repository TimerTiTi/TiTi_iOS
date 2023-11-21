//
//  SignupNicknameView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/11/21.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI

struct SignupNicknameView: View {
    @StateObject private var model: SignupNicknameModel
    
    init(model: SignupNicknameModel) {
        _model = StateObject(wrappedValue: model)
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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
        .environmentObject(LoginSignupEnvironment())
        
        SignupNicknameView(
            model: SignupNicknameModel(infos: infos))
        .environmentObject(LoginSignupEnvironment())
        .environment(\.locale, .init(identifier: "en"))
    }
}
