//
//  FunctionInfoListVM.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/05.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation
import Combine

final class FunctionInfoListVM {
    @Published private(set) var infos: [FunctionInfo] = []
    
    init() {
        self.configureInfos()
    }
    
    private func configureInfos() {
        var infos: [FunctionInfo] = []
        infos.append(FunctionInfo(title: "타이머", url: "https://deeply-eggplant-5ec.notion.site/1db945227c25409d874bf82e30a0523a"))
        self.infos = infos
    }
}
