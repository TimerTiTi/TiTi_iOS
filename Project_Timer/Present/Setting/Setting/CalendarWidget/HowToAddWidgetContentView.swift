//
//  HowToAddWidgetContentView.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/05/26.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit

final class HowToAddWidgetContentView: UIView {
    private var stepLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.HGGGothicssiP80g(size: 20)
        label.textColor = .lightGray
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    private var descriptionlabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.HGGGothicssiP60g(size: 17)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    convenience init(step: Int, description: String, imageName: String) {
        self.init(frame: CGRect())
        self.stepLabel.text = "STEP \(step)"
        self.descriptionlabel.text = description
        self.imageView.image = UIImage(named: imageName)
        
        self.configure()
    }
    
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.stepLabel)
        NSLayoutConstraint.activate([
            self.stepLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.stepLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8)
        ])
        
        self.addSubview(self.descriptionlabel)
        NSLayoutConstraint.activate([
            self.descriptionlabel.topAnchor.constraint(equalTo: self.stepLabel.bottomAnchor, constant: 0),
            self.descriptionlabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            self.descriptionlabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        ])
        
        self.addSubview(self.imageView)
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.descriptionlabel.bottomAnchor, constant: 8),
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor, multiplier: 1),
            self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
