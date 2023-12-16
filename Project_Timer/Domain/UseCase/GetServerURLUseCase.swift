//
//  GetServerURLUseCase.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/15.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

final class GetServerURLUseCase: GetServerURLUseCaseInterface {
    let repository: ServerURLRepositoryInterface
    
    init(repository: ServerURLRepositoryInterface) {
        self.repository = repository
    }
    
    func getServerURL(completion: @escaping (Result<String, NetworkError>) -> Void) {
        self.repository.get { result in
            completion(result)
        }
    }
}
