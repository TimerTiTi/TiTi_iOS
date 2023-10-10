//
//  LoginTextFieldView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/10/09.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI

struct LoginTextFieldView: View {
    enum type {
        case email
        case password
    }
    
    let type: type
    @Binding var text: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.white)
                .shadow(color: .gray.opacity(0.1), radius: 4, x: 1, y: 2)
                .frame(maxWidth: .infinity)
                .frame(height: 58)
            
            if self.type != .password {
                TextField("", text: $text)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.black)
                    .placeholder(when: text.isEmpty) {
                        Text(placeholder)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(TiTiColor.placeholderGray.toColor)
                    }
                    .padding(.horizontal, 16)
            } else {
                SecureField("", text: $text)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.black)
                    .placeholder(when: text.isEmpty) {
                        Text(placeholder)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(TiTiColor.placeholderGray.toColor)
                    }
                    .padding(.horizontal, 16)
            }
        }
    }
    
    var placeholder: String {
        switch self.type {
        case .email:
            return "email".localized()
        case .password:
            return "password".localized()
        }
    }
}

struct LoginTextFieldView_Previews: PreviewProvider {
    @State static private var text: String = ""
    
    static var previews: some View {
        LoginTextFieldView(type: .email, text: $text)
    }
}
