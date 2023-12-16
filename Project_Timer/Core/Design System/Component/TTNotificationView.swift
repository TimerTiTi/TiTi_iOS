//
//  TTNotificationView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/16.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI

struct TTNotificationView: View {
    let info: NotificationInfo
    let closeAction: () -> Void
    let passAction: () -> Void
    let padding: CGFloat = 24
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
            
            VStack(spacing: 0) {
                TitleView(title: info.title, padding: padding)
                VStack(spacing: 0) {
                    TextView(text: info.text)
                    ForEach(info.notis, id: \.self) { noti in
                        NotiView(noti: noti)
                    }
                    Spacer().frame(height: 32)
                    CloseButton() {
                        closeAction()
                    }
                    PassTodayButton() {
                        passAction()
                    }
                }
                .padding(.horizontal, padding)
                
            }
            .background(Color.white)
            .frame(width: 342)
        }
    }
    
    struct TitleView: View {
        let title: String
        let padding: CGFloat
        
        var body: some View {
            ZStack {
                Colors.signinBackground.toColor
                
                Text(title)
                    .font(Typographys.autoFont(title, .bold_5, size: 18))
                    .foregroundStyle(Color.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, padding)
            }
            .frame(height: 88)
        }
    }
    
    struct TextView: View {
        let text: String
        
        var body: some View {
            Text(text)
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Color.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 24)
        }
    }
    
    struct NotiView: View {
        let noti: NotificationDetailInfo
        
        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                Text(noti.title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(Color.blue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(text)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.black)
                
                Spacer().frame(height: 8)
            }
        }
        
        var text: String {
            if noti.isDate {
                return "\(noti.text) (\(Localized.string(.Notification_Text_BaseOnUTC)))"
            } else {
                return noti.text
            }
        }
    }
    
    struct CloseButton: View {
        let action: () -> Void
        
        var body: some View {
            Button(action: {
                action()
            }, label: {
                ZStack {
                    Rectangle()
                        .background(Color.blue)
                        .frame(maxWidth: .infinity)
                        .frame(height: 42)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    
                    Text(Localized.string(.close))
                        .font(Typographys.font(.bold_5, size: 16))
                        .foregroundStyle(Color.white)
                }
            })
        }
    }
    
    struct PassTodayButton: View {
        let action: () -> Void
        
        var body: some View {
            Button(action: {
                action()
            }, label: {
                Text(Localized.string(.Notification_Button_PassToday))
                    .font(Typographys.font(.semibold_4, size: 13))
                    .foregroundStyle(Color.black)
                    .underline()
                    .padding(.vertical, 24)
            })
        }
    }
}

#Preview {
    TTNotificationView(info: .testInfo) {
        print("close")
    } passAction: {
        print("pass")
    }
}
