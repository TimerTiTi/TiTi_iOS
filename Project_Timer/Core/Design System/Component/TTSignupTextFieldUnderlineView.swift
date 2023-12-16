//
//  TTSignupTextFieldUnderlineView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/10/30.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation
import SwiftUI

struct TTSignupTextFieldUnderlineView: View {
    var color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()
                .frame(height: 12)
            
            Rectangle()
                .frame(height: 2)
                .foregroundStyle(color)
        }
    }
}
