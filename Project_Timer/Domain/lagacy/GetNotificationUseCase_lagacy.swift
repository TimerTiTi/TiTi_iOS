//
//  GetNotificationUseCase_lagacy.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/17.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

final class GetNotificationUseCase_lagacy: GetNotificationUseCaseInterface {
    let repository: NotificationRepositoryInterface
    
    init(repository: NotificationRepositoryInterface) {
        self.repository = repository
    }
    
    func getNoti(completion: @escaping (Result<NotificationInfo?, NetworkError>) -> Void) {
        self.repository.get() { result in
            completion(result)
        }
    }
}
