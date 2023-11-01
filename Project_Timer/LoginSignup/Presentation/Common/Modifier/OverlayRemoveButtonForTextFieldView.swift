//
//  OverlayRemoveButtonForTextFieldView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/10/31.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation
import SwiftUI

struct OverlayRemoveButtonForTextFieldView: ViewModifier {
    var isVisible: Bool
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
                            Image(systemName: "multiply.circle.fill")
                        }
                        .foregroundColor(.secondary)
                    }
                }
            }
    }
}

extension View {
    func overlayRemoveButtonForTextFieldView(isVisible: Bool, action: @escaping () -> Void) -> some View {
        modifier(OverlayRemoveButtonForTextFieldView(isVisible: isVisible, action: action))
    }
}
