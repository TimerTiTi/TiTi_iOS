//
//  GetUsernameNotExistUseCase.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/09/01.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation
import Combine

final class GetUsernameNotExistUseCase {
    private let repository: AuthV2Repository // TODO: 프로토콜로 수정
    
    init(repository: AuthV2Repository) {
        self.repository = repository
    }
    
    func execute(username: String) -> AnyPublisher<CheckUsernameInfo, NetworkError> {
        return self.repository.checkUsername(
            request: .init(username: username)
        )
    }
}
