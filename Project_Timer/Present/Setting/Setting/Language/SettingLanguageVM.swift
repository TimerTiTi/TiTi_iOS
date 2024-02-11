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
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        if Language.setted == nil {
            self.selected = .system
        } else {
            switch Language.current {
            case .ko: self.selected = .ko
            case .en: self.selected = .en
            case .zh: self.selected = .zh
            }
        }
        
        self.bindLanguage()
    }
    
    private func bindLanguage() {
        self.$selected
            .receive(on: DispatchQueue.main)
            .sink { selected in
                switch selected {
                case .system:
                    UserDefaultsManager.delete(forKey: .languageCode)
                    UserDefaults.shared.removeObject(forKey: UserDefaultsManager.Keys.languageCode.rawValue)
                default:
                    UserDefaultsManager.set(to: selected.rawValue, forKey: .languageCode)
                    UserDefaults.shared.set(selected.rawValue, forKey: UserDefaultsManager.Keys.languageCode.rawValue)
                }
            }
            .store(in: &cancellables)
    }
}
