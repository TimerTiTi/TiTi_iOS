//
//  Toast.swift
//  Project_Timer
//
//  Created by Ryeong on 6/22/24.
//  Copyright © 2024 FDEE. All rights reserved.
//

import SwiftUI
import Lottie

struct newRecordToastView: ToastViewProtocol {
    @ObservedObject var presenter: ToastPresenter
    @State private var playbackMode: LottiePlaybackMode = .paused
    
    var body: some View {
        ZStack(alignment: .center) {
            HStack(spacing: 4) {
                LottieView(animation: .named("newRecordLottie"))
                    .playbackMode(playbackMode)
                    .resizable()
                    .frame(width: 22, height: 22)
                Text("\(RecordsManager.shared.currentDaily.day.MMDDstyleString)")
                    .font(Fonts.PretendardSemiBold(size: 14))
                    .foregroundStyle(Color(uiColor: Colors.ttPrimary))
                Text("\(Localized.string(.Toast_Text_NewRecord))")
                    .font(Fonts.PretendardMedium(size: 14))
                    .foregroundStyle(.black)
            }
            .padding(EdgeInsets(top: 8,
                                leading: 12,
                                bottom: 8,
                                trailing: 20))
            .onAppear(perform: {
                playbackMode = .playing(.fromProgress(0, toProgress: 1, loopMode: .playOnce))
            })
        }
    }
}

#Preview {
    newRecordToastView(presenter: ToastPresenter(isPresenting: true))
}
