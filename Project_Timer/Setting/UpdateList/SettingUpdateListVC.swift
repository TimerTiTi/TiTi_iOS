//
//  SettingUpdateListVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/04.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit
import Combine

final class SettingUpdateListVC: UIViewController {
    static let identifier = "SettingUpdateListVC"

    @IBOutlet weak var updateList: UICollectionView!
    
    private var cancellables: Set<AnyCancellable> = []
    private var viewModel: UpdateListVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.configureViewModel()
        self.bindAll()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
            self.updateList.adjustedContentInsetDidChange()
            self.updateList.reloadData()
        }
    }
}

extension SettingUpdateListVC {
    private func configureCollectionView() {
        self.updateList.dataSource = self
        self.updateList.delegate = self
    }
    
    private func configureViewModel() {
        self.viewModel = UpdateListVM()
    }
}

extension SettingUpdateListVC {
    private func bindAll() {
        self.bindCells()
    }
    
    private func bindCells() {
        self.viewModel?.$infos
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.updateList.reloadData()
            })
            .store(in: &self.cancellables)
    }
}

extension SettingUpdateListVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.infos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UpdateInfoCell.identifier, for: indexPath) as? UpdateInfoCell else { return UICollectionViewCell() }
        guard let info = self.viewModel?.infos[safe: indexPath.item] else { return cell }
        cell.configure(with: info, superWidth: self.updateList.bounds.width)
        
        return cell
    }
}

extension SettingUpdateListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UpdateInfoCell.identifier, for: indexPath) as? UpdateInfoCell else { return .zero }
        let textHeight = cell.textLabel.frame.height
        
        return CGSize(width: self.updateList.bounds.width, height: textHeight + 79.67 - 17)
    }
}
