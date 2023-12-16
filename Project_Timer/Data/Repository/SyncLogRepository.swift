//
//  SyncLogRepository.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/16.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

final class SyncLogRepository: SyncLogRepositoryInterface {
    private let api = SyncLogAPI()
    
    func get(completion: @escaping (Result<SyncLog?, NetworkError>) -> Void) {
        api.get { result in
            switch result.status {
            case .SUCCESS:
                if let data = result.data {
                    guard let dto = try? JSONDecoder.dateFormatted.decode(SyncLogDTO.self, from: data) else {
                        completion(.failure(.DECODEERROR))
                        return
                    }
                    
                    let info = dto.toDomain()
                    completion(.success(info))
                } else {
                    completion(.success(nil))
                }
            default:
                completion(.failure(.error(result)))
            }
        }
    }
}
