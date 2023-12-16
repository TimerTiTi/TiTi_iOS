//
//  AppLatestVersionRepository.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/03.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

final class AppLatestVersionRepository: AppLatestVersionRepositoryInterface {
    private let api = AppVersionAPI()
    
    func get(completion: @escaping (Result<AppLatestVersionInfo, NetworkError>) -> Void) {
        api.get { result in
            switch result.status {
            case .SUCCESS:
                guard let data = result.data,
                      let dto = try? JSONDecoder().decode(AppLatestVersionDTO.self, from: data) else {
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
