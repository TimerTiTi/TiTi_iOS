//
//  AppVersionAPI.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/03.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

final class AppVersionAPI {
    private let network = Network()
    private var latestVersionURL: String {
        let base = Infos.FirestoreURL.value
        #if targetEnvironment(macCatalyst)
        return base + "/version/macos"
        #else
        return base + "/version/ios"
        #endif
    }
    
    func getAppLatestVersion(completion: @escaping (NetworkResult) -> Void) {
        self.network.request(url: latestVersionURL, method: .get) { result in
            completion(result)
        }
    }
}
