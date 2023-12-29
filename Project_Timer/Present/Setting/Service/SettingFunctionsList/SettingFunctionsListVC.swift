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
    private let loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .medium)
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.color = UIColor.lightGray
        loader.startAnimating()
        return loader
    }()
    
    private var cancellables: Set<AnyCancellable> = []
    private var viewModel: SettingFunctionsListVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Localized.string(.Settings_Button_Functions)
        self.youtubeBT.setTitle("How to use TiTi Move to YouTube".localized(), for: .normal)
        self.configureLoader()
        self.configureCollectionView()
        self.configureViewModel()
        self.bindAll()
        self.youtubeBT.configureShadow(opacity: 0.25, radius: 5)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { [weak self] _ in
            self?.functionList.collectionViewLayout.invalidateLayout()
        }
    }
    
    @IBAction func goToYoutube(_ sender: Any) {
        guard let link = self.viewModel?.youtubeLink,
              let url = URL(string: link) else { return }
        UIApplication.shared.open(url, options: [:])
    }
}

extension SettingFunctionsListVC {
    private func configureLoader() {
        self.view.addSubview(self.loader)
        
        NSLayoutConstraint.activate([
            self.loader.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.loader.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    private func configureCollectionView() {
        self.functionList.dataSource = self
        self.functionList.delegate = self
    }
    
    private func configureViewModel() {
        // MARK: NetworkController 를 생성하는 부분에 대한 고민이 필요
        let networkController = NetworkController(network: Network())
        self.viewModel = SettingFunctionsListVM(networkController: networkController)
    }
    
    private func stopLoader() {
        self.loader.isHidden = true
        self.loader.stopAnimating()
    }
}

extension SettingFunctionsListVC {
    private func bindAll() {
        self.bindCells()
        self.bindWarning()
    }
    
    private func bindCells() {
        self.viewModel?.$infos
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] _ in
                self?.stopLoader()
                self?.functionList.reloadData()
            })
            .store(in: &self.cancellables)
    }
    
    private func bindWarning() {
        self.viewModel?.$warning
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] warning in
                guard let warning = warning else { return }
                self?.stopLoader()
                self?.showAlertWithOK(title: warning.title, text: warning.text)
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

