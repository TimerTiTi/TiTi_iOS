//
//  WeekSmallVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/09/06.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Combine

final class WeekSmallVM: ObservableObject {
    @Published var totalTime: Int = 0
    @Published var maxTime: Int = 0
    @Published var colorIndex: Int = 1
    
    private weak var parent: LogHomeVM?
    private var cancellables = Set<AnyCancellable>()
    
    init(parent: LogHomeVM) {
        self.parent = parent
        self.bind()
        self.updateColor()
    }
    
    private func bind() {
        parent?.$weekSmallTime  
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] weekSmallTime in
                guard let self = self else { return }
                self.update(weekSmallTime: weekSmallTime)
            })
            .store(in: &self.cancellables)
    }
    
    private func update(weekSmallTime: WeekSmallTime) {
        self.totalTime = weekSmallTime.totalTime
        self.maxTime = weekSmallTime.maxTime
        self.colorIndex = weekSmallTime.colorIndex
    }
    
    public func updateColor() {
        self.colorIndex = UserDefaultsManager.get(forKey: .startColor) as? Int ?? 1
    }
}
