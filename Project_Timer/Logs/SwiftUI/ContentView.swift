//
//  ContentView.swift
//  chartEx
//
//  Created by 신효근 on 2021/01/12.
//
import SwiftUI

struct ContentView: View {
    let colors = [Color("D2"), Color("D1")]
    var DailyDatas: [daily] = []
    
    init() {
        self.configureDailys()
    }
    
    var body : some View {
        //세로 스크롤 설정
        /* 전체 큰 틀 */
        VStack {
            //평균시간 텍스트
            let text = "Total : ".localized() + self.weeksStudyTime.toHM
            + "   |   " + "Average : ".localized() + self.averageTime.toHM
            Text(text)
                .fontWeight(.regular)
                .foregroundColor(.white)
                .font(.system(size:13))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 15)
            
            /* ----차트화면---- */
            VStack {
                //그래프 틀
                HStack(spacing:15) { //좌우로 15만큼 여백
                    ForEach(self.DailyDatas, id: \.self) { work in
                        //세로 스택
                        VStack{
                            //시간 + 그래프 막대
                            VStack{
                                //아래로 붙이기
                                Spacer(minLength: 0)
                                //시간 설정
                                Text(work.studyTime.toHM)
                                    .foregroundColor(Color.white)
                                    .font(.system(size:12))
                                    .padding(.bottom,-5)
                                //그래프 막대
                                RoundedShape()
                                    .fill(LinearGradient(gradient: .init(colors: colors), startPoint: .top, endPoint: .bottom))
                                    //그래프 막대 높이설정
                                    .frame(height: height(value: work.studyTime))
                            }
                            .frame(height:140)
                            //날짜 설정
                            Text(work.day)
                                .font(.system(size:12))
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .background(Color.black)
            .cornerRadius(15)
            /* ----차트끝---- */
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .preferredColorScheme(.dark)
    }
    
    mutating func configureDailys() {
        if AppDelegate.isDummyData == true {
            self.DailyDatas = Dummy.get7Dailys()
        } else {
            let dailys = RecordController.shared.dailys.dailys
            let dailysCount = dailys.count
            if dailysCount > 6 {
                self.DailyDatas = dailys[dailysCount-7..<dailysCount].map { daily($0) }
            } else {
                let emptyCount = 7 - dailysCount
                self.DailyDatas = dailys.map { daily($0) }
                self.DailyDatas += Array(repeating: daily(), count: emptyCount)
            }
        }
    }

    func height(value: Int) -> CGFloat {
        if self.maxTime == 0 {
            return 0
        } else {
            return (CGFloat(value) / CGFloat(self.maxTime)) * 120
        }
    }
    
    var maxTime: Int {
        return self.DailyDatas.map(\.studyTime).max() ?? 0
    }
    
    mutating func reset() {
        DailyDatas = []
    }
    
    var weeksStudyTime: Int {
        return self.DailyDatas.reduce(0) { $0 + $1.studyTime }
    }
    
    var averageTime: Int {
        let realCount = self.DailyDatas.filter { $0.studyTime != 0 }.count
        return realCount == 0 ? 0 : self.weeksStudyTime / realCount
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct RoundedShape : Shape {
    func path(in rect : CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 5, height: 5))
        return Path(path.cgPath)
    }
}
