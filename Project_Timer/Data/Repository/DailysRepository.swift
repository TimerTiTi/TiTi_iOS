//
//  DailysRepository.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/06/09.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation
import Moya
import Combine
import CombineMoya

final class DailysRepository {
    private let api: TTProvider<DailysAPI>
    
    init(api: TTProvider<DailysAPI>) {
        self.api = api
    }
    
    func uploadDailys(request: [Daily]) -> AnyPublisher<Bool, NetworkError> {
        return self.api.request(.postDailys(request))
            .map { _ in true }
            .catchDecodeError()
    }
    
    func getDailys() -> AnyPublisher<[Daily], NetworkError> {
        return self.api.request(.getDailys)
            .tryMap { response in
                guard let dtos = try? JSONDecoder.dateFormatted.decode([DailyResponse].self, from: response.data) else {
                    throw NetworkError.DECODEERROR
                }
                return dtos.map { $0.toDomain() }
            }
            .catchDecodeError()
    }
}
