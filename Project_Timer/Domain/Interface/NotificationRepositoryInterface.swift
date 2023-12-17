//
//  NotificationRepositoryInterface.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/17.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

protocol NotificationRepositoryInterface {
    func get(completion: @escaping (Result<NotificationInfo?, NetworkError>) -> Void)
}
