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
    
    private func decoded<T: Decodable>(_ type: T.Type, from data: Data) -> T? {
        do {
            let decoded = try JSONDecoder.dateFormatted.decode(type, from: data)
            return decoded
        } catch {
            print("Decode \(T.self) failed. \(error)")
            return nil
        }
    }
}

extension NetworkController: VersionFetchable {
    func getAppstoreVersion(completion: @escaping (NetworkStatus, String?) -> Void) {
        self.network.request(url: NetworkURL.Firestore.lastestVersion, method: .get) { result in
            switch result.status {
            case .SUCCESS:
                guard let data = result.data,
                      let lastestVersionInfo: LastestVersionInfo = try? JSONDecoder().decode(LastestVersionInfo.self, from: data) else {
                    print("Decode Error: LastestVersionInfo")
                    completion(.DECODEERROR, nil)
                    return
                }
                completion(.SUCCESS, lastestVersionInfo.version.value)
            default:
                completion(result.status, nil)
                return
            }
        }
    }
}

extension NetworkController: TiTiFunctionsFetchable {
    func getTiTiFunctions(completion: @escaping (NetworkStatus, [FunctionInfo]) -> Void) {
        self.network.request(url: NetworkURL.Firestore.titifuncs, method: .get) { result in
            switch result.status {
            case .SUCCESS:
                guard let data = result.data,
                      let functionInfos: FunctionInfos = try? JSONDecoder().decode(FunctionInfos.self, from: data) else {
                    print("Decode Error: FunctionInfos")
                    completion(.DECODEERROR, [])
                    return
                }
                completion(.SUCCESS, functionInfos.functionInfos)
            default:
                completion(result.status, [])
                return
            }
        }
    }
}

extension NetworkController: UpdateHistoryFetchable {
    func getUpdateHistorys(completion: @escaping (NetworkStatus, [UpdateInfo]) -> Void) {
        self.network.request(url: NetworkURL.Firestore.updates, method: .get) { result in
            switch result.status {
            case .SUCCESS:
                guard let data = result.data,
                      let updateInfos: UpdateInfos = try? JSONDecoder().decode(UpdateInfos.self, from: data) else {
                    print("Decode Error: UpdateInfos")
                    completion(.DECODEERROR, [])
                    return
                }
                completion(.SUCCESS, updateInfos.updateInfos)
            default:
                completion(result.status, [])
                return
            }
        }
    }
}

extension NetworkController: YoutubeLinkFetchable {
    func getYoutubeLink(completion: @escaping (NetworkStatus, YoutubeLinkInfo?) -> Void) {
        self.network.request(url: NetworkURL.Firestore.youtubeLink, method: .get) { result in
            switch result.status {
            case .SUCCESS:
                guard let data = result.data,
                      let youtubeLinkInfo: YoutubeLinkInfo = try? JSONDecoder().decode(YoutubeLinkInfo.self, from: data) else {
                    print("Decode Error: YoutubeLinkInfoDTO")
                    completion(.DECODEERROR, nil)
                    return
                }
                completion(.SUCCESS, youtubeLinkInfo)
            default:
                completion(result.status, nil)
                return
            }
        }
    }
}

extension NetworkController: SurveysFetchable {
    func getSurveys(completion: @escaping (NetworkStatus, [SurveyInfo]) -> Void) {
        self.network.request(url: NetworkURL.Firestore.surveys, method: .get) { result in
            switch result.status {
            case .SUCCESS:
                guard let data = result.data,
                      let surveys: SurveyInfos = try? JSONDecoder().decode(SurveyInfos.self, from: data) else {
                    print("Decode Error: SurveyInfos")
                    completion(.DECODEERROR, [])
                    return
                }
                completion(.SUCCESS, surveys.surveyInfos ?? [])
            default:
                completion(result.status, [])
                return
            }
        }
    }
}

// MARK: TestServer
extension NetworkController: TestServerAuthFetchable {
    func signup(userInfo: TestUserSignupInfo, completion: @escaping (NetworkStatus, String?) -> Void) {
        self.network.request(url: NetworkURL.TestServer.authSignup, method: .post, param: nil, body: userInfo) { result in
            switch result.status {
            case .SUCCESS:
                guard let data = result.data,
                      let dto = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                      let token = dto["token"] as? String else {
                    print("Decode Error: signup")
                    completion(.DECODEERROR, nil)
                    return
                }
                completion(.SUCCESS, token)
            default:
                completion(result.status, nil)
                return
            }
        }
    }

    func login(userInfo: TestUserLoginInfo, completion: @escaping (NetworkStatus, String?) -> Void) {
        self.network.request(url: NetworkURL.TestServer.authLogin, method: .post, param: nil, body: userInfo) { result in
            switch result.status {
            case .SUCCESS:
                guard let data = result.data,
                      let dto = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                      let token = dto["token"] as? String else {
                    print("Decode Error: signup")
                    completion(.DECODEERROR, nil)
                    return
                }
                completion(.SUCCESS, token)
            case.FAIL:
                if KeyChain.shared.deleteAll() {
                    UserDefaultsManager.set(to: false, forKey: .loginInTestServerV1)
                    NotificationCenter.default.post(name: KeyChain.logouted, object: nil)
                }
                completion(.FAIL, nil)
            default:
                completion(result.status, nil)
                return
            }
        }
    }
}

extension NetworkController: TestServerDailyFetchable {
    func uploadDailys(dailys: [Daily], completion: @escaping (NetworkStatus) -> Void) {
        let param = ["gmt": TimeZone.current.secondsFromGMT()]
        self.network.request(url: NetworkURL.TestServer.dailysUpload, method: .post, param: param, body: dailys) { result in
            completion(result.status)
        }
    }
    
    func getDailys(completion: @escaping (NetworkStatus, [Daily]) -> Void) {
        self.network.request(url: NetworkURL.TestServer.dailys, method: .get) { [weak self] result in
            switch result.status {
            case .SUCCESS:
                guard let data = result.data,
                      let dailys = self?.decoded([Daily].self, from: data) else {
                    completion(.DECODEERROR, [])
                    return
                }
                completion(.SUCCESS, dailys)
            default:
                completion(result.status, [])
            }
        }
    }
}


extension NetworkController: TestServerSyncLogFetchable {
    func getSyncLog(completion: @escaping (NetworkStatus, SyncLog?) -> Void) {
        self.network.request(url: NetworkURL.TestServer.syncLog, method: .get) { [weak self] result in
            switch result.status {
            case .SUCCESS:
                guard let data = result.data else { return }
                let syncLog = self?.decoded(SyncLog.self, from: data)
                completion(.SUCCESS, syncLog)
            default:
                completion(result.status, nil)
            }
        }
    }
}

extension NetworkController: TestServerRecordTimesFetchable {
    func uploadRecordTimes(recordTimes: RecordTimes, completion: @escaping (NetworkStatus) -> Void) {
        self.network.request(url: NetworkURL.TestServer.recordTime, method: .post, param: nil, body: recordTimes) { result in
            completion(result.status)
        }
    }
    
    func getRecordTimes(completion: @escaping (NetworkStatus, RecordTimes?) -> Void) {
        self.network.request(url: NetworkURL.TestServer.recordTime, method: .get) { [weak self] result in
            switch result.status {
            case .SUCCESS:
                guard let data = result.data,
                      let recordTime = self?.decoded(RecordTimes.self, from: data) else {
                    completion(.DECODEERROR, nil)
                    return
                }
                completion(.SUCCESS, recordTime)
            default:
                completion(result.status, nil)
            }
        }
    }
}
