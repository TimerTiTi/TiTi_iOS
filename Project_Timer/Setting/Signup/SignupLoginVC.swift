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
    
    private let network: TestServerAuth = NetworkController(network: Network())
    private var login: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appTapGestureForDismissingKeyboard()
        if self.login {
            self.configureLogin()
        }
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
    func configure(login: Bool) {
        self.login = true
    }
    
    private func configureLogin() {
        self.signupLoginStatusLabel.text = "Login [Test Server]"
        self.emailStackView.isHidden = true
        self.signupLoginButton.setTitle("Login", for: .normal)
    }
    
    private func signup(info: TestUserSignupInfo) {
        self.network.signup(userInfo: info) { [weak self] status, token in
            switch status {
            case .SUCCESS:
                guard let token = token else {
                    // fail
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
        self.network.login(userInfo: info) { [weak self] status, token in
            switch status {
            case .SUCCESS:
                guard let token = token else {
                    // fail
                    return
                }
                self?.saveUserInfo(username: info.username, password: info.password, token: token)
            default:
                self?.showAlertWithOK(title: "FAIL", text: "\(status.rawValue)")
            }
        }
    }
    
    private func saveUserInfo(username: String, password: String, token: String) {
        // MARK: Token 저장로직 필요, Noti Signup 필요
        self.showAlertWithOKAfterHandler(title: "SUCCESS", text: "") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
