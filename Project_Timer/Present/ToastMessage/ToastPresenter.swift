//
//  ToastData.swift
//  Project_Timer
//
//  Created by Ryeong on 7/1/24.
//  Copyright © 2024 FDEE. All rights reserved.
//

import Foundation

final class ToastPresenter: ObservableObject {
    @Published var isPresenting: Bool {
        willSet {
            /// UIKit에서 사용하기 위한 관찰자
            NotificationCenter.default.post(name: Notification.Name("updatedIsPresenting"), object: nil, userInfo: ["newValue": newValue])
        }
    }
    
    init(isPresenting: Bool = false) {
        self.isPresenting = isPresenting
    }
}
