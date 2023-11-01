//
//  OverlayShowButtonForSecureFieldView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/10/31.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation
import SwiftUI

struct OverlayShowButtonForSecureFieldView: ViewModifier {
    var isVisible: Bool
    var isSecure: Bool
    var action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if isVisible {
                    HStack {
                        Spacer()
                        Button {
                            action()
                        } label: {
                            Image(systemName: isSecure ? "eye.slash" : "eye")
                        }
                        .foregroundColor(.secondary)
                    }
                }
                
            }
    }
}

extension View {
    func overlayShowButtonForSecureFieldView(isVisible: Bool, isSecure: Bool, action: @escaping () -> Void) -> some View {
        modifier(OverlayShowButtonForSecureFieldView(isVisible: isVisible, isSecure: isSecure, action: action))
    }
}
