//
//  ToastView.swift
//  Project_Timer
//
//  Created by Ryeong on 6/24/24.
//  Copyright © 2024 FDEE. All rights reserved.
//

import SwiftUI

enum ToastType {
    case newRecord
}

protocol ToastViewProtocol: View {
    var presenter: ToastPresenter { get }
}

struct ToastView<Content: ToastViewProtocol>: ToastViewProtocol {
    @ObservedObject var presenter: ToastPresenter
    @State private var yOffset: CGFloat = 0
    @State private var viewHeight: CGFloat = 0
    let content: (_ presenter: ToastPresenter) -> Content
    
    var body: some View {
        ZStack {
            content(presenter)
        }
        .background(
            RoundedRectangle(cornerRadius: 160)
                .frame(height: 46)
                .foregroundColor(Color.white)
                .shadow(color: .gray.opacity(0.12),
                        radius: 4, x: 0, y: 4)
        )
        .onReadSize { viewHeight = $0.height }
        .offset(y: yOffset)
        .onAppear(perform: {
            show()
        })
    }
    
    private func show() {
        if #available(iOS 17.0, *) {
            withAnimation(.easeIn(duration: 0.15)) {
                yOffset = presenter.height + viewHeight
            } completion: {
                DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                    hide()
                })
            }
        } else {
            withAnimation(.easeIn(duration: 0.15)) {
                yOffset = presenter.height + viewHeight
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+1.15, execute: {
                hide()
            })
        }
    }
    
    private func hide() {
        if #available(iOS 17.0, *) {
            withAnimation(.easeOut(duration: 0.15)) {
                yOffset = 0
            } completion: {
                presenter.isPresenting = false
            }
        } else {
            withAnimation(.easeOut(duration: 0.15)) {
                yOffset = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.15, execute: {
                presenter.isPresenting = false
            })
        }
    }
}

#Preview {
    ToastView(presenter: ToastPresenter()) { presenter in
        newRecordToastView(presenter: presenter)
    }
}
