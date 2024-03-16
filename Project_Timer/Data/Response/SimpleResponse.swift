//
//  SimpleResponse.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/03/16.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation

struct SimpleResponse: Decodable {
    let data: Bool
    let message: String
}
