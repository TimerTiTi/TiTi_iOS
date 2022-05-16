//
//  ContentView.swift
//  chartEx
//
//  Created by 신효근 on 2021/01/12.
//
import SwiftUI

struct ContentView: View {
    let colors = [Color("CCC2"), Color("CCC1")]
    var DailyDatas: [daily] = []
    
    init() {
        self.configureDailys()
    }
    
    var body : some View {
        //세로 스크롤 설정
        /* 전체 큰 틀 */
        VStack {
            //평균시간 텍스트
            let text = "Total : ".localized() + self.weeksStudyTime.toTimeString
            + "   |   " + "Average : ".localized() + self.averageTime.toTimeString
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
                    ForEach(DailyDatas) {work in
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
                                    .frame(height:getHeight(value: work.studyTime))
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
    
    func configureDailys() {
        // TODO: [Daily] -> [daily] 로직 작성
    }

    func getHeight(value : Int) -> CGFloat {
        let max = getMaxInTotalTime(value: DailyDatas)
        return (CGFloat(value) / CGFloat(max)) * 120
    }
    
    func getMaxInTotalTime (value : [daily]) -> Int {
        let sMax: Int = getStudyTimes().max()!
        let bMax: Int = getBreakTimes().max()!
        if sMax > bMax {
            return sMax
        } else {
            return bMax
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension ContentView {
    var weeksStudyTime: Int {
        return self.DailyDatas.reduce(0) { $0 + $1.studyTime }
    }
    
    var averageTime: Int {
        let realCount = self.DailyDatas.filter { $0.studyTime != 0 }.count
        return self.weeksStudyTime / realCount
    }
}

struct RoundedShape : Shape {
    func path(in rect : CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 5, height: 5))
        
        return Path(path.cgPath)
    }
}

extension ContentView {
    func appendDailyDatas(isDummy: Bool) {
        DailyDatas = isDummy ? Dumy.get7Dailys() : RecordController.shared.dailys.dailys
        if isDummy { DailyDatas = Dumy.get7Dailys() }
        else {
            for i in (1...7).reversed() {
                let id = 8-i
                let day = Converter.translate(input: UserDefaults.standard.value(forKey: "day\(i)") as? String ?? "NO DATA")
                let studyTime = Converter.translate2(input: UserDefaults.standard.value(forKey: "time\(i)") as? String ?? "NO DATA")
                let breakTime = Converter.translate2(input: UserDefaults.standard.value(forKey: "break\(i)") as? String ?? "NO DATA")
                DailyDatas.append(daily(id: id, day: day, studyTime: studyTime, breakTime: breakTime))
            }
        }
    }
    
    
    
    func reset() {
        DailyDatas = []
    }
}
