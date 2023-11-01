//
//  SignupSecureFieldView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/10/31.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI

struct SignupSecureFieldView: View {
    let type: SignupTextFieldView.type
    let keyboardType: UIKeyboardType
    @Binding var text: String
    @FocusState.Binding var focus: SignupTextFieldView.type?
    let submitAction: () -> Void
    
    @State private var isSecure: Bool = true
    
    var body: some View {
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
    }
    
    var placeholder: String {
        switch self.type {
        case .password:
            return "new password".localized()
        case .password2:
            return "confirm new password".localized()
        default:
            return "placeholder"
        }
    }
}

struct SignupSecureFieldView_Previews: PreviewProvider {
    @State static private var text: String = ""
    @FocusState static private var focus: SignupTextFieldView.type?
    
    static var previews: some View {
        SignupSecureFieldView(type: .password, keyboardType: .alphabet, text: $text, focus: $focus) {
            print("submit")
        }
    }
}
