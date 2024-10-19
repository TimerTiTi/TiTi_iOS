//
//  ChangeCompleteView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/03/17.
//  Copyright © 2024 FDEE. All rights reserved.
//

import SwiftUI
import Lottie

struct ChangeCompleteView: View {
    @StateObject private var model: ChangeCompleteModel
    
    init(model: ChangeCompleteModel) {
        _model = StateObject(wrappedValue: model)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Colors.firstBackground.toColor
                    .ignoresSafeArea()
                
                ContentView(model: self.model)
            }
            .onChange(of: geometry.size, perform: { value in
                self.model.updateContentWidth(size: value)
            })
        }
        .configureForTextFieldRootView()
    }
    
    struct ContentView: View {
        @EnvironmentObject var environment: ResetPasswordEnvironment
        @ObservedObject var model: ChangeCompleteModel
        
        var body: some View {
            HStack {
                Spacer()
                ZStack {
                    VStack(alignment: .leading, spacing: 0) {
                        TTChangeCompleteTitleView(title: self.model.info.title, subTitle: self.model.info.subTitle)
                        
                        Spacer()
                        
                        TTBottomRoundButtonView(
                            title: self.model.info.buttonTitle,
                            action: self.model.action
                        )
                    }
                    .frame(width: self.model.contentWidth)
                    
                    LottieView(animation: .named("successBlueLottie"))
                        .looping()
                        .frame(width: 300, height: 300)
                }
                Spacer()
            }
        }
    }
}

struct ResetPasswordCompleteView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeCompleteView(model: ChangeCompleteModel(
            info: ChangeCompleteInfo(
                title: "변경이 완료되었어요!",
                subTitle: "비밀번호가 재설정 되었어요!",
                buttonTitle: "로그인하러 갈래요!"
            ), buttonAction: {
                print("complete")
            })).environmentObject(ResetPasswordEnvironment())
    }
}
