//
//  View+Modifier.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/10/30.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation
import SwiftUI

/// textField 지닌 View 관련 modifier들 모음
struct ConfigureForTextFieldRootView: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .navigationTitle("")
            .ignoresSafeArea(.keyboard)
    }
}

extension View {
    func configureForTextFieldRootView() -> some View {
        modifier(ConfigureForTextFieldRootView())
    }
}
