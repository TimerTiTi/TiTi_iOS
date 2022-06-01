//
//  SettingViewController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/05/28.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit
import Combine

final class SettingViewController: UIViewController {
    static let identifier = "SettingViewController"
    
    @IBOutlet weak var settings: UICollectionView!
    
    private var cancellables: Set<AnyCancellable> = []
    private var viewModel: SettingVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.configureViewModel()
        self.bindAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.settings.setContentOffset(.zero, animated: false)
        self.settings.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let bottomOffset = CGPoint(x: 0, y: self.settings.contentSize.height - self.settings.bounds.height + self.settings.contentInset.bottom)
        self.settings.setContentOffset(bottomOffset, animated: false)
    }
}

extension SettingViewController {
    private func configureCollectionView() {
        self.extendedLayoutIncludesOpaqueBars = true
        self.settings.dataSource = self
        self.settings.delegate = self
    }
    
    private func configureViewModel() {
        self.viewModel = SettingVM()
    }
    
    private func bindAll() {
        self.bindCells()
    }
    
    private func bindCells() {
        self.viewModel?.$cells
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.settings.reloadData()
            })
            .store(in: &self.cancellables)
    }
}

extension SettingViewController: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.viewModel?.sectionTitles.count ?? 0
    }
}

extension SettingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.cells[safe: section]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingCell.identifier, for: indexPath) as? SettingCell else { return UICollectionViewCell() }
        guard let cellInfo = self.viewModel?.cells[indexPath.section][indexPath.item] else { return cell }
        cell.configure(with: cellInfo)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SettingHeaderView.identifier, for: indexPath) as? SettingHeaderView else { return UICollectionReusableView() }
            guard let headerTitle = self.viewModel?.sectionTitles[safe: indexPath.section] else { return header }
            
            header.configure(title: headerTitle)
            return header
        } else if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SettingFooterView.identifier, for: indexPath)
            return footer
        } else { return UICollectionReusableView() }
    }
}

extension SettingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.settings.bounds.width
        guard let info = self.viewModel?.cells[indexPath.section][indexPath.item] else { return CGSize(width: width, height: 43)}
        
        return CGSize(width: width, height: CGFloat(info.cellHeight))
    }
}
