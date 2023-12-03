//
//  AppVersionAPI.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/03.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

final class AppVersionAPI {
    private let network = Network()
    
    func getAppLatestVersion(completion: @escaping (Result<AppLatestVersionInfo, NetworkError>) -> Void) {
        self.network.request(url: NetworkURL.Firestore.latestVersion, method: .get) { result in
            switch result.status {
            case .SUCCESS:
                guard let data = result.data,
                      let latestVersionDTO = try? JSONDecoder().decode(AppLatestVersionDTO.self, from: data) else {
                    print("decode error")
                    print(String(data: result.data!, encoding: .utf8))
                    completion(.failure(.DECODEERROR))
                    return
                }
                
                completion(.success(latestVersionDTO.toDomain()))
                
            default:
                completion(.failure(NetworkError.error(result)))
            }
        }
    }
}
