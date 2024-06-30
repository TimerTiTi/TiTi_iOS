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
    private(set) var serverURL: String?
    // Combine binding
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        self.getServerURL()
            .sink { version in
                print(version ?? "nil")
            }
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
    static let developmentList: String = "https://deeply-eggplant-5ec.notion.site/TiTi-Development-List-b089afc1a4eb4cdb8c06840ca9cb1273"
    static let instagramToTiTi: String = "https://www.instagram.com/study_withtiti/"
    static let instagramToDeveloper: String = "https://www.instagram.com/dev_mindsang/"
    static let github: String = "https://github.com/TimerTiTi"
    
    enum Firestore {
        static let domain: String = Infos.FirestoreURL.value
        static let links: String = domain + "/links"
        static let youtubeLink: String = links + "/youtube"
        
        static var surveys: String {
            switch Language.current {
            case .ko: return domain + "/surveys"
            default: return domain + "/surveys_eng"
            }
        }
        
        static var titifuncs: String {
            switch Language.current {
            case .ko: return domain + "/titifuncs"
            default: return domain + "/titifuncs_eng"
            }
        }
        
        static var updates: String {
            switch Language.current {
            case .ko: return domain + "/updates?pageSize=100"
            default: return domain + "/updates_eng?pageSize=100"
            }
        }
    }
    
    enum WidgetInfo {
        static var calendarWidget: String {
            switch Language.current {
            case .ko: return "https://titicalendarwidgetkor.simple.ink/"
            default: return "https://titicalendarwidgeteng.simple.ink/"
            }
        }
    }
}
