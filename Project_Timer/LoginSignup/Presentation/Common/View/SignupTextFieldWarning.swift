//
//  SignupTextFieldWarning.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/10/30.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation
import SwiftUI

struct SignupTextFieldWarning: View {
    var warning: String
    var visible: Bool
    
    init(warning: String, visible: Bool) {
        self.warning = warning.localized()
        self.visible = visible
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()
                .frame(height: 2)
            
            Text(warning)
                .font(Typographys.font(.normal_3, size: 12))
                .foregroundStyle(Colors.wrongTextField.toColor)
                .opacity(visible ? 1.0 : 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
