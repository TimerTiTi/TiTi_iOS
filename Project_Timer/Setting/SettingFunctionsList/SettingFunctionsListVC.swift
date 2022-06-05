//
//  SettingFunctionsListVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/06/04.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit
import Combine

final class SettingFunctionsListVC: UIViewController {
    static let identifier = "SettingFunctionsListVC"

    @IBOutlet weak var functionList: UICollectionView!
    @IBOutlet weak var youtubeBT: UIButton!
    
    private var cancellables: Set<AnyCancellable> = []
    private var viewModel: FunctionInfoListVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.configureViewModel()
        self.bindAll()
        self.youtubeBT.configureShadow(opacity: 0.25, radius: 5)
    }
    
    @IBAction func goToYoutube(_ sender: Any) {
        if let url = URL(string: NetworkURL.youtubeLink) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}

extension SettingFunctionsListVC {
    private func configureCollectionView() {
        self.functionList.dataSource = self
        self.functionList.delegate = self
    }
    
    private func configureViewModel() {
        self.viewModel = FunctionInfoListVM()
    }
}

extension SettingFunctionsListVC {
    private func bindAll() {
        self.bindCells()
    }
    
    private func bindCells() {
        self.viewModel?.$infos
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.functionList.reloadData()
            })
            .store(in: &self.cancellables)
    }
}

extension SettingFunctionsListVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.infos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FunctionInfoCell.identifier, for: indexPath) as? FunctionInfoCell else { return UICollectionViewCell() }
        guard let info = self.viewModel?.infos[safe: indexPath.item] else { return cell }
        cell.configure(with: info, delegate: self)
        
        return cell
    }
}

extension SettingFunctionsListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.functionList.bounds.width, height: 55)
    }
}

extension SettingFunctionsListVC: FunctionsActionDelegate {
    func showWebview(url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}
