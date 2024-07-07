//
//  GetDailysUseCase.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/07/07.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation
import Combine

final class GetDailysUseCase {
    let repository: DailysRepository
    
    init(repository: DailysRepository) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[Daily], NetworkError> {
        return self.repository.getDailys()
    }
}
