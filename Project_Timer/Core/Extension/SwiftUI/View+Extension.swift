//
//  View+Extension.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/09/26.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI
import Foundation

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
    
    
    /// view의 사이즈를 알아내는 함수
    @ViewBuilder
    func onReadSize(_ perform: @escaping (CGSize) -> Void) -> some View {
        self.background {
            GeometryReader { geometryProxy in
              Color.clear
                .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        }
        .onPreferenceChange(SizePreferenceKey.self, perform: perform)
    }
    
    /// 특정 코너 radius 주는 함수
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        mask(RoundedCorner(radius: radius, corners: corners))
            .ignoresSafeArea()
    }
}

// MARK: Functions

extension View {
    func scroll(_ scrollViewProxy: ScrollViewProxy, to: any Hashable) {
        #if targetEnvironment(macCatalyst)
        #else
        scrollViewProxy.scrollTo(to, anchor: .bottom)
        #endif
    }
}

// MARK: Helper

/// view size preference key
struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) { }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        return Path(path.cgPath)
    }
}
