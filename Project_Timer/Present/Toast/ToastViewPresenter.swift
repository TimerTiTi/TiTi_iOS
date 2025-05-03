//
//  ToastViewPresenter.swift
//  Project_Timer
//
//  Created by Minsang on 5/2/25.
//  Copyright © 2024 FDEE. All rights reserved.
//

import SwiftUI
import Combine

struct ToastViewPresenter<Content: ToastView>: View {
    
    var content: Content
    @ObservedObject var toastViewModel: ToastViewModel
    
    init(content: Content, toastViewModel: ToastViewModel) {
        self.content = content
        self.toastViewModel = toastViewModel
        self.yOffset = -content.height
    }
    
    @State var isShow: Bool = false
    @State var yOffset: CGFloat
    
    let topConstraint: CGFloat = UIApplication.shared.safeAreaTopInset
    
    var body: some View {
        ZStack {
            content
        }
        .background(
            RoundedRectangle(cornerRadius: 160)
                .frame(height: content.height)
                .foregroundStyle(Color(uiColor: Colors.BackgroundPrimary.value))
                .shadow(color: Color(uiColor: Colors.BackgroundPrimary.value).opacity(0.12), radius: 4, x: 0, y: 0)
        )
        .offset(y: yOffset)
        .ignoresSafeArea()
        .onAppear(perform: {
            yOffset = -content.height
        })
        .onReceive(toastViewModel.$isVisible, perform: { newValue in
            guard !isShow, newValue else { return }
            show()
        })
    }
    
    private func show() {
        isShow = true
        withAnimation(.spring(duration: 0.5)) {
            yOffset = topConstraint + content.topConstraint
        } completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                hide()
            }
        }
    }
    
    private func hide() {
        withAnimation(.easeIn(duration: 0.5)) {
            yOffset = -content.height
        } completion: {
            isShow = false
            toastViewModel.action(.removeToast)
        }
    }
    
}

#Preview {
    ToastViewPresenter(content: NewRecordToastView(recordDate: "25.05.01"), toastViewModel: ToastViewModel())
}
