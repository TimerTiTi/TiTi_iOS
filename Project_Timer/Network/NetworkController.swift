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
    func getAppstoreVersion(completion: @escaping (NetworkStatus, String?) -> Void) {
        self.network.request(url: NetworkURL.appstoreVersion, method: .get) { result in
            switch result.statusCode {
            case 200:
                guard let data = result.data,
                      let appstoreVersion = try? JSONDecoder().decode(AppstoreVersion.self, from: data) else {
                    print("Decode Error: AppstoreVersion")
                    completion(.FAIL, nil)
                    return
                }
                completion(.SUCCESS, appstoreVersion.results.first?.version)
            default:
                completion(.FAIL, nil)
                return
            }
        }
    }
}

extension NetworkController: TiTiFunctionsFetchable {
    func getTiTiFunctions(completion: @escaping (NetworkStatus, [FunctionInfo]) -> Void) {
        self.network.request(url: NetworkURL.Firestore.titifuncs, method: .get) { result in
            switch result.statusCode {
            case 200:
                guard let data = result.data,
                      let functionInfos: FunctionInfos = try? JSONDecoder().decode(FunctionInfos.self, from: data) else {
                    print("Decode Error: FunctionInfos")
                    completion(.DECODEERROR, [])
                    return
                }
                completion(.SUCCESS, functionInfos.functionInfos)
            default:
                completion(.FAIL, [])
                return
            }
        }
    }
}

extension NetworkController: UpdateInfosFetchable {
    func getUpdateInfos(completion: @escaping (NetworkStatus, [UpdateInfo]) -> Void) {
        self.network.request(url: NetworkURL.Firestore.updates, method: .get) { result in
            switch result.statusCode {
            case 200:
                guard let data = result.data,
                      let updateInfos: UpdateInfos = try? JSONDecoder().decode(UpdateInfos.self, from: data) else {
                    print("Decode Error: UpdateInfos")
                    completion(.DECODEERROR, [])
                    return
                }
                completion(.SUCCESS, updateInfos.updateInfos)
            default:
                completion(.FAIL, [])
                return
            }
        }
    }
}

extension NetworkController: YoutubeLinkFetchable {
    func getYoutubeLink(completion: @escaping (NetworkStatus, YoutubeLinkInfo?) -> Void) {
        self.network.request(url: NetworkURL.Firestore.youtubeLink, method: .get) { result in
            switch result.statusCode {
            case 200:
                guard let data = result.data,
                      let youtubeLinkInfo: YoutubeLinkInfo = try? JSONDecoder().decode(YoutubeLinkInfo.self, from: data) else {
                    print("Decode Error: YoutubeLinkInfoDTO")
                    completion(.DECODEERROR, nil)
                    return
                }
                completion(.SUCCESS, youtubeLinkInfo)
            default:
                completion(.FAIL, nil)
                return
            }
        }
    }
}
