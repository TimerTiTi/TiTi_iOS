//
//  NetworkController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/05/21.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

final class NetworkController {
    let network: Network
    init(network: Network) {
        self.network = network
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
