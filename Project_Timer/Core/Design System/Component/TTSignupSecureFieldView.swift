//
//  TTSignupSecureFieldView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/10/31.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI

struct TTSignupSecureFieldView: View {
    let type: TTSignupTextFieldView.type
    let keyboardType: UIKeyboardType
    @Binding var text: String
    @FocusState.Binding var focus: TTSignupTextFieldView.type?
    let submitAction: () -> Void
    
    @State private var isSecure: Bool = true
    
    var body: some View {
        ZStack {
            TextField("", text: $text)
                .font(Typographys.font(.semibold_4, size: 20))
                .foregroundStyle(.primary)
                .accentColor(.blue)
                .autocorrectionDisabled(true)
                .placeholder(when: text.isEmpty) { // placeholder 텍스트 설정
                    Text(placeholder)
                        .font(Typographys.font(.semibold_4, size: 20))
                        .foregroundStyle(UIColor.placeholderText.toColor)
                }
                .keyboardType(keyboardType)
                .focused($focus, equals: self.type) // textField 활성화값 반영
                .submitLabel(.done) // 키보드 done 버튼 활성화
                .onSubmit { // 키보드 done 버튼 액션
                    submitAction()
                }
                .frame(height: 22)
                .overlayShowButtonForSecureFieldView(isVisible: (focus == self.type && !text.isEmpty), isSecure: isSecure, action: {
                    isSecure.toggle()
                })
                .opacity(isSecure ? 0 : 1)
            
            SecureField("", text: $text)
                .font(Typographys.font(.semibold_4, size: 20))
                .foregroundStyle(.primary)
                .accentColor(.blue)
                .autocorrectionDisabled(true)
                .placeholder(when: text.isEmpty) { // placeholder 텍스트 설정
                    Text(placeholder)
                        .font(Typographys.font(.semibold_4, size: 20))
                        .foregroundStyle(UIColor.placeholderText.toColor)
                }
                .keyboardType(keyboardType)
                .focused($focus, equals: self.type) // textField 활성화값 반영
                .submitLabel(.done) // 키보드 done 버튼 활성화
                .onSubmit { // 키보드 done 버튼 액션
                    submitAction()
                }
                .frame(height: 22)
                .overlayShowButtonForSecureFieldView(isVisible: (focus == self.type && !text.isEmpty), isSecure: isSecure, action: {
                    isSecure.toggle()
                })
                .opacity(isSecure ? 1 : 0)
        }
        .onChange(of: focus) { newValue in
            if newValue == nil {
                isSecure = true
            }
        }
    }
    
    var placeholder: String {
        switch self.type {
        case .password:
            return Localized.string(.SignUp_Hint_Password)
        case .password2:
            return Localized.string(.SignUp_Hint_ConfirmPassword)
        default:
            return "placeholder"
        }
    }
}

struct SignupSecureFieldView_Previews: PreviewProvider {
    @State static private var text: String = ""
    @FocusState static private var focus: TTSignupTextFieldView.type?
    
    static var previews: some View {
        TTSignupSecureFieldView(type: .password, keyboardType: .alphabet, text: $text, focus: $focus) {
            print("submit")
        }
    }
}
