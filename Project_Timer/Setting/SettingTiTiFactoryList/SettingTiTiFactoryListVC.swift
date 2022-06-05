//
//  SettingTiTiFactoryListVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/04.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit
import Combine

final class SettingTiTiFactoryListVC: UIViewController {
    static let identifier = "SettingTiTiFactoryListVC"

    @IBOutlet weak var surveys: UICollectionView!
    
    private var cancellables: Set<AnyCancellable> = []
    private var viewModel: SurveyListVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.configureViewModel()
        self.bindAll()
    }
}

extension SettingTiTiFactoryListVC {
    private func configureCollectionView() {
        self.surveys.dataSource = self
        self.surveys.delegate = self
    }
    
    private func configureViewModel() {
        self.viewModel = SurveyListVM()
    }
}

extension SettingTiTiFactoryListVC {
    private func bindAll() {
        self.bindCells()
    }
    
    private func bindCells() {
        self.viewModel?.$infos
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.surveys.reloadData()
            })
            .store(in: &self.cancellables)
    }
}

extension SettingTiTiFactoryListVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return max(self.viewModel?.infos.count ?? 0, 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SurveyCell.identifier, for: indexPath) as? SurveyCell else { return UICollectionViewCell() }
        if self.viewModel?.infos.count ?? 0 == 0 {
            cell.configureWarning()
        } else {
            guard let info = self.viewModel?.infos[safe: indexPath.item] else { return cell }
            cell.configure(with: info, delegate: self)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TiTiFactoryHeaderView.identifier, for: indexPath) as? TiTiFactoryHeaderView else { return UICollectionReusableView() }
            header.configure(delegate: self)
            
            return header
        } else { return UICollectionReusableView() }
    }
}

extension SettingTiTiFactoryListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 55)
    }
}

extension SettingTiTiFactoryListVC: FactoryActionDelegate {
    func showWebview(url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}
