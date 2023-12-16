//
//  DailysRepository.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/16.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

final class DailysRepository: DailysRepositoryInterface {
    private let api = DailysAPI()
    
    func upload(dailys: [Daily], completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        api.upload(dailys: dailys) { result in
            switch result.status {
            case .SUCCESS:
                completion(.success(true))
            default:
                completion(.failure(.error(result)))
            }
        }
    }
    
    func get(completion: @escaping (Result<[Daily], NetworkError>) -> Void) {
        api.get { result in
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
    
    func store(dailys: [Daily], completion: @escaping (Result<Bool, Error>) -> Void) {
        
    }
    
    func fetch(completion: @escaping (Result<[Daily], Error>) -> Void) {
        
    }
}
