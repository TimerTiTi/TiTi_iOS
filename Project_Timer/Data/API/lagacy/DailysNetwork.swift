//
//  DailysNetwork.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/16.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

final class DailysNetwork {
    private let network = Network()
    private var uploadDailysURL: String {
        let base = NetworkURL.shared.serverURL ?? "nil"
        return base + "/dailys/upload"
    }
    private var getDailysURL: String {
        let base = NetworkURL.shared.serverURL ?? "nil"
        return base + "/dailys"
    }
    
    func upload(dailys: [Daily], completion: @escaping (NetworkResult) -> Void) {
        let param = ["gmt": TimeZone.current.secondsFromGMT()]
        self.network.request(url: uploadDailysURL, method: .post, param: param, body: dailys) { result in
            completion(result)
        }
    }
    
    func get(completion: @escaping (NetworkResult) -> Void) {
        self.network.request(url: getDailysURL, method: .get) { result in
            completion(result)
        }
    }
}
