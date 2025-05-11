//
//  NotificationBottomSheetView.swift
//  Project_Timer
//
//  Created by Minsang on 5/10/25.
//  Copyright © 2025 FDEE. All rights reserved.
//

import SwiftUI

struct NotificationBottomSheetView: View {
    
    @State private var isSelectHideWeek: Bool = false
    @State private var textHeight: CGFloat = 0
    
    let info: NotificationInfo
    let closeAction: () -> Void
    let passWeekAction: ((Bool) -> Void)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            TopButtons
                .padding(.horizontal, 22)
            
            ZStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 0) {
                    
                    Title(info.title)
                    SubTitle(info.subTitle)
                    
                    Spacer().frame(height: 14)
                    Divider()
                        .frame(height: 1)
                        .background(Color(uiColor: Colors.DividerPrimary.value))
                    Spacer().frame(height: 20)
                    
                    ForEach(info.notis, id: \.self) { detailInfo in
                        DetailInfo(detailInfo)
                        Spacer().frame(height: 20)
                    }
                    
                    ScrollView(.vertical) {
                        Text(info.text)
                            .font(Fonts.PretendardReqular(size: 14))
                            .foregroundStyle(Color(uiColor: Colors.TextSecondary.value))
                            .padding(.horizontal, info.notis.isEmpty ? 0 : 12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineSpacing(6)
                            .background(GeometryReader { proxy in
                                Color.clear
                                    .preference(key: TextHeightPreferenceKey.self, value: proxy.size.height)
                            })
                        
                    }
                    .frame(height: min(max(textHeight, 50), 150))
                    .onPreferenceChange(TextHeightPreferenceKey.self) { value in
                        textHeight = value
                    }
                    
                    Spacer().frame(height: 28)
                    
                    TTBottomRoundButtonView(title: Localized.string(.Common_Text_OK), height: 49) {
                        closeAction()
                    }
                    
                }
                .padding(.init(top: 20, leading: 20, bottom: 20, trailing: 20))
                .background(
                    Color(uiColor: Colors.BackgroundPrimary.value)
                        .cornerRadius(16, corners: [.topLeft, .topRight])
                        .ignoresSafeArea()
                )
            }
            
        }
        
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
                    
                    Text(Localized.string(.Notification_Button_PassWeek))
                        .font(Fonts.PretendardReqular(size: 15))
                        .foregroundStyle(Color.white)
                }
            }
            
            Spacer()
            
            Button {
                closeAction()
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
    
    func DetailInfo(_ info: NotificationDetailInfo) -> some View {
        ZStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 0) {
                
                Text(info.title)
                    .font(Fonts.PretendardSemiBold(size: 15))
                    .foregroundStyle(Color(uiColor: Colors.Primary.value))
                    .frame(maxWidth: .infinity, minHeight: 24, alignment: .leading)
                Text(info.text)
                    .font(Fonts.PretendardMedium(size: 15))
                    .foregroundStyle(Color(uiColor: Colors.TextSub1.value))
                    .frame(maxWidth: .infinity, minHeight: 24, alignment: .leading)
                
            }
            .padding(.init(top: 14, leading: 18, bottom: 14, trailing: 18))
        }
        .background(Color(uiColor: Colors.BackgroundSecondary.value))
        .cornerRadius(8)
    }
}

// PreferenceKey 선언 (하위 뷰가 측정한 값을 상위 뷰로 전달하는 방법)
struct TextHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        // 가장 최신값을 저장
        value = nextValue()
    }
}


#Preview {
    NotificationBottomSheetView(info: .testInfo, closeAction: {
        print("close")
    }, passWeekAction: { isPass in
        print("isPass: \(isPass)")
    })
}
