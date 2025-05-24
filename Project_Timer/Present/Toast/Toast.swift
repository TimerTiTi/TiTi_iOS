//
//  Toast.swift
//  Project_Timer
//
//  Created by Minsang on 5/3/25.
//  Copyright © 2025 FDEE. All rights reserved.
//

import Foundation
import SwiftUI

enum Toast {
    case newRecord(date: String)
}

protocol ToastView: View {
    var height: CGFloat { get }
    var topConstraint: CGFloat { get }
}
