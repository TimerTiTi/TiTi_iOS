//
//  Icons.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/11.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit

enum Icons: String {
    case TickCircle
    case Close18
    
    var value: UIImage { UIImage(named: self.rawValue)! }
}
