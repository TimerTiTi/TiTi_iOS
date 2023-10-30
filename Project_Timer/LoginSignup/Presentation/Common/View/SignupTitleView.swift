//
//  SignupTitleView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/10/30.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation
import SwiftUI

struct SignupTitleView: View {
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
                    .font(TiTiFont.HGGGothicssiP80g(size: 22))
                Text(subTitle)
                    .font(TiTiFont.HGGGothicssiP60g(size: 14))
                    .foregroundStyle(UIColor.secondaryLabel.toColor)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
                .frame(height: 72)
        }
    }
}
