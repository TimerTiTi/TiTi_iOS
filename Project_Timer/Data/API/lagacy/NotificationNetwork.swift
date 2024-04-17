//
//  NotificationNetwork.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/17.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

final class NotificationNetwork {
    private let network = Network()
    private var url: String {
        let base = Infos.FirestoreURL.value
        let path = "/notification"
        switch Language.current {
        case .ko: return base + path + "/ko"
        case .en: return base + path + "/en"
        case .zh: return base + path + "/zh"
        }
    }
    
    func get(completion: @escaping (NetworkResult) -> Void) {
        self.network.request(url: url, method: .get) { result in
            completion(result)
        }
    }
}
