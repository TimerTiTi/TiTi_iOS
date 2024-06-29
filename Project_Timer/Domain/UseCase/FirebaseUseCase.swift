//
//  FirebaseUseCase.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/06/29.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation
import Combine

final class FirebaseUseCase {
    private let repository: FirebaseRepository // TODO: 프로토콜로 수정
    
    init(repository: FirebaseRepository) {
        self.repository = repository
    }
    
    func getAppVersion() -> AnyPublisher<AppLatestVersionInfo, NetworkError> {
        return self.repository.getAppVersion()
    }
    
    func getServerURL() -> AnyPublisher<String, NetworkError> {
        return self.repository.getServerURL()
    }
    
    func getTiTiFunctions() -> AnyPublisher<[FunctionInfo], NetworkError> {
        return self.repository.getTiTiFunctions()
    }
    
    func getUpdateHistorys() -> AnyPublisher<[UpdateHistoryInfo], NetworkError> {
        return self.repository.getUpdateHistorys()
    }
    
    func getYoutubeLink() -> AnyPublisher<String, NetworkError> {
        return self.repository.getYoutubeLink()
    }
}

