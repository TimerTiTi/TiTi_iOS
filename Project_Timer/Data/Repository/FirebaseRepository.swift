//
//  FirebaseRepository.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/05/15.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxMoya

final class FirebaseRepository {
    private let api: MoyaProvider<FirebaseAPI>
    
    init(api: MoyaProvider<FirebaseAPI>) {
        self.api = api
    }
    
    func getAppVersion() -> Single<AppLatestVersionInfo> {
        return self.api.rx.request(.getAppVersion)
            .map(AppVersionResponse.self)
            .map { $0.toDomain() }
            .catch { error in
                if let moyaError = error as? MoyaError {
                    switch moyaError {
                    case .statusCode(let response):
                        return Single.error(NetworkError.serverError(statusCode: response.statusCode))
                    default:
                        return Single.error(NetworkError.FAIL)
                    }
                }
                
                return Single.error(NetworkError.DECODEERROR)
            }
    }
}
