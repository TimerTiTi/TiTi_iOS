//
//  GetNotificationUseCaseInterface.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/17.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

protocol GetNotificationUseCaseInterface {
    var repository: NotificationRepositoryInterface { get }
    func getNoti(completion: @escaping (Result<NotificationInfo?, NetworkError>) -> Void)
}
