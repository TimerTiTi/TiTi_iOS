//
//  JSONParameterEncoder+Extension.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/12/21.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Alamofire

extension JSONParameterEncoder {
    static var dateFormatted: JSONParameterEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return JSONParameterEncoder(encoder: encoder)
    }()
}
