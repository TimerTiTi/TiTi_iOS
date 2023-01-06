//
//  TimeTableView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/01/06.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI

struct TimeTableBlock : Identifiable {
    let id : Int
    let colorIndex : Int
    let hour: Int // y
    let startSeconds: Int // x
    let interver: Int // width
}

struct TimeTableView: View {
    var bounds: CGSize = CGSize(width: 105, height: 274.333)
    @ObservedObject var viewModel: TimeTableVM
    
    init(frameSize: CGSize, viewModel: TimeTableVM) {
        self.bounds = CGSize(width: frameSize.width-4, height: frameSize.height-4)
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ForEach(viewModel.blocks) { block in
                RoundedRectangle(cornerRadius: 2)
                    .fill(TiTiColor.graphColor(num: block.colorIndex).toColor)
                    .frame(width: (CGFloat(block.interver)/CGFloat(3600))*86.5, height: 10.5)
                    .offset(x: 14+(CGFloat(block.startSeconds)/CGFloat(3600))*86.5, y: 0.3+CGFloat((block.hour + 24 - 5)%24)*11.26)
            }
            self.horizontalLines
            self.verticalLines
        }
        .background(Color("Background_second").edgesIgnoringSafeArea(.all))
        .padding(2)
    }
    
    var horizontalLines: some View {
        VStack(spacing: 0) {
            ForEach(5..<29) { time in
                Spacer(minLength: 0)
                HStack(spacing: 0) {
                    Text(String(time%24))
                        .frame(width: 13.5)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 7))
                        .foregroundColor(Color("SystemBackground_reverse"))
                    Spacer()
                }
                Spacer(minLength: 0)
                Divider()
                    .foregroundColor(.white.opacity(0.5))
            }
        }
        .frame(width: bounds.width, height: bounds.height)
    }
    
    var verticalLines: some View {
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
        .frame(width: bounds.width, height: bounds.height)
    }
}
