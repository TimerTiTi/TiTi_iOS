//
//  AppleLoginButton.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/09/24.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI

struct AppleLoginButton: View {
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack{
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.white)
                    .shadow(color: .gray.opacity(0.1), radius: 4, x: 1, y: 2)
                    .frame(maxWidth: .infinity)
                    .frame(height: 58)
                
                HStack(spacing: 12) {
                    Text("")
                        .font(.system(size: 30))
                    Text("Sign in with \("Apple")")
                        .font(.system(size: 20, weight: .bold, design: .default))
                }
            }
        }
        .foregroundColor(.black)
    }
}
