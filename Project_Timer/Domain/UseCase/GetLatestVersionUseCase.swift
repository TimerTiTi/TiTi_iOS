//
//  GetLatestVersionUseCase.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/03.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

final class GetLatestVersionUseCase: GetLatestVersionUseCaseInterface {
    let repository: AppLatestVersionRepositoryInterface
    
    init(repository: AppLatestVersionRepositoryInterface = AppLatestVersionRepository()) {
        self.repository = repository
    }
    
    func getLatestVersion(completion: @escaping (Result<AppLatestVersionInfo, NetworkError>) -> Void) {
        self.repository.getLatestVersion { result in
            completion(result)
        }
    }
}
