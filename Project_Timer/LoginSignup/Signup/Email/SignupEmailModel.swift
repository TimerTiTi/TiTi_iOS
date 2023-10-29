//
//  SignupEmailModel.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/10/29.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class SignupEmailModel: ObservableObject {
    @Published var contentWidth: CGFloat = .zero
    @Published var authCode: String = ""
    @Published var wrongEmail: Bool?
    @Published var wrongAuthCode: Bool?
    
    // 화면크기에 따른 width 크기조정
    func updateContentWidth(size: CGSize) {
        switch size.deviceDetailType {
        case .iPhoneMini, .iPhonePro, .iPhoneMax:
            contentWidth = size.minLength - 48
        default:
            contentWidth = 400
        }
    }
}
