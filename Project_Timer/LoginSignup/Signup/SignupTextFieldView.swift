//
//  LoginTextFieldView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/10/09.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI

struct SignupTextFieldView: View {
    enum type: Equatable {
        case email
        case authCode
        case password
        case password2
        case nickname
    }
    
    let type: type
    @Binding var text: String
    @FocusState.Binding var focus: type?
    let submitAction: () -> Void
    
    var body: some View {
        if self.type != .password {
            TextField("", text: $text)
                .font(TiTiFont.HGGGothicssiP60g(size: 20))
                .foregroundStyle(.primary)
                .accentColor(.blue)
                .autocorrectionDisabled(true)
                .placeholder(when: text.isEmpty) { // placeholder 텍스트 설정
                    Text(placeholder)
                        .font(TiTiFont.HGGGothicssiP60g(size: 20))
                        .foregroundStyle(UIColor.placeholderText.toColor)
                }
                .keyboardType(self.keyboardType)
                .focused($focus, equals: self.type) // textField 활성화값 반영
                .submitLabel(.done) // 키보드 done 버튼 활성화
                .onSubmit { // 키보드 done 버튼 액션
                    submitAction()
                }
                .frame(height: 22)
                .overlay {
                    if focus == self.type && !text.isEmpty {
                        HStack {
                            Spacer()
                            Button {
                                text = ""
                            } label: {
                                Image(systemName: "multiply.circle.fill")
                            }
                            .foregroundColor(.secondary)
                        }
                    }
                }
        } else {
            SecureField("", text: $text)
                .font(TiTiFont.HGGGothicssiP60g(size: 20))
                .foregroundStyle(.primary)
                .accentColor(.blue)
                .autocorrectionDisabled(true)
                .placeholder(when: text.isEmpty) { // placeholder 텍스트 설정
                    Text(placeholder)
                        .font(TiTiFont.HGGGothicssiP60g(size: 20))
                        .foregroundStyle(UIColor.placeholderText.toColor)
                }
                .keyboardType(self.keyboardType)
                .focused($focus, equals: self.type) // textField 활성화값 반영
                .submitLabel(.done) // 키보드 done 버튼 활성화
                .onSubmit { // 키보드 done 버튼 액션
                    submitAction()
                }
                .frame(height: 22)
                .overlay {
                    if focus == self.type && !text.isEmpty {
                        HStack {
                            Spacer()
                            Button {
                                text = ""
                            } label: {
                                Image(systemName: "multiply.circle.fill")
                            }
                            .foregroundColor(.secondary)
                        }
                    }
                }
        }
    }
    
    var placeholder: String {
        switch self.type {
        case .email:
            return "email".localized()
        case .authCode:
            return "verification code".localized()
        case .password:
            return "new password".localized()
        case .password2:
            return "retype password".localized()
        case .nickname:
            return "nickname".localized()
        }
    }
    
    var keyboardType: UIKeyboardType {
        switch self.type {
        case .email:
            return .emailAddress
        default:
            return .alphabet
        }
    }
}

struct SignupFieldView_Previews: PreviewProvider {
    @State static private var text: String = ""
    @FocusState static private var focus: SignupTextFieldView.type?
    
    static var previews: some View {
        SignupTextFieldView(type: .email, text: $text, focus: $focus) {
            print("submit")
        }
    }
}
