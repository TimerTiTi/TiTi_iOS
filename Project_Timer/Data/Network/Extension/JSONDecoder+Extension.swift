//
//  JSONDecoder+Extension.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/12/23.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

extension JSONDecoder {
    static var dateFormatted: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
}
