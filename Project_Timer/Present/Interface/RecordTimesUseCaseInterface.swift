//
//  RecordTimesUseCaseInterface.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/16.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

protocol RecordTimesUseCaseInterface {
    var repository: RecordTimesRepositoryInterface { get }
    func uploadRecordTimes(recordTimes: RecordTimes, completion: @escaping (Result<Bool, NetworkError>) -> Void)
    func getRecordTimes(completion: @escaping (Result<RecordTimes, NetworkError>) -> Void)
}
