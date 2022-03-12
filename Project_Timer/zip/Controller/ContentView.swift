//
//  ContentView.swift
//  chartEx
//
//  Created by 신효근 on 2021/01/12.
//
import SwiftUI

struct ContentView: View {
    //그래프 색상 그라데이션 설정
    var colors = [Color("CCC2"), Color("CCC1")]
    //화면
    var body : some View {
        //세로 스크롤 설정
        /* 전체 큰 틀 */
        VStack {
            //평균시간 텍스트
            let text = "Total : ".localized() + getHrs(value: getSumTime(value: getStudyTimes()))
                + "   |   " + "Average : ".localized() + getHrs(value: getAverageTime(value: getStudyTimes()))
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
                                Text(getHrs(value: work.studyTime))
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

struct RoundedShape : Shape {
    func path(in rect : CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 5, height: 5))
        
        return Path(path.cgPath)
    }
}
// Dummy Data

struct daily : Identifiable {
    var id : Int
    var day : String
    var studyTime : Int
    var breakTime : Int
}

var DailyDatas: [daily] = []


extension ContentView {
    
    func getHrs(value : Int) -> String {
        var returnString = "";
        var num = value;
        if(num < 0) {
            num = -num;
            returnString += "+";
        }
        let H = num/3600
        let M = num/60 - H*60
        
        let stringM = M<10 ? "0"+String(M) : String(M)
        
        returnString += String(H) + ":" + stringM
        return returnString
    }
    
    func appendDailyDatas(isDumy: Bool){
        if(isDumy) {
            DailyDatas = Dumy().get7Dailys()
        } else {
            for i in (1...7).reversed() {
                let id = 8-i
                let day = ViewManager().translate(input: UserDefaults.standard.value(forKey: "day\(i)") as? String ?? "NO DATA")
                let studyTime = ViewManager().translate2(input: UserDefaults.standard.value(forKey: "time\(i)") as? String ?? "NO DATA")
                let breakTime = ViewManager().translate2(input: UserDefaults.standard.value(forKey: "break\(i)") as? String ?? "NO DATA")
                DailyDatas.append(daily(id: id, day: day, studyTime: studyTime, breakTime: breakTime))
            }
        }
    }
    
    func getAverageTime(value: [Int]) -> Int {
        var sum: Int = 0
        var zeroCount: Int = 0
        for i in value {
            if i == 0 {
                zeroCount += 1
            } else {
                sum += i
            }
        }
        let result = value.count - zeroCount
        if result == 0 {
            return 0
        } else {
            return sum/(value.count - zeroCount)
        }
    }
    
    func getSumTime(value: [Int]) -> Int {
        var sum: Int = 0
        for i in value {
            sum += i
        }
        return sum
    }
    
    func getStudyTimes() -> [Int] {
        let studyArray = DailyDatas.map { (value : daily) -> Int in value.studyTime}
        return studyArray
    }
    
    func getBreakTimes() -> [Int] {
        let breakArray = DailyDatas.map { (value : daily) -> Int in value.breakTime}
        return breakArray
    }
    
    func reset() {
        DailyDatas = []
    }
}
