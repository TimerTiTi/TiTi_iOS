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
