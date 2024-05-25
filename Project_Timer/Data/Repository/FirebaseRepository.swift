//
//  FirebaseRepository.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/05/15.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation
import Moya
import Combine
import CombineMoya

final class FirebaseRepository {
    private let api: TTProvider<FirebaseAPI>
    
    init(api: TTProvider<FirebaseAPI>) {
        self.api = api
    }
    
    func getAppVersion() -> AnyPublisher<AppLatestVersionInfo, NetworkError> {
        return self.api.requestPublisher(.getAppVersion)
            .map(AppVersionResponse.self)
            .map { $0.toDomain() }
            .catchDecodeError()
    }
    
    func getServerURL() -> AnyPublisher<String, NetworkError> {
        return self.api.requestPublisher(.getServerURL)
            .map(ServerURLResponse.self)
            .map { $0.base.value }
            .catchDecodeError()
    }
}
