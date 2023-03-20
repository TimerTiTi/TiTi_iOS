//
//  TimelineView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/07/17.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

struct TimeBlock : Identifiable {
    var id : Int
    var sumTime : Int
}

struct TimelineView: View {
    var frameHeight: CGFloat = 100
    @ObservedObject var viewModel: TimelineVM
    
    init(frameHeight: CGFloat, viewModel: TimelineVM) {
        self.frameHeight = frameHeight - 20 // 왜 20을 빼야 정상적으로 보이는지는 의문인 상태..
        self.viewModel = viewModel
    }
    
    var body: some View {
        //세로 스크롤 설정
        /* 전체 큰 틀 */
        VStack {
            /* ----차트화면---- */
            VStack {
                //그래프 틀
                HStack(spacing:2) { //좌우로 45만큼 여백
                    ForEach(viewModel.times) { time in
                        //세로 스택
                        VStack{
                            //시간 + 그래프 막대
                            VStack{
                                //아래로 붙이기
                                Spacer(minLength: 0)
                                //그래프 막대
                                RoundedShape()
                                    .fill(LinearGradient(gradient: .init(colors: [TiTiColor.graphColor(num: viewModel.color1Index).toColor, TiTiColor.graphColor(num: viewModel.color2Index).toColor]), startPoint: .top, endPoint: .bottom))
                                    //그래프 막대 높이설정
                                    .frame(height:getHeight(value: time.sumTime))
                                    .padding(.bottom,-4)
                            }
                            .frame(height:frameHeight)
                            //날짜 설정
                            Text(String(time.id))
                                .font(.system(size: 8.5))
                                .foregroundColor(Color("SystemBackground_reverse"))
                                .padding(.bottom,0)
                        }
                    }
                }
            }
            .padding(.horizontal, 2)
            .cornerRadius(5)
            
            /* ----차트끝---- */
        }
        .background(Color("Background_second").edgesIgnoringSafeArea(.all))
        .preferredColorScheme(.dark)
    }
    
    func getHeight(value : Int) -> CGFloat {
        return (CGFloat(value) / CGFloat(3600)) * (self.frameHeight-3)
    }
}
