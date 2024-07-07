//
//  GetRecordTimeUseCase.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/07/07.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation
import Combine

final class GetRecordTimeUseCase {
    private let repository: RecordTimesRepository
    
    init(repository: RecordTimesRepository) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<RecordTimes, NetworkError> {
        return self.repository.get()
    }
}
