//
//  VerifyAuthCodeUseCase.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/10/01.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation
import Combine

final class VerifyAuthCodeUseCase {
    private let repository: AuthV2Repository // TODO: 프로토콜로 수정
    
    init(repository: AuthV2Repository) {
        self.repository = repository
    }
    
    func execute(request: VerifyAuthCodeRequest) -> AnyPublisher<VerifyAuthCodeInfo, NetworkError> {
        return self.repository.verifyAuthCode(request: request)
    }
}
