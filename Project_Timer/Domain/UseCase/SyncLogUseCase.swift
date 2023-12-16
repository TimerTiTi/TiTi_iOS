//
//  SyncLogUseCase.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/16.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

final class SyncLogUseCase: SyncLogUseCaseInterface {
    let repository: SyncLogRepositoryInterface
    
    init(repository: SyncLogRepositoryInterface) {
        self.repository = repository
    }
    
    func getSyncLog(completion: @escaping (Result<SyncLog?, NetworkError>) -> Void) {
        self.repository.get() { result in
            completion(result)
        }
    }
}
