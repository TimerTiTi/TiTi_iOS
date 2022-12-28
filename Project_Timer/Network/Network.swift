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
        Session.default.request(url, method: method, interceptor: NetworkInterceptor())
            .validate()
            .response { response in
                completion(self.configureNetworkResult(response: response))
            }
            .resume()
    }
    
    func request<T: Encodable>(url: String, method: HTTPMethod, param: [String: Any]?, body: T, completion: @escaping (NetworkResult) -> Void) {
        var url = url
        if let param = param {
            var components = URLComponents(string: url)
            components?.queryItems = param.map({ key, value in URLQueryItem(name: key, value: "\(value)")})
            if let urlWithQuery = components?.url?.absoluteString {
                url = urlWithQuery
            }
        }
        
        Session.default.request(url, method: method, parameters: body, encoder: JSONParameterEncoder.dateFormatted, interceptor: NetworkInterceptor())
            .validate()
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
            return NetworkResult(data: nil, status: .FAIL)
        }
        
        guard let data = response.data else {
            print("Network Fail \(statusCode): No Data, \(String(describing: response.data))")
            return NetworkResult(data: nil, status: NetworkStatus.status(statusCode))
        }
        
        return NetworkResult(data: data, status: NetworkStatus.status(statusCode))
    }
}
