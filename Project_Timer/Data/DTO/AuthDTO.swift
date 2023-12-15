//
//  AuthDTO.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/15.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

struct AuthDTO: Decodable {
    var id: Int
    var username: String
    var email: String
    var token: String
}
