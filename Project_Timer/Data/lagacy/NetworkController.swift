//
//  NetworkController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/05/21.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Alamofire

protocol SurveysFetchable {
    func getSurveys_lagacy(completion: @escaping (Result<[SurveyInfo], NetworkError>) -> Void)
}

final class NetworkController {
    let network: Network
    init(network: Network) {
        self.network = network
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
