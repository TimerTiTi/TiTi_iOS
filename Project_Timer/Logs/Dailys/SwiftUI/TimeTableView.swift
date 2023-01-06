//
//  TimeTableView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/01/06.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI

struct TimeTableView: View {
    var frameHeight: CGFloat = 274.333
    
    init(frameHeight: CGFloat) {
        self.frameHeight = frameHeight-4
    }
    var body: some View {
        ZStack(alignment: .center) {
            VStack(spacing: 0) {
                ForEach(5..<29) { time in
                    Spacer(minLength: 0)
                    HStack(spacing: 0) {
                        Text(String(time%24))
                            .frame(width: 13.5)
                            .multilineTextAlignment(.center)
                            .font(.system(size: 8.5))
                            .foregroundColor(Color("SystemBackground_reverse"))
                        Spacer()
                    }
                    Spacer(minLength: 0)
                    Divider()
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            .frame(width: 101, height: 270.333)

            HStack(spacing: 0) {
                Spacer(minLength: 13)
                Divider()
                    .frame(width: 2)
                ForEach(0..<6) { _ in
                    Spacer(minLength: 13.5)
                    Divider()
                        .frame(width: 1)
                }
            }
            .frame(width: 101, height: 270.333)
        }
        .background(Color("Background_second").edgesIgnoringSafeArea(.all))
        .padding(2)
    }
}

struct TimeTableView_Previews: PreviewProvider {
    static var previews: some View {
        TimeTableView(frameHeight: 274.333)
    }
}
