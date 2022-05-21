//
//  NetworkController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/05/21.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

class NetworkController {
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
