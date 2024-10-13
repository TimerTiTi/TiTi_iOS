//
//  API.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/04/17.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation
import Moya

extension TargetType {
    /// Request 구조체 -> dictionary 반환
    static func parameters(from encodable: Encodable) -> [String: Any] {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(encodable),
              let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            return [:]
        }
        
        return dictionary
    }
    
    /// 쿼리 파라미터 디버그를 위한 값 반환
    var queryParameters: [String: Any]? {
        switch task {
        case .requestParameters(let parameters, let encoding):
            if encoding is URLEncoding {
                return parameters
            }
            return nil
        default:
            return nil
        }
    }
}

extension JSONEncoder {
    static var dateFormatted: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
}
