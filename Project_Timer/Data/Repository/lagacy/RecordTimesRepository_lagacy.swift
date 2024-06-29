//
//  RecordTimesRepository_lagacy.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/16.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

final class RecordTimesRepository_lagacy: RecordTimesRepositoryInterface {
    private let api = RecordTimesNetwork()
    
    func upload(recordTimes: RecordTimes, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        api.upload(recordTimes: recordTimes) { result in
            switch result.status {
            case .SUCCESS:
                completion(.success(true))
            default:
                completion(.failure(.error(result)))
            }
        }
    }
    
    func get(completion: @escaping (Result<RecordTimes, NetworkError>) -> Void) {
        api.get { result in
            switch result.status {
            case .SUCCESS:
                guard let data = result.data,
                      let dto = try? JSONDecoder.dateFormatted.decode(RecordTimesDTO.self, from: data) else {
                    completion(.failure(.DECODEERROR))
                    return
                }
                
                let info = dto.toDomain()
                completion(.success(info))
            default:
                completion(.failure(.error(result)))
            }
        }
    }
}
