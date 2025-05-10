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
                .frame(height: content.height)
        }
        .background(
            RoundedRectangle(cornerRadius: content.height/2, style: .continuous)
                .foregroundStyle(Color(uiColor: Colors.BackgroundPrimary.value))
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
