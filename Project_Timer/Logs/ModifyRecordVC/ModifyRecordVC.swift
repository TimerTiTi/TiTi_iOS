//
//  ModifyRecordVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/08/13.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class ModifyRecordVC: UIViewController {
    static let identifier = "ModifyRecordVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ModifyRecordVC"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

}
