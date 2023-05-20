//
//  SettingFunctionsListVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/05.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Combine

typealias FunctionInfoFetchable = (TiTiFunctionsFetchable & YoutubeLinkFetchable)

final class SettingFunctionsListVM {
    private let networkController: FunctionInfoFetchable
    @Published private(set) var infos: [FunctionInfo] = []
    @Published private(set) var warning: (title: String, text: String)?
    private(set) var youtubeLink: String?
    
    init(networkController: FunctionInfoFetchable) {
        self.networkController = networkController
        self.configureInfos()
        self.configureYoutubeLink()
    }
    
    private func configureInfos() {
        self.networkController.getTiTiFunctions { [weak self] status, infos in
            switch status {
            case .SUCCESS:
                self?.infos = infos
            case .DECODEERROR:
                self?.warning = (title: "네트워크 에러", text: "최신 버전으로 업데이트 해주세요")
            default:
                self?.warning = (title: "네트워크 에러", text: "네트워크를 확인 후 다시 시도해주세요")
            }
        }
    }
    
    private func configureYoutubeLink() {
        self.networkController.getYoutubeLink { [weak self] status, info in
            switch status {
            case .SUCCESS:
                guard let info = info else {
                    self?.warning = (title: "네트워크 에러", text: "네트워크를 확인 후 다시 시도해주세요")
                    return
                }
                self?.youtubeLink = info.url.value
            case .DECODEERROR:
                self?.warning = (title: "네트워크 에러", text: "최신 버전으로 업데이트 해주세요")
            default:
                self?.warning = (title: "네트워크 에러", text: "네트워크를 확인 후 다시 시도해주세요")
            }
        }
    }
}
