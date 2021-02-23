//
//  ContentView.swift
//  chartEx
//
//  Created by 신효근 on 2021/01/12.
//
import SwiftUI

struct ContentView: View {
    //그래프 색상 그라데이션 설정
    var colors = [Color.blue, Color.purple]
    var colors2 = [Color.red, Color.purple]
    //화면
    var body : some View {
        //세로 스크롤 설정
        ScrollView(.vertical, showsIndicators: false) {
            /* 전체 큰 틀 */
            VStack {
                Spacer(minLength: 30)
                /* 차트화면 타이틀 */
                Text("공부시간")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer(minLength: 0)
                
                /* ----차트화면---- */
                VStack {
                    //평균시간 텍스트
                    Text("평균 : 3:20")
                        .fontWeight(.regular)
                        .foregroundColor(.white)
                        .font(.system(size:17))
                    //그래프 틀
                    HStack(spacing:15) { //좌우로 15만큼 여백
                        ForEach(workout_Data) {work in
                            //세로 스택
                            VStack{
                                //시간 + 그래프 막대
                                VStack{
                                    //아래로 붙이기
                                    Spacer(minLength: 0)
                                    //시간 설정
                                    Text(getHrs(value: work.totalTime))
                                        .foregroundColor(Color.white)
                                        .font(.system(size:14))
                                        .padding(.bottom,5)
                                    //그래프 막대
                                    RoundedShape()
                                        .fill(LinearGradient(gradient: .init(colors: colors), startPoint: .top, endPoint: .bottom))
                                        //그래프 막대 높이설정
                                        .frame(height:getHeight(value: work.totalTime))
                                }
                                .frame(height:150)
                                //날짜 설정
                                Text(work.date)
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(15)
                .padding()
                /* ----차트끝---- */
                
                /* 차트화면 타이틀 */
                Text("휴식시간")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer(minLength: 0)
                
                /* ----차트화면---- */
                VStack {
                    //평균시간 텍스트
                    Text("평균 : 3:20")
                        .fontWeight(.regular)
                        .foregroundColor(.white)
                        .font(.system(size:17))
                    //그래프 틀
                    HStack(spacing:15) { //좌우로 15만큼 여백
                        ForEach(workout_Data) {work in
                            //세로 스택
                            VStack{
                                //시간 + 그래프 막대
                                VStack{
                                    //아래로 붙이기
                                    Spacer(minLength: 0)
                                    //시간 설정
                                    Text(getHrs(value: work.totalTime))
                                        .foregroundColor(Color.white)
                                        .font(.system(size:14))
                                        .padding(.bottom,5)
                                    //그래프 막대
                                    RoundedShape()
                                        .fill(LinearGradient(gradient: .init(colors: colors2), startPoint: .top, endPoint: .bottom))
                                        //그래프 막대 높이설정
                                        .frame(height:getHeight(value: work.totalTime))
                                }
                                .frame(height:150)
                                //날짜 설정
                                Text(work.date)
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(15)
                .padding()
                /* ----차트끝---- */
                
                
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .preferredColorScheme(.dark)
        
    }

    
    
    func getHeight(value : CGFloat) -> CGFloat {
        let max = getMaxInTotalTime(value: workout_Data)
        return CGFloat(value / max) * 100
    }
    
    func getHrs (value : CGFloat) -> String {
        let minute = Int(value) - Int(value/60) * 60
        return String(Int(value/60)) + ":" + String(minute)
    }
    
    func getMaxInTotalTime (value : [Daily]) -> CGFloat {
        let totalTimeArray = value.map { (value : Daily) -> CGFloat in value.totalTime}

        return totalTimeArray.max()!
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

struct Daily : Identifiable {
    var id : Int
    var date : String
    var totalTime : CGFloat
}

var workout_Data = [

    Daily(id: 1, date: "10/10", totalTime: 300),
    Daily(id: 2, date: "10/11", totalTime: 254),
    Daily(id: 3, date: "10/12", totalTime: 128),
    Daily(id: 4, date: "10/13", totalTime: 100),
    Daily(id: 5, date: "10/14", totalTime: 52),
    Daily(id: 6, date: "10/15", totalTime: 270),
    Daily(id: 7, date: "10/16", totalTime: 250)
]


