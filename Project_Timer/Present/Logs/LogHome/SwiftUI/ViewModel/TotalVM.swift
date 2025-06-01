//
//  TotalVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/09/06.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Combine

final class TotalVM: ObservableObject {
    @Published var totalTime: Int = 0
    @Published var colorIndex: Int = 1
    @Published var reverseColor: Bool = false
    @Published var top5Tasks: [TaskInfo] = []

    private weak var parent: LogHomeVM?
    private var cancellables = Set<AnyCancellable>()
    
    init(parent: LogHomeVM) {
        self.parent = parent
        self.bind()
        self.updateColor()
    }
    
    private func bind() {
        parent?.$totalTime
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] totalTime in
                guard let self = self else { return }
                self.update(totalTime: totalTime)
            })
            .store(in: &self.cancellables)
    }
    
    private func update(totalTime: TotalTime) {
        self.totalTime = totalTime.totalTime
        self.colorIndex = totalTime.colorIndex
        self.top5Tasks = totalTime.top5Tasks
        self.updateColor()
    }
    
    public func updateColor() {
        colorIndex = UserDefaultsManager.get(forKey: .startColor) as? Int ?? 1
        reverseColor = UserDefaultsManager.get(forKey: .reverseColor) as? Bool ?? false
    }
}
