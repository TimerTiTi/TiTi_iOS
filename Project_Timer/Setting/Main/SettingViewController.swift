//
//  SettingViewController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/05/28.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit
import Combine
import MessageUI

final class SettingViewController: UIViewController {
    static let identifier = "SettingViewController"
    
    @IBOutlet weak var settings: UICollectionView!
    
    private var cancellables: Set<AnyCancellable> = []
    private var viewModel: SettingVM?
    private var stayScroll: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.configureViewModel()
        self.bindAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateTabbarColor()
        self.settings.reloadData()
        self.stayScroll = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.updateTabbarColor()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if stayScroll == false {
            let bottomOffset = CGPoint(x: 0, y: self.settings.contentSize.height - self.settings.bounds.height + self.settings.contentInset.bottom)
            self.settings.setContentOffset(bottomOffset, animated: false)
            self.tabBarController?.tabBar.barTintColor = .clear
        }
    }
}

extension SettingViewController {
    private func updateTabbarColor() {
        self.tabBarController?.tabBar.tintColor = .label
        self.tabBarController?.tabBar.unselectedItemTintColor = .lightGray
        self.tabBarController?.tabBar.barTintColor = TiTiColor.tabbarBackground
    }
    
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
        if indexPath.section == 3 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingDevInfoCell.identifier, for: indexPath) as? SettingDevInfoCell else { return UICollectionViewCell() }
            cell.delegate = self
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingCell.identifier, for: indexPath) as? SettingCell else { return UICollectionViewCell() }
            guard let cellInfo = self.viewModel?.cells[indexPath.section][indexPath.item] else { return cell }
            cell.configure(with: cellInfo, delegate: self)
            
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

extension SettingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.settings.bounds.width
        guard let info = self.viewModel?.cells[indexPath.section][indexPath.item] else { return CGSize(width: width, height: 43)}
        let height: CGFloat = indexPath.section == 3 ? 80 : CGFloat(info.cellHeight)
        
        return CGSize(width: width, height: height)
    }
}

extension SettingViewController: SettingActionDelegate {
    func pushVC(nextVCIdentifier: String) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: nextVCIdentifier) else { return }
        self.stayScroll = true
        self.navigationController?.pushViewController(nextVC, animated: true)
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

extension SettingViewController: MFMailComposeViewControllerDelegate {
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
