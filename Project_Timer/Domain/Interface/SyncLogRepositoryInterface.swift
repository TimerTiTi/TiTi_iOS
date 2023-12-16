//
//  SyncLogRepositoryInterface.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/16.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

protocol SyncLogRepositoryInterface {
    func get(completion: @escaping (Result<SyncLog, NetworkError>) -> Void)
}
