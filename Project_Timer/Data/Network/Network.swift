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
        Session.default.request(url, method: method, interceptor: NetworkInterceptor()) { $0.timeoutInterval = 10 }
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
        
        Session.default.request(url, method: method, parameters: body, encoder: JSONParameterEncoder.dateFormatted, interceptor: NetworkInterceptor()) { $0.timeoutInterval = 10 }
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
            print("[Network] Fail: No Status Code, \(String(describing: response.error))")
            return NetworkResult(status: response.error?.isRequestRetryError == true ? .FAIL : .TIMEOUT, data: nil)
        }
        
        let status = NetworkStatus.status(statusCode)
        
        guard let data = response.data else {
            print("[Network] Warning(\(statusCode)): No Data")
            return NetworkResult(status: status, data: nil)
        }
        
        // server로부터 받은 data가 'null' 값인 경우 추가처리
        if String(data: data, encoding: .utf8) == "null" {
            print("[Network] Warning(\(statusCode)): null")
            return NetworkResult(status: status, data: nil)
        }
        
        if Infos.isDevMode {
            print("[Network] url: \(String(describing: response.request?.url))")
            print("[Network] statusCode: \(statusCode)")
            print("[Network] data: \(String(data: data, encoding: .utf8)!)")
        }
        
        return NetworkResult(status: status, data: data)
    }
}
