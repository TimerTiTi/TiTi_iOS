//
//  SettingVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/05/28.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit
import Combine
import MessageUI

final class SettingVC: UIViewController {
    static let identifier = "SettingVC"
    
    @IBOutlet weak var settings: UICollectionView!
    
    private var cancellables: Set<AnyCancellable> = []
    private var viewModel: SettingVM?
    private var lastSection: Int {
        if let sectionsCount = self.viewModel?.sectionTitles.count {
            return sectionsCount-1
        } else {
            return 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.configureViewModel()
        self.bindAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.updateTabbarColor(backgroundColor: TiTiColor.tabbarBackground, tintColor: .label, normalColor: .lightGray)
        self.settings.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tabBarController?.updateTabbarColor(backgroundColor: TiTiColor.tabbarBackground, tintColor: .label, normalColor: .lightGray)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { [weak self] _ in
            guard let settings = self?.settings else { return }
            settings.collectionViewLayout.invalidateLayout()
        }
    }
}

extension SettingVC {
    private func configureCollectionView() {
        self.extendedLayoutIncludesOpaqueBars = true
        self.settings.dataSource = self
        self.settings.delegate = self
    }
    
    private func configureViewModel() {
        self.viewModel = SettingVM(isIpad: UIDevice.current.userInterfaceIdiom == .pad)
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

extension SettingVC: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.viewModel?.sectionTitles.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cellInfo = self.viewModel?.cells[indexPath.section][indexPath.item],
              let action = cellInfo.action else { return }
        
        switch action {
        case .pushVC:
            guard let nextVCIndentifier = cellInfo.nextVCIdentifier else { return }
            self.pushVC(nextVCIdentifier: nextVCIndentifier)
        case .goSafari:
            guard let url = cellInfo.url else { return }
            self.goSafari(url: url)
        case .deeplink:
            guard let link = cellInfo.url else { return }
            self.deeplink(link: link)
        }
    }
}

extension SettingVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.cells[safe: section]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == self.lastSection {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingDevInfoCell.identifier, for: indexPath) as? SettingDevInfoCell else { return UICollectionViewCell() }
            cell.delegate = self
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingCell.identifier, for: indexPath) as? SettingCell else { return UICollectionViewCell() }
            guard let cellInfo = self.viewModel?.cells[indexPath.section][indexPath.item] else { return cell }
            cell.configure(with: cellInfo)
            
            return cell
        }
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

extension SettingVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.settings.bounds.width
        guard let info = self.viewModel?.cells[indexPath.section][indexPath.item] else { return CGSize(width: width, height: 43)}
        let height: CGFloat = indexPath.section == self.lastSection ? 80 : CGFloat(info.cellHeight)
        
        return CGSize(width: width, height: height)
    }
}

extension SettingVC: SettingActionDelegate {
    func pushVC(nextVCIdentifier: String) {
        if nextVCIdentifier == "showBackup" {
            // test code
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let activityViewController = UIActivityViewController(activityItems: [path], applicationActivities: nil)

            if UIDevice.current.userInterfaceIdiom == .pad {
                activityViewController.popoverPresentationController?.sourceView = self.view
                activityViewController.popoverPresentationController?.sourceRect = self.navigationController!.navigationBar.frame
            }

            self.present(activityViewController, animated: true)
        } else {
            guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: nextVCIdentifier) else { return }
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    func goSafari(url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    func deeplink(link: String) {
        if let url = URL(string: link),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}

extension SettingVC: MFMailComposeViewControllerDelegate {
    func showEmailPopup() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["freedeveloper97@gmail.com"])
            mail.setMessageBody("<p>작은 피드백 하나하나가 큰 도움이 됩니다 :)</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            let sendMailErrorAlert = UIAlertController(title: "이메일 실패", message: "아이폰 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "OK", style: .default)
            sendMailErrorAlert.addAction(confirmAction)
            self.present(sendMailErrorAlert, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
