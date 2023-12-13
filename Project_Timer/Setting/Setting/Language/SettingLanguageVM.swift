//
//  SettingLanguageVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/13.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation
import Combine

final class SettingLanguageVM: ObservableObject {
    @Published var selected: SettingLanguageListView.language
    
    init() {
        // MARK: UserDefaults 확인 필요
        self.selected = .system
    }
}
