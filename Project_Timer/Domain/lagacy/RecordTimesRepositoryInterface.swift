//
//  RecordTimesRepositoryInterface.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/16.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

protocol RecordTimesRepositoryInterface {
    func upload(recordTimes: RecordTimes, completion: @escaping (Result<Bool, NetworkError>) -> Void)
    func get(completion: @escaping (Result<RecordTimes, NetworkError>) -> Void)
}
