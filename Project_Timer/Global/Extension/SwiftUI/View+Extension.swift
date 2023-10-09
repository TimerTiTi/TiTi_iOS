//
//  View+Extension.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/09/26.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI

// MARK: View modifier
extension View {
    /// iOS17 widget: containerbackground
    /// https://nemecek.be/blog/192/hotfixing-widgets-for-ios-17-containerbackground-padding
    func widgetBackground(backgroundView: some View) -> some View {
        if #available(iOS 17.0, *) {
            return containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            return background(backgroundView)
        }
    }
    
    /// TextField placeholder color
    /// https://stackoverflow.com/questions/57688242/swiftui-how-to-change-the-placeholder-color-of-the-textfield/62950092
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

// MARK: View Builder
extension View {
    /// conditional view extension
    /// https://designcode.io/swiftui-handbook-conditional-modifier
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
