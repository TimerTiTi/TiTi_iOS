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
    private let api: TTProvider<FirebaseAPI>
    
    init(api: TTProvider<FirebaseAPI>) {
        self.api = api
    }
    
    func getAppVersion() -> Single<AppLatestVersionInfo> {
        return self.api.rx.request(.getAppVersion)
            .map(AppVersionResponse.self)
            .map { $0.toDomain() }
            .catch { error in
                return Single.error(NetworkError.DECODEERROR)
            }
    }
    
    func getServerURL() -> Single<String> {
        return self.api.rx.request(.getServerURL)
            .map(ServerURLResponse.self)
            .map { $0.base.value }
            .catch { error in
                return Single.error(NetworkError.DECODEERROR)
            }
    }
}
