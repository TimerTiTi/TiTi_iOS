//
//  NetworkController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/05/21.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

final class NetworkController {
    let network: NetworkFetchable
    init(network: NetworkFetchable) {
        self.network = network
    }
}

extension NetworkController: VersionFetchable {
    func getAppstoreVersion(completion: @escaping (Result<String, NetworkError>) -> Void) {
        self.network.request(url: NetworkURL.Firestore.lastestVersion, method: .get) { result in
            switch result.status {
            case .SUCCESS:
                guard let data = result.data,
                      let lastestVersionInfo: LastestVersionInfo = try? JSONDecoder().decode(LastestVersionInfo.self, from: data) else {
                    completion(.failure(.DECODEERROR))
                    return
                }
                #if targetEnvironment(macCatalyst)
                completion(.success(lastestVersionInfo.macOS.value))
                #else
                completion(.success(lastestVersionInfo.iOS.value))
                #endif
            default:
                completion(.failure(NetworkError.error(result)))
            }
        }
    }
}

extension NetworkController: TiTiFunctionsFetchable {
    func getTiTiFunctions(completion: @escaping (Result<[FunctionInfo], NetworkError>) -> Void) {
        self.network.request(url: NetworkURL.Firestore.titifuncs, method: .get) { result in
            switch result.status {
            case .SUCCESS:
                guard let data = result.data,
                      let functionInfos: FunctionInfos = try? JSONDecoder().decode(FunctionInfos.self, from: data) else {
                    completion(.failure(.DECODEERROR))
                    return
                }
                completion(.success(functionInfos.functionInfos))
            default:
                completion(.failure(NetworkError.error(result)))
            }
        }
    }
}

extension NetworkController: UpdateHistoryFetchable {
    func getUpdateHistorys(completion: @escaping (Result<[UpdateInfo], NetworkError>) -> Void) {
        self.network.request(url: NetworkURL.Firestore.updates, method: .get) { result in
            switch result.status {
            case .SUCCESS:
                guard let data = result.data,
                      let updateInfos: UpdateInfos = try? JSONDecoder().decode(UpdateInfos.self, from: data) else {
                    completion(.failure(.DECODEERROR))
                    return
                }
                completion(.success(updateInfos.updateInfos))
            default:
                completion(.failure(NetworkError.error(result)))
            }
        }
    }
}

extension NetworkController: YoutubeLinkFetchable {
    func getYoutubeLink(completion: @escaping (Result<YoutubeLinkInfo, NetworkError>) -> Void) {
        self.network.request(url: NetworkURL.Firestore.youtubeLink, method: .get) { result in
            switch result.status {
            case .SUCCESS:
                guard let data = result.data,
                      let youtubeLinkInfo: YoutubeLinkInfo = try? JSONDecoder().decode(YoutubeLinkInfo.self, from: data) else {
                    completion(.failure(.DECODEERROR))
                    return
                }
                completion(.success(youtubeLinkInfo))
            default:
                completion(.failure(NetworkError.error(result)))
            }
        }
    }
}

extension NetworkController: SurveysFetchable {
    func getSurveys(completion: @escaping (Result<[SurveyInfo], NetworkError>) -> Void) {
        self.network.request(url: NetworkURL.Firestore.surveys, method: .get) { result in
            switch result.status {
            case .SUCCESS:
                guard let data = result.data,
                      let surveys: SurveyInfos = try? JSONDecoder().decode(SurveyInfos.self, from: data) else {
                    completion(.failure(.DECODEERROR))
                    return
                }
                completion(.success(surveys.surveyInfos ?? []))
            default:
                completion(.failure(NetworkError.error(result)))
            }
        }
    }
}

// MARK: TestServer
extension NetworkController: TestServerAuthFetchable {
    func signup(userInfo: TestUserSignupInfo, completion: @escaping (Result<String, NetworkError>) -> Void) {
        self.network.request(url: NetworkURL.TestServer.authSignup, method: .post, param: nil, body: userInfo) { result in
            switch result.status {
            case .SUCCESS:
                guard let data = result.data,
                      let dto = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                      let token = dto["token"] as? String else {
                    completion(.failure(.DECODEERROR))
                    return
                }
                completion(.success(token))
            default:
                completion(.failure(NetworkError.error(result)))
            }
        }
    }

    func login(userInfo: TestUserLoginInfo, completion: @escaping (Result<String, NetworkError>) -> Void) {
        self.network.request(url: NetworkURL.TestServer.authLogin, method: .post, param: nil, body: userInfo) { result in
            switch result.status {
            case .SUCCESS:
                guard let data = result.data,
                      let dto = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                      let token = dto["token"] as? String else {
                    completion(.failure(.DECODEERROR))
                    return
                }
                completion(.success(token))
            default:
                if KeyChain.shared.deleteAll() {
                    UserDefaultsManager.set(to: false, forKey: .loginInTestServerV1)
                    NotificationCenter.default.post(name: KeyChain.logouted, object: nil)
                }
                completion(.failure(NetworkError.error(result)))
            }
        }
    }
}

extension NetworkController: TestServerDailyFetchable {
    func uploadDailys(dailys: [Daily], completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        let param = ["gmt": TimeZone.current.secondsFromGMT()]
        self.network.request(url: NetworkURL.TestServer.dailysUpload, method: .post, param: param, body: dailys) { result in
            switch result.status {
            case .SUCCESS:
                completion(.success(true))
            default:
                completion(.failure(NetworkError.error(result)))
            }
        }
    }
    
    func getDailys(completion: @escaping (Result<[Daily], NetworkError>) -> Void) {
        self.network.request(url: NetworkURL.TestServer.dailys, method: .get) { result in
            switch result.status {
            case .SUCCESS:
                guard let data = result.data,
                      let dailys = try? JSONDecoder.dateFormatted.decode([Daily].self, from: data) else {
                    completion(.failure(.DECODEERROR))
                    return
                }
                completion(.success(dailys))
            default:
                completion(.failure(NetworkError.error(result)))
            }
        }
    }
}


extension NetworkController: TestServerSyncLogFetchable {
    func getSyncLog(completion: @escaping (Result<SyncLog?, NetworkError>) -> Void) {
        self.network.request(url: NetworkURL.TestServer.syncLog, method: .get) { result in
            switch result.status {
            case .SUCCESS:
                if let data = result.data {
                    guard let syncLog = try? JSONDecoder.dateFormatted.decode(SyncLog.self, from: data) else {
                        completion(.failure(.DECODEERROR))
                        return
                    }
                    completion(.success(syncLog))
                } else {
                    completion(.success(nil))
                }
            default:
                completion(.failure(NetworkError.error(result)))
            }
        }
    }
}

extension NetworkController: TestServerRecordTimesFetchable {
    func uploadRecordTimes(recordTimes: RecordTimes, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        self.network.request(url: NetworkURL.TestServer.recordTime, method: .post, param: nil, body: recordTimes) { result in
            switch result.status {
            case .SUCCESS:
                completion(.success(true))
            default:
                completion(.failure(NetworkError.error(result)))
            }
        }
    }
    
    func getRecordTimes(completion: @escaping (Result<RecordTimes, NetworkError>) -> Void) {
        self.network.request(url: NetworkURL.TestServer.recordTime, method: .get) { result in
            switch result.status {
            case .SUCCESS:
                guard let data = result.data,
                      let recordTime = try? JSONDecoder.dateFormatted.decode(RecordTimes.self, from: data) else {
                    completion(.failure(.DECODEERROR))
                    return
                }
                completion(.success(recordTime))
            default:
                completion(.failure(NetworkError.error(result)))
            }
        }
    }
}
