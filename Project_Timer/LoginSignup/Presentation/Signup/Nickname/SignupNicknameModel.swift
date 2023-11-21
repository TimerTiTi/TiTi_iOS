//
//  SignupNicknameModel.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/11/21.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

class SignupNicknameModel: ObservableObject {
    let infos: SignupInfosForNickname
    
    init(infos: SignupInfosForNickname) {
        self.infos = infos
    }
}
