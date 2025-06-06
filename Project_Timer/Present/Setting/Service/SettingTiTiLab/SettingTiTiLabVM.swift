//
//  SettingTiTiLabVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/05.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Combine

final class SettingTiTiLabVM {
    let getSurveysUseCase: GetSurveysUseCase
    @Published private(set) var infos: [SurveyInfo] = []
    @Published private(set) var warning: (title: String, text: String)?
    @Published private(set) var stopLoading: Bool = false
    // Combine binding
    private var cancellables = Set<AnyCancellable>()
    
    init(getSurveysUseCase: GetSurveysUseCase) {
        self.getSurveysUseCase = getSurveysUseCase
        self.configureInfos()
    }
    
    private func configureInfos() {
        self.getSurveysUseCase.execute()
            .sink { [weak self] completion in
                if case .failure(let networkError) = completion {
                    print("ERROR", #function, networkError)
                    FirebaseAnalytics.log(DebugEvent.debug_firestoreFail(screen: "TiTiLab", reason: String(networkError.localizedDescription.prefix(100))))
                    self?.stopLoading = true
                }
            } receiveValue: { [weak self] surveyInfos in
                self?.infos = surveyInfos
            }
            .store(in: &self.cancellables)
    }
}
