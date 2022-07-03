//
//  Network.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/05/21.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Alamofire

struct Network: NetworkFetchable {
    func request(url: String, method: HTTPMethod, completion: @escaping (NetworkResult) -> Void) {
//        print("network request: \(url)")
        AF.request(url, method: method)
            .response { response in
                completion(self.configureNetworkResult(response: response))
            }
            .resume()
    }
}

extension Network {
    private func configureNetworkResult(response: AFDataResponse<Data?>) -> NetworkResult {
        guard let statusCode = response.response?.statusCode else {
            print("Network Fail: No Status Code, \(String(describing: response.error))")
            return NetworkResult(data: nil, statusCode: nil)
        }
        
        guard let data = response.data else {
            print("Network Fail \(statusCode): No Data, \(String(describing: response.data))")
            return NetworkResult(data: nil, statusCode: statusCode)
        }
        
        return NetworkResult(data: data, statusCode: statusCode)
    }
}
