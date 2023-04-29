//
//  widgetBundle.swift
//  widget
//
//  Created by Kang Minsang on 2023/02/08.
//  Copyright © 2023 FDEE. All rights reserved.
//

import WidgetKit
import SwiftUI

@main
struct widgetBundle: WidgetBundle {
    var body: some Widget {
        widget()
        if #available(iOS 16.2, *) {
            widgetLiveActivity()
        }
    }
}
