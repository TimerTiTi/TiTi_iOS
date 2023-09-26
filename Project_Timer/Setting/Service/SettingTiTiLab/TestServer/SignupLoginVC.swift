//
//  SignupLoginVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/12/21.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class SignupLoginVC: UIViewController {
    static let identifier = "SignupLoginVC"
    
    @IBOutlet weak var signupLoginStatusLabel: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signupLoginButton: UIButton!
    @IBOutlet weak var emailStackView: UIStackView!
    
    private let network: TestServerAuthFetchable = NetworkController(network: Network())
    private var login: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appTapGestureForDismissingKeyboard()
        if self.login {
            self.configureLogin()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.adjustUI(type: size.deviceDetailType)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.adjustUI(type: self.view.bounds.size.deviceDetailType)
    }
    
    @IBAction func signupLogin(_ sender: Any) {
        guard let username = userNameTextField.text,
              let password = passwordTextField.text else { return }
        if self.login {
            let userInfo = TestUserLoginInfo(username: username, password: password)
            self.login(info: userInfo)
        } else {
            guard let email = emailTextField.text else { return }
            let userInfo = TestUserSignupInfo(username: username, email: email, password: password)
            self.signup(info: userInfo)
        }
        
    }
}

extension SignupLoginVC {
    private func adjustUI(type: CGSize.DeviceDetailType) {
        print(type)
    }
}

extension SignupLoginVC {
    func configure(login: Bool) {
        self.login = true
    }
    
    private func configureLogin() {
        self.signupLoginStatusLabel.text = "Login [Test Server]"
        self.emailStackView.isHidden = true
        self.signupLoginButton.setTitle("Login", for: .normal)
    }
    
    private func signup(info: TestUserSignupInfo) {
        LoadingIndicator.showLoading(text: "Waiting for Signup...")
        self.network.signup(userInfo: info) { [weak self] status, token in
            LoadingIndicator.hideLoading()
            switch status {
            case .SUCCESS:
                guard let token = token else {
                    self?.showAlertWithOK(title: "Network Error", text: "invalid token value")
                    return
                }
                self?.saveUserInfo(username: info.username, password: info.password, token: token)
            case .CONFLICT:
                self?.showAlertWithOK(title: "CONFLICT", text: "need another infos")
            default:
                self?.showAlertWithOK(title: "FAIL", text: "\(status.rawValue)")
            }
        }
    }
    
    private func login(info: TestUserLoginInfo) {
        LoadingIndicator.showLoading(text: "Waiting for Login...")
        self.network.login(userInfo: info) { [weak self] status, token in
            LoadingIndicator.hideLoading()
            switch status {
            case .SUCCESS:
                guard let token = token else {
                    self?.showAlertWithOK(title: "Network Error", text: "invalid token value")
                    return
                }
                self?.saveUserInfo(username: info.username, password: info.password, token: token)
            default:
                self?.showAlertWithOK(title: "FAIL", text: "\(status.rawValue)")
            }
        }
    }
    
    private func saveUserInfo(username: String, password: String, token: String) {
        // MARK: Token 저장, Noti logined
        guard [KeyChain.shared.save(key: .username, value: username),
               KeyChain.shared.save(key: .password, value: password),
               KeyChain.shared.save(key: .token, value: token)].allSatisfy({ $0 }) == true else {
            self.showAlertWithOK(title: "Keychain save fail", text: "")
            return
        }
        
        UserDefaultsManager.set(to: true, forKey: .loginInTestServerV1)
        NotificationCenter.default.post(name: KeyChain.logined, object: nil)
        
        self.showAlertWithOKAfterHandler(title: "SUCCESS", text: "") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
