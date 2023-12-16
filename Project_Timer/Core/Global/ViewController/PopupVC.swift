//
//  PopupVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/16.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit

class PopupVC: UIViewController {
    private var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .coverVertical
        modalPresentationStyle = .overFullScreen
    }
    
    required public init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let presentingViewController else { return }
        presentingViewController.view.addSubview(dimmedView)
        
        dimmedView.frame = self.view.frame
        
        UIView.animate(withDuration: 0.3) {
            self.dimmedView.alpha = 0.4
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIView.animate(withDuration: 0.3) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dimmedView.removeFromSuperview()
        }
    }
}
