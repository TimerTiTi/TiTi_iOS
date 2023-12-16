//
//  RecordTimesUseCase.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/16.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

final class RecordTimesUseCase: RecordTimesUseCaseInterface {
    let repository: RecordTimesRepositoryInterface
    
    init(repository: RecordTimesRepositoryInterface = RecordTimesRepository()) {
        self.repository = repository
    }
    
    func uploadRecordTimes(recordTimes: RecordTimes, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        self.repository.upload(recordTimes: recordTimes) { result in
            completion(result)
        }
    }
    
    func getRecordTimes(completion: @escaping (Result<RecordTimes, NetworkError>) -> Void) {
        self.repository.get() { result in
            completion(result)
        }
    }
}
