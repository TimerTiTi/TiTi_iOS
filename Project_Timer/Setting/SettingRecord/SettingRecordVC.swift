//
//  SettingRecordVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/09/29.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit
import Combine

final class SettingRecordVC: UIViewController {
    static let identifier = "SettingRecordVC"
    private var viewModel: SettingRecordVM?
    private var cancellables: Set<AnyCancellable> = []
    
    @IBOutlet weak var settingCells: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Target Times".localized()
        self.configureCollectionView()
        self.configureViewModel()
        self.bindAll()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { [weak self] _ in
            self?.settingCells.collectionViewLayout.invalidateLayout()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.settingCells.reloadData()
    }
}

extension SettingRecordVC {
    private func configureViewModel() {
        self.viewModel = SettingRecordVM()
    }
    
    private func configureCollectionView() {
        self.settingCells.delegate = self
        self.settingCells.dataSource = self
    }
}

extension SettingRecordVC {
    private func bindAll() {
        self.bindCellInfos()
    }
    
    private func bindCellInfos() {
        self.viewModel?.$cellInfos
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.settingCells.reloadData()
            })
            .store(in: &self.cancellables)
    }
}

extension SettingRecordVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cellInfo = self.viewModel?.cellInfos[safe: indexPath.item] else { return }
        self.popoverVC(on: collectionView.cellForItem(at: indexPath)!, key: cellInfo.key) { [weak self] in
            self?.settingCells.reloadItems(at: [indexPath])
        }
    }
}

extension SettingRecordVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.cellInfos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingRecordCell.identifier, for: indexPath) as? SettingRecordCell else { return .init() }
        guard let cellInfo = self.viewModel?.cellInfos[safe: indexPath.item] else { return cell }
        cell.configure(info: cellInfo)
        
        return cell
    }
}

extension SettingRecordVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height: CGFloat = 64
        
        return CGSize(width: width, height: height)
    }
}

// MARK: PickerView
extension SettingRecordVC: UIPopoverPresentationControllerDelegate {
    func popoverVC(on sourceView: UIView, key: UserDefaultsManager.Keys, handler: @escaping TargetTimeHandelr) {
        guard let pickerVC = storyboard?.instantiateViewController(withIdentifier: TargetTimePickerPopupVC.identifier) as? TargetTimePickerPopupVC else { return }
        
        pickerVC.modalPresentationStyle = .popover
        pickerVC.popoverPresentationController?.sourceView = sourceView
        pickerVC.popoverPresentationController?.delegate = self
        let viewModel = TargetTimePickerVM(key: key)
        pickerVC.configure(viewModel: viewModel, handler: handler)
        
        present(pickerVC, animated: true)
    }
    /// iPhone 에서 popover 형식으로 띄우기 위한 로직
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
