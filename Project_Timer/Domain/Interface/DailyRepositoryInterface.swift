//
//  DailyRepositoryInterface.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/16.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

protocol DailyRepositoryInterface {
    func uploadDailys(dailys: [Daily], completion: @escaping (Result<Bool, NetworkError>) -> Void)
    func getDailys(completion: @escaping (Result<[Daily], NetworkError>) -> Void)
}
