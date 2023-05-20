//
//  SettingNotificationVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/05/20.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit

final class SettingNotificationVC: UIViewController {
    static let identifier = "SettingNotificationVC"
    private var settings: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets.zero
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    private let viewModel = SettingNotificationVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Notification".localized()
        self.view.backgroundColor = .systemGroupedBackground
        
        self.configureUI()
        self.configureSettings()
    }
}

extension SettingNotificationVC {
    private func configureUI() {
        self.settings.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.settings)
        
        NSLayoutConstraint.activate([
            self.settings.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.settings.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.settings.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.settings.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureSettings() {
        self.settings.register(SettingListCell.self, forCellWithReuseIdentifier: SettingListCell.identifier)
        self.settings.dataSource = self
        self.settings.delegate = self
    }
}

extension SettingNotificationVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingListCell.identifier, for: indexPath) as? SettingListCell else { return .init() }
        return cell
    }
}

extension SettingNotificationVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = CGFloat(self.viewModel.cells[safe: indexPath.item]?.cellHeight ?? 55)
        
        return CGSize(width: collectionView.bounds.width, height: height)
    }
}
