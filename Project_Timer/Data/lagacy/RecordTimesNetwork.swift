//
//  RecordTimesAPI.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/16.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

final class RecordTimesNetwork {
    private let network = Network()
    private var url: String {
        let base = NetworkURL.shared.serverURL ?? "nil"
        return base + "/recordTime"
    }
    
    func upload(recordTimes: RecordTimes, completion: @escaping (NetworkResult) -> Void) {
        self.network.request(url: url, method: .post, param: nil, body: recordTimes) { result in
            completion(result)
        }
    }
    
    func get(completion: @escaping (NetworkResult) -> Void) {
        self.network.request(url: url, method: .get) { result in
            completion(result)
        }
    }
}
