//
//  SignupNextButtonForMac.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/10/30.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation
import SwiftUI

struct SignupNextButtonForMac: View {
    var visible: Bool
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .foregroundColor(visible ? .blue : .gray)
                    .shadow(color: .gray.opacity(0.1), radius: 4, x: 1, y: 2)
                    .frame(height: 60)
                
                Text("Next")
                    .font(TiTiFont.HGGGothicssiP60g(size: 20))
                    .foregroundStyle(Color.white)
            }
        }
    }
}
