//
//  TTChangeCompleteTitleView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/03/17.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation
import SwiftUI

struct TTChangeCompleteTitleView: View {
    let title: String
    let subTitle: String
    
    init(title: String, subTitle: String) {
        self.title = title
        self.subTitle = subTitle
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()
                .frame(height: 29)
            
            VStack(alignment: .leading, spacing: 16) {
                Text(title)
                    .font(Typographys.font(.bold_5, size: 32))
                Text(subTitle)
                    .font(Typographys.font(.semibold_4, size: 14))
                    .foregroundStyle(UIColor.secondaryLabel.toColor)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
