//
//  SettingSwitchListVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/05/20.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit

final class SettingSwitchListVC: UIViewController {
    static let identifier = "SettingSwitchListVC"
    
    private var settings: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets.zero
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    private let viewModel: SettingSwitchListVM
    
    init(dataSource: SettingSwitchListVM.DataSource) {
        self.viewModel = SettingSwitchListVM(isIpad: UIDevice.current.userInterfaceIdiom == .pad, dataSource: dataSource)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.viewModel.title
        self.view.backgroundColor = .systemGroupedBackground
        
        self.configureUI()
        self.configureSettings()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { [weak self] _ in
            self?.settings.collectionViewLayout.invalidateLayout()
        }
    }
}

extension SettingSwitchListVC {
    private func configureUI() {
        self.settings.translatesAutoresizingMaskIntoConstraints = false
        self.settings.backgroundColor = .clear
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

extension SettingSwitchListVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingListCell.identifier, for: indexPath) as? SettingListCell else { return .init() }
        guard let info = self.viewModel.cells[safe: indexPath.item] else { return cell }
        
        cell.configure(info: info)
        return cell
    }
}

extension SettingSwitchListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = CGFloat(self.viewModel.cells[safe: indexPath.item]?.cellHeight ?? 55)
        
        return CGSize(width: collectionView.bounds.width, height: height)
    }
}
