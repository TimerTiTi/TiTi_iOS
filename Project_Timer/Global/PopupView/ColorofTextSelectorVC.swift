//
//  ColorofTextSelectorVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/10/11.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

typealias TextColorHandler = (Bool) -> Void

final class ColorofTextSelectorVC: UIViewController {
    static let identifier = "ColorofTextSelectorVC"
    
    private var handler: TextColorHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configure(handler: @escaping TextColorHandler) {
        self.handler = handler
    }
    
    @IBAction func selectWhite(_ sender: Any) {
        self.handler?(true)
    }
    
    @IBAction func selectBlack(_ sender: Any) {
        self.handler?(false)
    }
}
