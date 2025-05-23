//
//  BaseBottomSheetVC.swift
//  Project_Timer
//
//  Created by Minsang on 5/11/25.
//  Copyright © 2025 FDEE. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class BaseBottomSheetVC: UIViewController {
    
    private let isDismissEnable: Bool
    private var dimmedBackgroundView: UIView!
    private var container: UIView!
    
    init(isDismissEnable: Bool = true) {
        self.isDismissEnable = isDismissEnable
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureActions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.presentBottomSheet()
    }
    
    private func configureUI() {
        self.view.backgroundColor = .clear
        
        self.dimmedBackgroundView = UIView().then {
            self.view.addSubview($0)
            $0.backgroundColor = .black.withAlphaComponent(0.4)
            $0.alpha = 0
            $0.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        self.container = UIView().then {
            self.view.addSubview($0)
            $0.backgroundColor = .clear
            $0.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalToSuperview().offset(UIScreen.main.bounds.height)
            }
        }
    }
    
    private func configureActions() {
        guard isDismissEnable else { return }
        dimmedBackgroundView.tapGesture { [weak self] in
            self?.dismissBottomSheet()
        }
    }
    
    /// ViewDidLoad 시점에 호출하여 container 내 content 추가
    public func addContent(_ content: UIView) {
        container.addSubview(content)
        content.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func presentBottomSheet() {
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.4, animations: {
            self.dimmedBackgroundView.alpha = 1
            self.container.snp.updateConstraints { make in
                make.bottom.equalToSuperview()
            }
            
            self.view.layoutIfNeeded()
        })
    }
    
    func dismissBottomSheet() {
        self.container.snp.updateConstraints { make in
            make.bottom.equalToSuperview().offset(UIScreen.main.bounds.height)
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.dimmedBackgroundView.alpha = 0
            
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
    }
}
