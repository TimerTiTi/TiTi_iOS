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
    func request<T: Encodable>(url: String, method: HTTPMethod, body: T?, completion: @escaping (NetworkResult) -> Void)
}

protocol VersionFetchable {
    func getAppstoreVersion(completion: @escaping (NetworkStatus, String?) -> Void)
}

protocol TiTiFunctionsFetchable {
    func getTiTiFunctions(completion: @escaping (NetworkStatus, [FunctionInfo]) -> Void)
}

protocol UpdateHistoryFetchable {
    func getUpdateHistorys(completion: @escaping (NetworkStatus, [UpdateInfo]) -> Void)
}

protocol YoutubeLinkFetchable {
    func getYoutubeLink(completion: @escaping (NetworkStatus, YoutubeLinkInfo?) -> Void)
}

protocol SurveysFetchable {
    func getSurveys(completion: @escaping (NetworkStatus, [SurveyInfo]) -> Void)
}

// MARK: TestServer
protocol TestServerAuthFetchable {
    func signup(userInfo: TestUserSignupInfo, completion: @escaping (NetworkStatus, String?) -> Void)
    func login(userInfo: TestUserLoginInfo, completion: @escaping (NetworkStatus, String?) -> Void)
}

protocol TestServerDailyFetchable {
    func uploadDailys(dailys: [Daily], completion: @escaping (NetworkStatus) -> Void)
    func getDailys(completion: @escaping (NetworkStatus, [Daily]) -> Void)
}

protocol TestServerSyncLogFetchable {
    func getSyncLog(completion: @escaping (NetworkStatus, SyncLog?) -> Void)
}

protocol TestServerRecordTimesFetchable {
    func uploadRecordTimes(recordTimes: RecordTimes, completion: @escaping (NetworkStatus) -> Void)
    func getRecordTimes(completion: @escaping (NetworkStatus, RecordTimes?) -> Void)
}
