//
//  ServerURLRepository.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/15.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

final class ServerURLRepository: ServerURLRepositoryInterface {
    private let api = ServerURLAPI()
    
    func getServerURL(completion: @escaping (Result<String, NetworkError>) -> Void) {
        api.getServerURL { result in
            switch result.status {
            case .SUCCESS:
                guard let data = result.data,
                      let dto = try? JSONDecoder().decode(ServerURLDTO.self, from: data) else {
                    completion(.failure(.DECODEERROR))
                    return
                }
                
                let url = dto.url.value
                completion(.success(url))
                
            default:
                completion(.failure(NetworkError.error(result)))
            }
        }
    }
}
