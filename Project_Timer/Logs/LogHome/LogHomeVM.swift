//
//  LogVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/03/14.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Combine

final class LogHomeVM {
    @Published private(set) var daily: Daily = Daily()
    @Published private(set) var subjectTimes: [Int] = []
    @Published private(set) var subjectNameTimes: [(name: String, time: String)] = []
    
    func loadDaily() {
        self.daily = RecordController.shared.daily
        self.configureSubjectNameTimes()
    }
    
    private func configureSubjectNameTimes() {
        let tasks = self.daily.tasks.sorted(by: { $0.value < $1.value } )
        self.subjectNameTimes = tasks.map { ($0.key, $0.value.toTimeString) }
        self.subjectTimes = tasks.map (\.value)
    }
}
