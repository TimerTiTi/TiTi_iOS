//
//  AuthRepository.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2024/05/22.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxMoya

final class AuthRepository {
    private let api: TTProvider<AuthAPI>
    
    init(api: TTProvider<AuthAPI>) {
        self.api = api
    }
    
    func postSignup(info: TestUserSignupInfo) -> Single<AuthInfo> {
        return self.api.rx.request(.postSignup(info))
            .map(AuthResponse.self)
            .map { $0.toDomain() }
            .catch { error in
                return Single.error(NetworkError.DECODEERROR)
            }
    }
    
    
}
