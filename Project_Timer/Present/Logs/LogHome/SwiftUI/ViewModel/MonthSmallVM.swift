//
//  MonthSmallVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/09/06.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Combine

final class MonthSmallVM: ObservableObject {
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
        parent?.$monthTime
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] monthTime in
                guard let self = self else { return }
                self.update(monthTime: monthTime)
            })
            .store(in: &self.cancellables)
    }
    
    private func update(monthTime: MonthTime) {
        self.totalTime = monthTime.totalTime
        self.maxTime = monthTime.maxTime
        self.colorIndex = monthTime.colorIndex
    }
    
    public func updateColor() {
        self.colorIndex = UserDefaultsManager.get(forKey: .startColor) as? Int ?? 1
    }
}
