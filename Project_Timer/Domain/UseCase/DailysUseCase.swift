//
//  DailysUseCase.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/16.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

final class DailysUseCase: DailysUseCaseInterface {
    let repository: DailysRepositoryInterface
    
    init(repository: DailysRepositoryInterface = DailysRepository()) {
        self.repository = repository
    }
    
    func uploadDailys(dailys: [Daily], completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        self.repository.upload(dailys: dailys) { result in
            completion(result)
        }
    }
    
    func getDailys(completion: @escaping (Result<[Daily], NetworkError>) -> Void) {
        self.repository.get() { result in
            completion(result)
        }
    }
}
