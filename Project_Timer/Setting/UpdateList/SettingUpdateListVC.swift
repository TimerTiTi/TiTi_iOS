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

    @IBOutlet weak var updateLists: UICollectionView!
    
    private var cancellables: Set<AnyCancellable> = []
    private var viewModel: UpdateListVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.configureViewModel()
        self.bindAll()
    }
}

extension SettingUpdateListVC {
    private func configureCollectionView() {
        self.updateLists.dataSource = self
        self.updateLists.delegate = self
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
        self.viewModel?.$cells
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.updateLists.reloadData()
            })
            .store(in: &self.cancellables)
    }
}

extension SettingUpdateListVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.cells.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UpdateInfoCell.identifier, for: indexPath) as? UpdateInfoCell else { return UICollectionViewCell() }
        guard let info = self.viewModel?.cells[safe: indexPath.item] else { return cell }
        cell.configure(with: info)
        
        return cell
    }
}

extension SettingUpdateListVC: UICollectionViewDelegateFlowLayout {
    
}
