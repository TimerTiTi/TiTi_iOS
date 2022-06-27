//
//  SingleTimeLabelViewModel.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/06/24.
//  Copyright © 2022 FDEE. All rights reserved.
//

import SwiftUI

class SingleTimeLabelViewModel: ObservableObject {
    let uuid: UUID
    @Published var value: Int
    private var showAnimation: Bool
    
    init(val: Int, showAnimation: Bool) {
        self.uuid = UUID()
        self.value = val
        self.showAnimation = showAnimation
    }
    
    func update(_ val: Int) {
        if showAnimation {
            withAnimation(.easeInOut(duration: 0.4)) {
                self.value = val
            }
        } else {
            self.value = val
        }
    }
}
