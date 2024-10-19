//
//  ChangeCompleteModel.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/03/17.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: State
final class ChangeCompleteModel: ObservableObject {
    @Published var contentWidth: CGFloat = .zero
    
    let info: ChangeCompleteInfo
    let action: () -> Void
    
    init(info: ChangeCompleteInfo, buttonAction: @escaping (() -> Void)) {
        self.info = info
        self.action = buttonAction
    }
}

extension ChangeCompleteModel {
    // 화면크기에 따른 width 크기조정
    func updateContentWidth(size: CGSize) {
        switch size.deviceDetailType {
        case .iPhoneMini, .iPhonePro, .iPhoneMax:
            contentWidth = abs(size.minLength - 48)
        default:
            contentWidth = 400
        }
    }
}
