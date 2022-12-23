//
//  UserDailysStatus.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/12/23.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

struct UserDailysStatus: Decodable {
    let updatedAt: Date
    let dailysCount: Int
}
