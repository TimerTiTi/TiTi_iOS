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
                                //시간 설정
//                                Text(getMin(value: time.sumTime))
//                                    .foregroundColor(Color("SystemBackground_reverse"))
//                                    .font(.system(size:14))
//                                    .padding(.bottom,3)
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
//            .padding(.vertical, 10)
            .cornerRadius(5)
            
            /* ----차트끝---- */
        }
        //            .padding(.horizontal, 20)
//        .padding(.vertical, 10)
//        .background(Color.black.edgesIgnoringSafeArea(.all))
        .background(Color("Background_second").edgesIgnoringSafeArea(.all))
        .preferredColorScheme(.dark)
    }

    
    
    func getHeight(value : Int) -> CGFloat {
        let max = getMaxInTotalTime(value: times)
        return (CGFloat(value) / CGFloat(max)) * height
    }
    
    func getMaxInTotalTime (value : [timeBlock]) -> Int {
//        let max: Int = getTimes().max()!
//        return max
        return 3600
    }
    
}

struct timeBlock : Identifiable {
    var id : Int
    var sumTime : Int
}

var times: [timeBlock] = []

extension todayContentView {
    
    func appendTimes(){
        var daily = Daily()
        daily.load()
        let timeline = daily.timeline
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
    
    func getMin(value: Int) -> String {
        let M = value/60
        let S = value%60
        return String(M)+":"+String(format: "%02d", S)
    }
    
    func getTimes() -> [Int] {
        let timeArray = times.map { (value : timeBlock) -> Int in value.sumTime}
        return timeArray
    }
    
    func translate(input: String) -> String {
        if(input == "NO DATA") {
            return "-/-"
        } else {
            print(input)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M월 d일"
            let exported = dateFormatter.date(from: input)!
            let newDateFormatter = DateFormatter()
            newDateFormatter.dateFormat = "M/d"
            return newDateFormatter.string(from: exported)
        }
    }
    
    func translate2(input: String) -> Int {
        if(input == "NO DATA") {
            return 0
        } else {
            var sum: Int = 0
            print(input)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            let exported = dateFormatter.date(from: input)!
            
            sum += Calendar.current.component(.hour, from: exported)*3600
            sum += Calendar.current.component(.minute, from: exported)*60
            sum += Calendar.current.component(.second, from: exported)
            return sum
        }
    }
    
    func appendDailyDatas(){
        for i in (1...7).reversed() {
            let id = 8-i
            let day = translate(input: UserDefaults.standard.value(forKey: "day\(i)") as? String ?? "NO DATA")
            let studyTime = translate2(input: UserDefaults.standard.value(forKey: "time\(i)") as? String ?? "NO DATA")
            let breakTime = translate2(input: UserDefaults.standard.value(forKey: "break\(i)") as? String ?? "NO DATA")
            DailyDatas.append(daily(id: id, day: day, studyTime: studyTime, breakTime: breakTime))
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
        let result: Int = value.count - zeroCount
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
        times = []
    }
    
    func appendDumyDatas(){
        let timeline = [3600,1300,0,0,0,0,0,0,0,1200,2000,3000,2600,2600,3600,3600,1000,0,500,2000,0,0,0,1200]
        var i = 5
        while(i < 29) {
            var id = i%24
            let sumTime = timeline[id]
            if(id == 0) { id = 24 }
            times.append(timeBlock(id: id, sumTime: sumTime))
            i += 1
        }
    }
}

