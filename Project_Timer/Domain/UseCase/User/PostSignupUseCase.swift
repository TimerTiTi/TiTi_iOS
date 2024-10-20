//
//  PostSignupUseCase.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/10/20.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation
import Combine

final class PostSignupUseCase {
    private let repository: UserRepository // TODO: 프로토콜로 수정
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func execute(request: SignupRequest) -> AnyPublisher<TTResponseInfo, NetworkError> {
        return self.repository.register(
            request: request
        )
    }
}
