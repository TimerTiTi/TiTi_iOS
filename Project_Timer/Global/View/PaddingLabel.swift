//
//  PaddingLabel.swift
//  Project_Timer
//
//  Created by 최수정 on 2022/08/14.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

class PaddingLabel: UILabel {
    private var padding = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

    convenience init(vertical: CGFloat, horizontal: CGFloat) {
        self.init()
        self.padding = UIEdgeInsets(top: vertical,
                                    left: horizontal,
                                    bottom: vertical,
                                    right: horizontal)
    }
    
    convenience init(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        self.init()
        self.padding = UIEdgeInsets(top: top,
                                    left: left,
                                    bottom: bottom,
                                    right: right)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        
        return contentSize
    }
}
