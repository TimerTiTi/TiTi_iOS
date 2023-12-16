//
//  DailysUseCaseInterface.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/16.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

protocol DailysUseCaseInterface {
    var repository: DailyRepositoryInterface { get }
    func uploadDailys(dailys: [Daily], completion: @escaping (Result<Bool, NetworkError>) -> Void)
    func getDailysFromServer(completion: @escaping (Result<[Daily], NetworkError>) -> Void)
}
