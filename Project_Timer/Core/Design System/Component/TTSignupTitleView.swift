//
//  TTSignupTitleView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/10/30.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation
import SwiftUI

struct TTSignupTitleView: View {
    let title: String
    let subTitle: String
    
    init(title: String, subTitle: String) {
        self.title = title.localized()
        self.subTitle = subTitle.localized()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()
                .frame(height: 29)
            
            VStack(alignment: .leading, spacing: 16) {
                Text(title)
                    .font(Typographys.font(.bold_5, size: 22))
                Text(subTitle)
                    .font(Typographys.font(.semibold_4, size: 14))
                    .foregroundStyle(UIColor.secondaryLabel.toColor)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 127)
        }
    }
}
