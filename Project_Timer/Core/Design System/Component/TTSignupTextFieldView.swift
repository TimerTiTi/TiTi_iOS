//
//  TTSignupTextFieldView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/10/09.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI

struct TTSignupTextFieldView: View {
    enum type: Equatable {
        case email
        case verificationCode
        case password
        case password2
        case nickname
    }
    
    let type: type
    let keyboardType: UIKeyboardType
    @Binding var text: String
    @FocusState.Binding var focus: type?
    let submitAction: () -> Void
    
    var body: some View {
        TextField("", text: $text)
            .font(.system(size: 20, weight: .semibold))
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
            .overlayRemoveButtonForTextFieldView(isVisible: (focus == self.type && !text.isEmpty), action: {
                text = ""
            })
    }
    
    var placeholder: String {
        switch self.type {
        case .email:
            return Localized.string(.SignUp_Hint_Email)
        case .verificationCode:
            return Localized.string(.SignUp_Hint_VerificationCode)
        case .nickname:
            return Localized.string(.SignUp_Hint_Nickname)
        default:
            return "placeholder"
        }
    }
}

struct SignupFieldView_Previews: PreviewProvider {
    @State static private var text: String = ""
    @FocusState static private var focus: TTSignupTextFieldView.type?
    
    static var previews: some View {
        TTSignupTextFieldView(type: .email, keyboardType: .emailAddress, text: $text, focus: $focus) {
            print("submit")
        }
    }
}
