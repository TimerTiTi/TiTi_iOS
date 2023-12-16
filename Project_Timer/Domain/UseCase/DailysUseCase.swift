//
//  DailysUseCase.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/16.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

final class DailysUseCase: DailysUseCaseInterface {
    let repository: DailyRepositoryInterface
    
    init(repository: DailyRepositoryInterface = DailyRepository()) {
        self.repository = repository
    }
    
    func uploadDailys(dailys: [Daily], completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        self.repository.uploadDailys(dailys: dailys) { result in
            completion(result)
        }
    }
    
    func getDailysFromServer(completion: @escaping (Result<[Daily], NetworkError>) -> Void) {
        self.repository.getDailys(fromServer: true) { result in
            completion(result)
        }
    }
}
