//
//  FunctionInfo.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/05.
//  Copyright © 2022 FDEE. All rights reserved.
//

import Foundation

struct FunctionInfo {
    let title: String
    let url: String
}

protocol FunctionsActionDelegate: AnyObject {
    func showWebview(url: String)
}
