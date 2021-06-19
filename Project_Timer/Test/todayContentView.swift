//
//  ContentView.swift
//  chartEx
//
//  Created by minsang on 2021/01/12.
//
import SwiftUI

struct todayContentView: View {
    //그래프 색상 그라데이션 설정
    var colors = [Color("CCC2"), Color("CCC1")]
    //크기값 설정
    var frameHeight: CGFloat = 128
    var height: CGFloat = 125
    //화면
    var body : some View {
        //세로 스크롤 설정
        /* 전체 큰 틀 */
        VStack {
            /* ----차트화면---- */
            VStack {
                //그래프 틀
                HStack(spacing:2) { //좌우로 45만큼 여백
                    ForEach(times) {time in
                        //세로 스택
                        VStack{
                            //시간 + 그래프 막대
                            VStack{
                                //아래로 붙이기
                                Spacer(minLength: 0)
                                //그래프 막대
                                RoundedShape()
                                    .fill(LinearGradient(gradient: .init(colors: colors), startPoint: .top, endPoint: .bottom))
                                    //그래프 막대 높이설정
                                    .frame(height:getHeight(value: time.sumTime))
                            }
                            .frame(height:frameHeight)
                            //날짜 설정
                            Text(String(time.id))
                                .font(.system(size: 8.5))
                                .foregroundColor(Color("SystemBackground_reverse"))
                                .padding(.bottom,2)
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
        let max = getMaxInTotalTime(value: times)
        return (CGFloat(value) / CGFloat(max)) * height
    }
    
    func getMaxInTotalTime (value : [timeBlock]) -> Int {
        return 3600
    }
    
}

struct timeBlock : Identifiable {
    var id : Int
    var sumTime : Int
}

var times: [timeBlock] = []

extension todayContentView {
    
    func appendTimes(isDumy: Bool){
        var daily = Daily()
        daily.load()
        var timeline = daily.timeline
        if(isDumy) {
            timeline = Dumy().getTimelines()
        }
        print("timeline : \(timeline)")
        var i = 5
        while(i < 29) {
            var id = i%24
            let sumTime = timeline[id]
            if(id == 0) { id = 24 }
            times.append(timeBlock(id: id, sumTime: sumTime))
            i += 1
        }
    }
    
    func reset() {
        times = []
    }
}
