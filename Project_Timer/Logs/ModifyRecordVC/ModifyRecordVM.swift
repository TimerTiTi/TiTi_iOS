//
//  ModifyRecordVM.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/08/14.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Combine

final class ModifyRecordVM {
    enum ModifyMode {
        case existingTask
        case newTask
        case none
    }
    
    @Published private(set) var currentDaily: Daily
    @Published private(set) var tasks: [TaskInfo] = []
    @Published private(set) var isModified: Bool = false
    @Published private(set) var mode: ModifyMode = .none
    
    // 인터렉션 뷰에만 보여지는 내용
    @Published var selectedTask: String?
    @Published var selectedTaskHistorys: [TaskHistory]?
    
    let timelineVM: TimelineVM
    private var cancellables: Set<AnyCancellable> = []
    
    init(daily: Daily) {
        self.currentDaily = daily
        self.timelineVM = TimelineVM()
        
        self.$currentDaily
            .receive(on: DispatchQueue.main)
            .sink { [weak self] daily in
                self?.timelineVM.update(daily: daily)
                self?.tasks = daily.tasks.sorted(by: { $0.value > $1.value })
                    .map { TaskInfo(taskName: $0.key, taskTime: $0.value) }
            }
            .store(in: &self.cancellables)
    }
}

// MARK: 편집 모드 변경
extension ModifyRecordVM {
    func changeToExistingTaskMode(task: String) {
        guard self.currentDaily.tasks[task] != nil else { return }
        
        self.mode = .existingTask
        self.selectedTask = task
        self.selectedTaskHistorys = self.currentDaily.taskHistorys?[task]
    }
    
    func changeToNewTaskMode() {
        self.mode = .newTask
        self.selectedTask = nil
        self.selectedTaskHistorys = []
    }
    
    func changeToNoneMode() {
        self.mode = .none
        self.selectedTask = nil
        self.selectedTaskHistorys = nil
    }
    
    func reset() {
        self.isModified = false
        self.changeToNoneMode()
    }
}

// MARK: 기록 수정 관련 메소드
extension ModifyRecordVM {
    /// 선택된 Task의 이름을 newName으로 변경
    func changeTaskName(to newName: String) {
        guard let oldName = selectedTask,
              oldName != newName,
              self.currentDaily.tasks[newName] == nil else { return }
        
        // TODO: 기존에 있는 테스크명인 경우 사용자 알림 필요
        self.selectedTask = newName
        self.isModified = true
        
        // 기록 추가 모드가 아닌 경우, 그래프에도 반영하기 위해 Daily 업데이트
        if self.mode == .existingTask {
            self.changeDailysTaskName(from: oldName, to: newName)
        }
    }
    
    /// 새로 추가하는 기록의 과목명을 name으로 설정
    func setNewTaskName(_ name: String) {
        self.selectedTask = name
    }

    /// 선택된 과목에 history 추가
    func addHistory(_ history: TaskHistory) {
        guard self.mode != .none else { return }
        
        // TODO: 새벽 12시-4시는 다음 날짜로 처리
        // TODO: 시작시각 > 종료시각인 경우 예외처리
        self.selectedTaskHistorys?.append(history)
        self.selectedTaskHistorys?.sort(by: { $0.startDate < $1.startDate })
        self.isModified = true
        
        // 기록 추가 모드가 아닌 경우, 그래프에도 반영하기 위해 Daily 업데이트
        if self.mode == .existingTask {
            self.updateDailysTaskHistory()
        }
    }
    
    /// 선택한 과목의 index번 히스토리를 newHistory로 변경
    func modifyHistory(at index: Int, to newHistory: TaskHistory) {
        guard self.mode != .none,
              self.selectedTaskHistorys?[index] != newHistory else { return }
        
        self.selectedTaskHistorys?[index] = newHistory
        self.isModified = true
        
        // 기록 추가 모드가 아닌 경우, 그래프에도 반영하기 위해 Daily 업데이트
        if self.mode == .existingTask {
            self.updateDailysTaskHistory()
        }
    }
    
    /// 편집 내용 로컬에 저장, dailys.json 파일 업데이트
    func save() {
        // TODO: daily.json도 업데이트 필요?
        RecordController.shared.modifyRecord(with: self.currentDaily)
    }
}

// MARK: 데일리 수정
extension ModifyRecordVM {
    /// oldName이라는 과목의 이름을 newName으로 변경
    private func changeDailysTaskName(from oldName: String, to newName: String) {
        self.currentDaily.changeTaskName(from: oldName, to: newName)
    }
    
    /// 현재 인터렉션 뷰에서 편집 중인 내용을 Daily에도 반영
    func updateDailysTaskHistory() {
        guard let selectedTask = self.selectedTask,
              let selectedTaskHistorys = self.selectedTaskHistorys else { return }
        self.currentDaily.updateTaskHistorys(of: selectedTask, with: selectedTaskHistorys)
    }
}
