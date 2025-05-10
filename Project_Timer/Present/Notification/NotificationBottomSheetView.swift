//
//  NotificationBottomSheetView.swift
//  Project_Timer
//
//  Created by Minsang on 5/10/25.
//  Copyright © 2025 FDEE. All rights reserved.
//

import SwiftUI

struct NotificationBottomSheetView: View {
    
    @State var isSelectHideWeek: Bool = false
    @State var close: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            TopButtons
                .padding(.horizontal, 22)
            
            ZStack(alignment: .leading) {
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    Title("공지사항")
                    SubTitle("기록동기화 (Sync Dailys) 기능 중단 안내")
                    
                    Spacer().frame(height: 14)
                    
                    Divider()
                        .frame(height: 1)
                        .background(Color(uiColor: Colors.DividerPrimary.value))
                    
                    Spacer().frame(height: 20)
                    
                    ZStack(alignment: .leading) {
                        
                        VStack(alignment: .leading, spacing: 0) {
                            
                            InfoTitle("중단일시")
                            InfoSubTitle("2023.03.01 10:00:00Z (UTC 기준)")
                            
                        }
                        .padding(.init(top: 14, leading: 18, bottom: 14, trailing: 18))
                        
                    }
                    .background(Color(uiColor: Colors.BackgroundSecondary.value))
                    .cornerRadius(8)
                    
                }
                .padding(.init(top: 20, leading: 20, bottom: 20 + UIApplication.shared.safeAreaBottomInset, trailing: 20))
                
            }
            .frame(maxWidth: .infinity)
            .background(Color(uiColor: Colors.BackgroundPrimary.value))
            .cornerRadius(16, corners: [.topLeft, .topRight])
            
        }
        .background(Color.black.opacity(0.2))
        
    }
    
    var TopButtons: some View {
        HStack {
            Button {
                isSelectHideWeek.toggle()
            } label: {
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.white)
                        .stroke(Color(uiColor: isSelectHideWeek ? Colors.Primary.value : Colors.Gray70.value), lineWidth: isSelectHideWeek ? 4 : 1)
                        .padding(isSelectHideWeek ? 2 : 0.5)
                        .frame(width: 18, height: 18)
                    
                    Text("1주일간 다시 보지 않기")
                        .font(Fonts.PretendardReqular(size: 15))
                        .foregroundStyle(Color.white)
                }
            }
            
            Spacer()
            
            Button {
                close = true
            } label: {
                Image(uiImage: Icons.Close18.value)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
            }
        }
    }
    
    func Title(_ title: String) -> some View {
        Text(title)
            .font(Fonts.PretendardBold(size: 20))
            .foregroundStyle(Color(uiColor: Colors.TextPrimary.value))
            .frame(maxWidth: .infinity, minHeight: 32, alignment: .leading)
    }
    
    func SubTitle(_ title: String) -> some View {
        Text(title)
            .font(Fonts.PretendardMedium(size: 15))
            .foregroundStyle(Color(uiColor: Colors.TextSecondary.value))
            .frame(maxWidth: .infinity, minHeight: 24, alignment: .leading)
    }
    
    func InfoTitle(_ title: String) -> some View {
        Text(title)
            .font(Fonts.PretendardSemiBold(size: 15))
            .foregroundStyle(Color(uiColor: Colors.Primary.value))
            .frame(maxWidth: .infinity, minHeight: 24, alignment: .leading)
    }
    
    func InfoSubTitle(_ title: String) -> some View {
        Text(title)
            .font(Fonts.PretendardMedium(size: 15))
            .foregroundStyle(Color(uiColor: Colors.TextSub1.value))
            .frame(maxWidth: .infinity, minHeight: 24, alignment: .leading)
    }
}

#Preview {
    NotificationBottomSheetView()
}
