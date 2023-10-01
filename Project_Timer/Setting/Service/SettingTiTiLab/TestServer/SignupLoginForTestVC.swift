//
//  SignupLoginForTestVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/09/27.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit
import Combine

class SignupLoginForTestVC: WhiteNavigationVC {
    private var viewModel: SignupLoginVM
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: CustomView
    private var logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = TiTiImage.loginLogo
        return imageView
    }()
    private var logoTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = TiTiFont.HGGGothicssiP80g(size: 15)
        label.text = "TimerTiTi"
        return label
    }()
    private let nicknameTextField = LoginInputTextfield(type: .nickname)
    private let emailTextField = LoginInputTextfield(type: .email)
    private let passwordTextField = LoginInputTextfield(type: .password)
    lazy private var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(self.viewModel.isLogin ? "Log in".localized() : "Sign up".localized(), for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.backgroundColor = .white
        button.layer.cornerRadius = 12
        button.layer.cornerCurve = .continuous
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 58)
        ])
        return button
    }()
    // MARK: constraint
    private var contentViewWidth: NSLayoutConstraint?
    
    init(viewModel: SignupLoginVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.configureTextFields()
        self.configureUI()
        self.configureActions()
        self.bindAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TestServer"
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.adjustUI(size: size)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.adjustUI(size: self.view.bounds.size)
    }
}

extension SignupLoginForTestVC {
    private func configureTextFields() {
        self.nicknameTextField.textField.delegate = self
        self.emailTextField.textField.delegate = self
        self.passwordTextField.textField.delegate = self
        
        self.passwordTextField.textField.isSecureTextEntry = true
        self.emailTextField.textField.keyboardType = .emailAddress
    }
    
    private func configureUI(width: CGFloat = 300) {
        self.addDismissingKeyboard()
        self.view.backgroundColor = TiTiColor.loginBackground
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentViewWidth = contentView.widthAnchor.constraint(equalToConstant: width)
        self.contentViewWidth?.isActive = true
        
        contentView.addSubview(self.logoImage)
        NSLayoutConstraint.activate([
            self.logoImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.logoImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        contentView.addSubview(self.logoTitle)
        NSLayoutConstraint.activate([
            self.logoTitle.topAnchor.constraint(equalTo: self.logoImage.bottomAnchor, constant: 8),
            self.logoTitle.centerXAnchor.constraint(equalTo: self.logoImage.centerXAnchor)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [self.nicknameTextField, self.emailTextField, self.passwordTextField, self.actionButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.logoTitle.bottomAnchor, constant: 68),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        if self.viewModel.isLogin {
            self.emailTextField.isHidden = true
            NSLayoutConstraint.activate([
                stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -74)
            ])
        } else {
            NSLayoutConstraint.activate([
                stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        }
        
        self.view.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func adjustUI(size: CGSize) {
        switch size.deviceDetailType {
        case .iPhoneMini:
            self.contentViewWidth?.constant = 300
        case .iPhonePro, .iPhoneMax:
            self.contentViewWidth?.constant = size.minLength - 96
        default:
            self.contentViewWidth?.constant = 400
        }
    }
    
    private func configureActions() {
        // MARK: Signup & Login Action
        self.actionButton.addAction(UIAction(handler: { [weak self] _ in
            guard let username = self?.nicknameTextField.textField.text,
                  let password = self?.passwordTextField.textField.text else { return }
            
            if self?.viewModel.isLogin == true {
                self?.viewModel.login(info: TestUserLoginInfo(username: username, password: password))
            } else {
                guard let email = self?.emailTextField.textField.text else { return }
                self?.viewModel.signup(info: TestUserSignupInfo(username: username, email: email, password: password))
            }
        }), for: .touchUpInside)
        
    }
}

extension SignupLoginForTestVC {
    private func bindAll() {
        self.bindLoadingText()
        self.bindAlert()
        self.bindLoginSuccess()
    }
    
    private func bindLoadingText() {
        self.viewModel.$loadingText
            .receive(on: DispatchQueue.main)
            .sink { text in
                guard let text = text else {
                    LoadingIndicator.hideLoading()
                    return
                }
                LoadingIndicator.showLoading(text: text)
            }
            .store(in: &self.cancellables)
    }
    
    private func bindAlert() {
        self.viewModel.$alert
            .receive(on: DispatchQueue.main)
            .sink { [weak self] alertInfo in
                guard let alertInfo = alertInfo else { return }
                self?.showAlertWithOK(title: alertInfo.title, text: alertInfo.text)
            }
            .store(in: &self.cancellables)
    }
    
    private func bindLoginSuccess() {
        self.viewModel.$loginSuccess
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loginSuccess in
                if loginSuccess {
                    self?.showAlertWithOKAfterHandler(title: "SUCCESS", text: "") { [weak self] in
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
            .store(in: &self.cancellables)
    }
}

extension SignupLoginForTestVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.nicknameTextField.textField {
            if self.viewModel.isLogin {
                self.passwordTextField.textField.becomeFirstResponder()
            } else {
                self.emailTextField.textField.becomeFirstResponder()
            }
        } else if textField == self.emailTextField.textField {
            self.passwordTextField.textField.becomeFirstResponder()
        } else if textField == self.passwordTextField.textField {
            self.dismissKeyboard()
        }
        
        return true
    }
}
