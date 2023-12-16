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
        self.networkController.getTiTiFunctions { [weak self] result in
            switch result {
            case .success(let functionInfos):
                self?.infos = functionInfos
            case .failure(let error):
                self?.warning = error.alertMessage
            }
        }
    }
    
    private func configureYoutubeLink() {
        self.networkController.getYoutubeLink { [weak self] result in
            switch result {
            case .success(let youtubeLinkInfo):
                self?.youtubeLink = youtubeLinkInfo.url.value
            case .failure(let error):
                self?.warning = error.alertMessage
            }
        }
    }
}
