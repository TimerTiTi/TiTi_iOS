//
//  NetworkURL.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/05/21.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import SwiftUI
import Moya
import Combine

final class NetworkURL {
    static let shared = NetworkURL()
    static var serverURL_V2: String {
#if DEBUG || DEVELOP
        return "http://ec2-43-200-217-188.ap-northeast-2.compute.amazonaws.com:8080/api/user"
#else
        return "http://ec2-43-200-217-188.ap-northeast-2.compute.amazonaws.com:8080/api/user"
#endif
    }
    private(set) var serverURL: String?
    // Combine binding
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        self.getServerURL()
            .sink { _ in }
            .store(in: &self.cancellables)
    }
    
    func getServerURL() -> AnyPublisher<String?, Never> {
        // TODO: DI 수정
        let api = TTProvider<FirebaseAPI>(session: Session(interceptor: NetworkInterceptor.shared))
        let repository = FirebaseRepository(api: api)
        let getServerURLUseCase = GetServerURLUseCase(repository: repository)
        
        return Future<String?, Never> { [weak self] promise in
            guard let self else { promise(.success(nil)); return }
            
            getServerURLUseCase.execute()
                .sink { [weak self] completion in
                    if case .failure(let networkError) = completion {
                        print("ERROR", #function, networkError)
                        self?.serverURL = nil
                        promise(.success(nil))
                    }
                } receiveValue: { [weak self] url in
                    guard url != "nil" else {
                        self?.serverURL = nil
                        promise(.success(nil))
                        return
                    }
                    
                    self?.serverURL = url
                    promise(.success(url))
                }
                .store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
    }
    
    static let appstore: String = "itms-apps://itunes.apple.com/app/id1519159240"
    static let instagramToTiTi: String = "https://www.instagram.com/study_withtiti/"
    static let github: String = "https://github.com/TimerTiTi"
    
    enum WidgetInfo {
        static var calendarWidget: String {
            switch Language.current {
            case .ko: return "https://titicalendarwidgetkor.simple.ink/"
            default: return "https://titicalendarwidgeteng.simple.ink/"
            }
        }
    }
}
