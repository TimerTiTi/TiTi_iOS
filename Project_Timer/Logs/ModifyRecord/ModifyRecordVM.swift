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
    enum Mode {
        case modify
        case create
    }
    enum ModifyMode {
        case existingTask
        case newTask
        case none
    }
    enum Alert {
        case pastRecord
    }
    
    @Published private(set) var currentDaily: Daily {
        didSet {
            self.tasks = self.currentDaily.tasks.sorted(by: { $0.value > $1.value })
                .map { TaskInfo(taskName: $0.key, taskTime: $0.value) }
            self.timelineVM.update(daily: self.currentDaily)
            self.timeTableVM.update(daily: self.currentDaily, tasks: self.tasks)
        }
    }
    @Published private(set) var tasks: [TaskInfo] = []
    @Published private(set) var isModified: Bool = false
    @Published private(set) var modifyMode: ModifyMode = .none
    @Published private(set) var alert: Alert?
    private(set) var mode: Mode = .modify
    
    // 인터렉션 뷰에만 보여지는 내용
    @Published var selectedTask: String?
    @Published var selectedTaskHistorys: [TaskHistory] = []
    private var selectedTaskIndex: Int? {
        self.tasks.firstIndex(where: { $0.taskName == self.selectedTask })
    }
    
    let timelineVM: TimelineVM
    let timeTableVM: TimeTableVM
    private var cancellables: Set<AnyCancellable> = []
    
    var isReverseColor: Bool
    var selectedColorIndex: Int {
        let startColorIndex = UserDefaultsManager.get(forKey: .startColor) as? Int ?? 1
        let index = self.selectedTaskIndex ?? 0
        
        if isReverseColor {
            return (startColorIndex - index + 12)%12 == 0 ? 12 : (startColorIndex - index + 12)%12
        } else {
            return (startColorIndex + index + 12)%12 == 0 ? 12 : (startColorIndex + index + 12)%12
        }
    }
    var isRemoveAd: Bool = false
    var isDeleteAnimation: Bool = false
    
    init(daily: Daily, isReverseColor: Bool) {
        self.mode = .modify
        self.timelineVM = TimelineVM()
        self.timeTableVM = TimeTableVM()
        self.currentDaily = daily
        self.isReverseColor = isReverseColor
        self.tasks = self.currentDaily.tasks.sorted(by: { $0.value > $1.value })
            .map { TaskInfo(taskName: $0.key, taskTime: $0.value) }
        self.timelineVM.update(daily: self.currentDaily)
        self.timeTableVM.update(daily: self.currentDaily, tasks: self.tasks)
    }
    
    init(newDate: Date, isReverseColor: Bool) {
        self.mode = .create
        self.timelineVM = TimelineVM()
        self.timeTableVM = TimeTableVM()
        self.currentDaily = Daily(newDate: newDate)
        self.isReverseColor = isReverseColor
        self.tasks = self.currentDaily.tasks.sorted(by: { $0.value > $1.value })
            .map { TaskInfo(taskName: $0.key, taskTime: $0.value) }
        self.timelineVM.update(daily: self.currentDaily)
        self.timeTableVM.update(daily: self.currentDaily, tasks: self.tasks)
    }
}

// MARK: 편집 모드 변경
extension ModifyRecordVM {
    func changeToExistingTaskMode(task: String) {
        guard self.currentDaily.tasks[task] != nil,
              self.currentDaily.taskHistorys?[task] != nil else {
            self.alert = .pastRecord
            return
        }
        
        self.modifyMode = .existingTask
        self.selectedTask = task
        self.selectedTaskHistorys = self.currentDaily.taskHistorys?[task] ?? []
    }
    
    func changeToNewTaskMode() {
        self.modifyMode = .newTask
        self.selectedTask = nil
        self.selectedTaskHistorys = []
    }
    
    func changeToNoneMode() {
        self.modifyMode = .none
        self.selectedTask = nil
        self.selectedTaskHistorys = []
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
        if self.modifyMode == .existingTask {
            self.changeDailysTaskName(from: oldName, to: newName)
        }
    }
    
    /// 새로 추가하는 기록의 과목명을 name으로 설정
    func setNewTaskName(_ name: String) {
        // TODO: 사용자 알림 필요
        guard !self.tasks.contains(where: { $0.taskName == name }) else { return }
        self.selectedTask = name
    }

    /// 선택된 과목에 history 추가
    func addHistory(_ history: TaskHistory) {
        guard self.modifyMode != .none else { return }
        
        // TODO: 새벽 12시-4시는 다음 날짜로 처리
        // TODO: 시작시각 > 종료시각인 경우 예외처리
        self.selectedTaskHistorys.append(history)
        self.sortHistorys()
        self.isModified = true
        self.updateDailysTaskHistory()
    }
    
    /// 선택한 과목의 index번 히스토리를 newHistory로 변경
    func modifyHistory(at index: Int, to newHistory: TaskHistory) {
        guard self.modifyMode != .none,
              self.selectedTaskHistorys[index] != newHistory else { return }
        
        self.selectedTaskHistorys[index] = newHistory
        self.isModified = true
        self.updateDailysTaskHistory()
    }
    
    /// 편집 내용 로컬에 저장, dailys.json 파일 업데이트
    func save() {
        self.currentDaily.setEdited()
        RecordController.shared.modifyRecord(with: self.currentDaily)
    }
    
    /// 동일한 과목명이 이미 존재하는지 검증
    func validateNewTaskName(_ taskName: String) -> Bool {
        switch modifyMode {
        case .existingTask:
            if let selectedTask = self.selectedTask,
               selectedTask == taskName {   // 현재 과목명 그대로인 경우 중복이 아님
                return true
            } else {
                return self.currentDaily.tasks[taskName] == nil
            }
        case .newTask:
            return self.currentDaily.tasks[taskName] == nil
        default:
            return true
        }
    }
    
    /// 겹치는 시각이 없는지 검증
    func validateDate(selected: Date, currentHistory: TaskHistory) -> Bool {
        // currentHistory 이내인 경우 valid
        if (currentHistory != TaskHistory(startDate: self.currentDaily.day.zeroDate, endDate: self.currentDaily.day.zeroDate) && (currentHistory.startDate <= selected && selected <= currentHistory.endDate)) {
            return true
        }
        // 모든 taskHistory 들을 1차원 배열로 생성
        var totalHistorysOfDay: [TaskHistory] = []
        self.currentDaily.taskHistorys?.keys.forEach { key in
            if key == self.selectedTask {
                totalHistorysOfDay += self.selectedTaskHistorys
            } else {
                totalHistorysOfDay += self.currentDaily.taskHistorys?[key] ?? []
            }
        }
        guard totalHistorysOfDay.isEmpty == false else { return true }
        // start < selected < end 이면 not valid
        for idx in 0..<totalHistorysOfDay.count {
            let leftInvalid = totalHistorysOfDay[idx].startDate <= selected
            let rightInvalid = selected <= totalHistorysOfDay[idx].endDate
            
            if (leftInvalid && rightInvalid) == true {
                return false
            }
        }
        
        return true
    }
    
    /// TaskHistory 제거
    func deleteHistory(at index: Int) {
        guard self.modifyMode != .none else { return }
        self.isDeleteAnimation = true
        self.selectedTaskHistorys.remove(at: index)
        self.isModified = true
        
        self.updateDailysTaskHistory()
        if self.selectedTaskHistorys.isEmpty {
            self.changeToNoneMode()
        }
    }
    
    private func sortHistorys() {
        self.selectedTaskHistorys.sort(by: {
            var lhsHour = $0.startDate.hour
            var rhsHour = $1.startDate.hour
            
            if lhsHour < 5 { lhsHour += 24 }
            if rhsHour < 5 { rhsHour += 24 }
            
            if lhsHour != rhsHour {
                return lhsHour < rhsHour
            } else {
                return $0.startDate < $1.startDate
            }
        })
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
        guard let selectedTask = self.selectedTask else { return }
        self.currentDaily.updateTaskHistorys(of: selectedTask, with: self.selectedTaskHistorys)
    }
}
