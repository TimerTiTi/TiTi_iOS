//
//  LoadingIndicator.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/12/25.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

struct LoadingIndicator {
    static func showLoading(text: String? = nil) {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.last else { return }
            
            let loadingIndicatorView: UIActivityIndicatorView
            if let existedView = window.subviews.first(where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView {
                loadingIndicatorView = existedView
            } else {
                loadingIndicatorView = UIActivityIndicatorView(style: .large)
                loadingIndicatorView.backgroundColor = UIColor(named: "loadingBackgroundColor")
                loadingIndicatorView.color = .label
                loadingIndicatorView.frame = window.frame
                
                if let text = text {
                    let label = UILabel()
                    label.numberOfLines = 0
                    label.text = text
                    label.textColor = .label
                    label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
                    label.textAlignment = .center
                    label.frame = CGRect(x: 0, y: 64, width: window.frame.width, height: window.frame.height-64)

                    loadingIndicatorView.addSubview(label)
                }
                
                window.addSubview(loadingIndicatorView)
            }
            
            loadingIndicatorView.startAnimating()
        }
    }
    
    static func hideLoading() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.last else { return }
            window.subviews.filter({ $0 is UIActivityIndicatorView }).forEach { $0.removeFromSuperview() }
        }
    }
}
