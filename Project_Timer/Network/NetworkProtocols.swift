//
//  NetworkProtocols.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/05/21.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkFetchable {
    func request(url: String, method: HTTPMethod, completion: @escaping (NetworkResult) -> Void)
}

protocol VersionFetchable {
    func getAppstoreVersion(completion: @escaping (NetworkStatus, String?) -> Void)
}

protocol TiTiFunctionsFetchable {
    func getTiTiFunctions(completion: @escaping (NetworkStatus, [FunctionInfo]) -> Void)
}

protocol UpdateInfosFetchable {
    func getUpdateInfos(completion: @escaping (NetworkStatus, [UpdateInfo]) -> Void)
}
