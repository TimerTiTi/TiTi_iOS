//
//  NetworkController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/05/21.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Alamofire

protocol TiTiFunctionsFetchable {
    func getTiTiFunctions_lagacy(completion: @escaping (Result<[FunctionInfo], NetworkError>) -> Void)
}

protocol UpdateHistoryFetchable {
    func getUpdateHistorys_lagacy(completion: @escaping (Result<[UpdateHistoryInfo], NetworkError>) -> Void)
}

protocol YoutubeLinkFetchable {
    func getYoutubeLink_lagacy(completion: @escaping (Result<YoutubeLinkResponse, NetworkError>) -> Void)
}

protocol SurveysFetchable {
    func getSurveys_lagacy(completion: @escaping (Result<[SurveyInfo], NetworkError>) -> Void)
}

final class NetworkController {
    let network: Network
    init(network: Network) {
        self.network = network
    }
}

extension NetworkController: TiTiFunctionsFetchable {
    func getTiTiFunctions_lagacy(completion: @escaping (Result<[FunctionInfo], NetworkError>) -> Void) {
        self.network.request(url: NetworkURL.Firestore.titifuncs, method: .get) { result in
            switch result.status {
            case .SUCCESS:
                guard let data = result.data,
                      let functionInfos: FunctionResponse = try? JSONDecoder().decode(FunctionResponse.self, from: data) else {
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
    func getUpdateHistorys_lagacy(completion: @escaping (Result<[UpdateHistoryInfo], NetworkError>) -> Void) {
        self.network.request(url: NetworkURL.Firestore.updates, method: .get) { result in
            switch result.status {
            case .SUCCESS:
                guard let data = result.data,
                      let updateInfos: UpdateHistoryResponse = try? JSONDecoder().decode(UpdateHistoryResponse.self, from: data) else {
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
    func getYoutubeLink_lagacy(completion: @escaping (Result<YoutubeLinkResponse, NetworkError>) -> Void) {
        self.network.request(url: NetworkURL.Firestore.youtubeLink, method: .get) { result in
            switch result.status {
            case .SUCCESS:
                guard let data = result.data,
                      let youtubeLinkInfo: YoutubeLinkResponse = try? JSONDecoder().decode(YoutubeLinkResponse.self, from: data) else {
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
    func getSurveys_lagacy(completion: @escaping (Result<[SurveyInfo], NetworkError>) -> Void) {
        self.network.request(url: NetworkURL.Firestore.surveys, method: .get) { result in
            switch result.status {
            case .SUCCESS:
                guard let data = result.data,
                      let surveys: SurveyResponse = try? JSONDecoder().decode(SurveyResponse.self, from: data) else {
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
