//
//  SignupNicknameView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/09/24.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI

struct SignupNicknameView: View {
    @EnvironmentObject var listener: LoginSignupEventListener
    @Binding var navigationPath: [LoginSignupRoute]
    
    var body: some View {
        Text("SignupNicknameView")
    }
}

struct SignupNicknameView_Previews: PreviewProvider {
    @State static private var navigationPath: [LoginSignupRoute] = []
    
    static var previews: some View {
        SignupNicknameView(navigationPath: $navigationPath)
    }
}
