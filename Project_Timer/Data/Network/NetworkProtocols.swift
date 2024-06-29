//
//  NetworkProtocols.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/05/21.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Alamofire

protocol TiTiFunctionsFetchable {
    func getTiTiFunctions_lagacy(completion: @escaping (Result<[FunctionInfo], NetworkError>) -> Void)
}

protocol UpdateHistoryFetchable {
    func getUpdateHistorys_lagacy(completion: @escaping (Result<[UpdateHistoryInfo], NetworkError>) -> Void)
}

protocol YoutubeLinkFetchable {
    func getYoutubeLink_lagacy(completion: @escaping (Result<YoutubeLinkResponse, NetworkError>) -> Void)
}

protocol SurveysFetchable {
    func getSurveys_lagacy(completion: @escaping (Result<[SurveyInfo], NetworkError>) -> Void)
}
