//
//  UIScrollView+Extension.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/01/07.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit

extension UIScrollView {
    func scrollHorizontalToPage(frame: CGRect, to page: Int) {
        var frame: CGRect = frame
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0
        self.scrollRectToVisible(frame, animated: true)
    }
    
    func configureScrollHorizontalPage(frame: CGRect, to page: Int) {
        var frame: CGRect = frame
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0
        setContentOffset(CGPoint(x: frame.origin.x, y: frame.origin.y), animated: false)
    }
}
