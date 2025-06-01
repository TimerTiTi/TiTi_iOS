//
//  DailyVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/09/13.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Combine

final class DailyVM: ObservableObject {
    @Published var day: Date = Date()
    @Published var daily: Daily?
    @Published var times: [TimeBlock] = []
    @Published var color1Index: Int = 2
    @Published var color2Index: Int = 1
    
    private weak var parent: LogHomeVM?
    private var cancellables = Set<AnyCancellable>()
    
    init(parent: LogHomeVM) {
        self.parent = parent
        self.bind()
        self.updateColor()
        self.resetTimes()
    }
    
    private func bind() {
        parent?.$daily
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] daily in
                guard let self = self else { return }
                self.update(daily: daily)
            })
            .store(in: &self.cancellables)
    }
    
    private func update(daily: Daily?) {
        self.day = daily?.day ?? Date()
        self.daily = daily
        guard let timeline = daily?.timeline else {
            self.resetTimes()
            return
        }
        
        self.times = (5...28).map { index in
            TimeBlock(id: index%24, sumTime: timeline[index%24])
        }
        self.updateColor()
    }

    public func updateColor() {
        let userColorIndex = UserDefaultsManager.get(forKey: .startColor) as? Int ?? 1
        let isReverseColor = UserDefaultsManager.get(forKey: .reverseColor) as? Bool ?? false
        let offset = isReverseColor ? -1 : 1
        let resultColorIndex = (userColorIndex+offset+12)%12

        self.color1Index = resultColorIndex == 0 ? 12 : resultColorIndex
        self.color2Index = userColorIndex
    }
    
    private func resetTimes() {
        self.times = (5...28).map { TimeBlock(id: $0%24, sumTime: 0) }
    }
}
