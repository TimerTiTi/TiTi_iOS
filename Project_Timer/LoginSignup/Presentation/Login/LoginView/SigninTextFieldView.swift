//
//  SigninTextFieldView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/10/09.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI

struct SigninTextFieldView: View {
    enum type: Equatable {
        case email
        case password
    }
    
    let type: type
    @Binding var text: String
    @FocusState.Binding var focus: type?
    
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
                    .accentColor(.black)
                    .autocorrectionDisabled(true)
                    .placeholder(when: text.isEmpty) { // placeholder 텍스트 설정
                        Text(placeholder)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(TiTiColor.placeholderGray.toColor)
                    }
                    .keyboardType(self.type == .email ? .emailAddress : .alphabet)
                    .focused($focus, equals: self.type) // textField 활성화값 반영
                    .submitLabel(.done) // 키보드 done 버튼 활성화
                    .onSubmit { // 키보드 done 버튼 액션
                        if self.type == .email {
                            focus = .password
                        }
                    }
                    .padding(.horizontal, 16)
            } else {
                SecureField("", text: $text)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.black)
                    .accentColor(.black)
                    .autocorrectionDisabled(true)
                    .placeholder(when: text.isEmpty) { // placeholder 텍스트 설정
                        Text(placeholder)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(TiTiColor.placeholderGray.toColor)
                    }
                    .keyboardType(.alphabet)
                    .focused($focus, equals: self.type) // textField 활성화값 반영
                    .submitLabel(.done) // 키보드 done 버튼 활성화
                    .onSubmit { // 키보드 done 버튼 액션
                        focus = nil
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

struct SigninTextFieldView_Previews: PreviewProvider {
    @State static private var text: String = ""
    @FocusState static private var focus: SigninTextFieldView.type?
    
    static var previews: some View {
        SigninTextFieldView(type: .email, text: $text, focus: $focus)
    }
}
