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
    func request<T: Encodable>(url: String, method: HTTPMethod, param: [String: Any]?, body: T?, completion: @escaping (NetworkResult) -> Void)
}

protocol TiTiFunctionsFetchable {
    func getTiTiFunctions(completion: @escaping (Result<[FunctionInfo], NetworkError>) -> Void)
}

protocol UpdateHistoryFetchable {
    func getUpdateHistorys(completion: @escaping (Result<[UpdateInfo], NetworkError>) -> Void)
}

protocol YoutubeLinkFetchable {
    func getYoutubeLink(completion: @escaping (Result<YoutubeLinkInfo, NetworkError>) -> Void)
}

protocol SurveysFetchable {
    func getSurveys(completion: @escaping (Result<[SurveyInfo], NetworkError>) -> Void)
}

// MARK: TestServer
protocol TestServerSyncLogFetchable {
    func getSyncLog(completion: @escaping (Result<SyncLog?, NetworkError>) -> Void)
}
