//
//  SignupStartVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2022/12/21.
//  Copyright © 2022 FDEE. All rights reserved.
//

import UIKit

final class SignupStartVC: UIViewController {
    static let identifier = "SignupStartVC"
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appTapGestureForDismissingKeyboard()
    }
    
    @IBAction func signup(_ sender: Any) {
        guard let username = userNameTextField.text,
              let password = passwordTextField.text,
              let email = emailTextField.text else { return }
        let userInfo = TestUserSignupInfo(username: username, email: email, password: password)
        self.signup(info: userInfo)
    }
}

extension SignupStartVC {
    private func signup(info: TestUserSignupInfo) {
        let networkController: TestServerAuth = NetworkController(network: Network())
        networkController.signup(userInfo: info) { [weak self] status, token in
            switch status {
            case .SUCCESS:
                guard let token = token else {
                    // fail
                    return
                }
                self?.saveUserInfo(userInfo: info, token: token)
            case .CONFLICT:
                self?.showAlertWithOK(title: "CONFLICT", text: "need another infos")
            default:
                self?.showAlertWithOK(title: "FAIL", text: "\(status.rawValue)")
            }
        }
    }
    
    private func saveUserInfo(userInfo: TestUserSignupInfo, token: String) {
        // MARK: Token 저장로직 필요, Noti Signup 필요
        self.showAlertWithOKAfterHandler(title: "SUCCESS", text: "Click to Sync Dailys") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
