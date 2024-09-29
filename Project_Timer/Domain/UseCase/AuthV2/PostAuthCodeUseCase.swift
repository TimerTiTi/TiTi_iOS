//
//  PostAuthCodeUseCase.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/09/29.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation
import Combine

final class PostAuthCodeUseCase {
    enum PostType {
        case signup(email: String)
    }
    
    private let repository: AuthV2Repository // TODO: 프로토콜로 수정
    
    init(repository: AuthV2Repository) {
        self.repository = repository
    }
    
    func execute(type: PostType) -> AnyPublisher<PostAuthCodeInfo, NetworkError> {
        switch type {
        case .signup(let email):
            return self.repository.postAuthcode(
                request: PostAuthCodeRequest(
                    targetType: "EMAIL",
                    targetValue: email,
                    authType: "SIGN_UP")
            )
        }
    }
}
