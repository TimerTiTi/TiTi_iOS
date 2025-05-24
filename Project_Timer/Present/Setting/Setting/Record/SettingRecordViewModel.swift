//
//  SettingRecordViewModel.swift
//  Project_Timer
//
//  Created by Minsang on 5/3/25.
//  Copyright © 2025 FDEE. All rights reserved.
//

import Foundation

final class SettingRecordViewModel: ObservableObject {
    
    // MARK: State & Action
    
    @Published var resetHour: Int
    @Published var showPopup: Bool = false
    
    enum Action {
        case showInputPopup
        case changeResetHour(to: Int)
    }
    
    init() {
        resetHour = UserDefaultsManager.get(forKey: .recordResetHour) as? Int ?? 6
    }
}

// MARK: Action

extension SettingRecordViewModel {
    
    public func action(_ action: Action) {
        switch action {
        case .showInputPopup:
            showPopup = true
        case .changeResetHour(let hour):
            changeResetHour(to: hour)
        }
    }
    
    public func changeResetHour(to hour: Int) {
        resetHour = hour
        UserDefaultsManager.set(to: hour, forKey: .recordResetHour)
    }
}
