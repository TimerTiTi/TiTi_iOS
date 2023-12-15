//
//  DailyRepository.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/16.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

final class DailyRepository: DailyRepositoryInterface {
    private let api = DailyAPI()
    
    func uploadDailys(dailys: [Daily], completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        api.uploadDailys(dailys: dailys) { result in
            switch result.status {
            case .SUCCESS:
                completion(.success(true))
            default:
                completion(.failure(.error(result)))
            }
        }
    }
    
    func getDailys(completion: @escaping (Result<[Daily], NetworkError>) -> Void) {
        api.getDailys { result in
            switch result.status {
            case .SUCCESS:
                guard let data = result.data,
                      let dtos = try? JSONDecoder.dateFormatted.decode([DailyDTO].self, from: data) else {
                    completion(.failure(.DECODEERROR))
                    return
                }
                
                let dailys = dtos.map { $0.toDomain() }
                completion(.success(dailys))
            default:
                completion(.failure(.error(result)))
            }
        }
    }
}
