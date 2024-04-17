//
//  ServerURLAPI.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/15.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

final class ServerURLAPI {
    private let network = Network()
    private var url: String {
        let base = Infos.FirestoreURL.value
        return base + "/server/url"
    }
    
    func get(completion: @escaping (NetworkResult) -> Void) {
        self.network.request(url: url, method: .get) { result in
            completion(result)
        }
    }
}
