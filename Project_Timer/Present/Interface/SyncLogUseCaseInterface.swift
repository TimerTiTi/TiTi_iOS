//
//  SyncLogUseCaseInterface.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/16.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

protocol SyncLogUseCaseInterface {
    var repository: SyncLogRepositoryInterface { get }
    func getSyncLog(completion: @escaping (Result<SyncLog?, NetworkError>) -> Void)
}
