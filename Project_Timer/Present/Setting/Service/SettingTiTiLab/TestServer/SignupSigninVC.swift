//
//  SignupSigninVC.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/09/27.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit
import Combine

class SignupSigninVC: WhiteNavigationVC {
    private var viewModel: SignupSigninVM
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: CustomView
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    private var logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = TiTiImage.signinLogo
        return imageView
    }()
    private var logoTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = Fonts.HGGGothicssiP80g(size: 15)
        label.text = "TimerTiTi"
        return label
    }()
    private let nicknameTextField = SigninInputTextfield(type: .nickname)
    private let emailTextField = SigninInputTextfield(type: .email)
    private let passwordTextField = SigninInputTextfield(type: .password)
    lazy private var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(self.viewModel.isSignin ? "Sign in".localized() : "Sign up".localized(), for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.backgroundColor = .white
        button.layer.cornerRadius = 12
        button.layer.cornerCurve = .continuous
        button.isUserInteractionEnabled = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: SigninInputTextfield.height)
        ])
        return button
    }()
    private lazy var textFieldsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.nicknameTextField, self.emailTextField, self.passwordTextField, self.actionButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    private var textFieldOrigin: CGPoint = .zero
    // MARK: constraint
    private var contentViewWidth: NSLayoutConstraint?
    
    init(viewModel: SignupSigninVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.configureTextFields()
        self.configureNotifications()
        self.configureUI()
        self.configureActions()
        self.bindAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TestServer"
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.adjustUI(size: self.view.bounds.size)
    }
}

extension SignupSigninVC {
    private func configureTextFields() {
        self.nicknameTextField.textField.delegate = self
        self.emailTextField.textField.delegate = self
        self.passwordTextField.textField.delegate = self
        
        self.passwordTextField.textField.isSecureTextEntry = true
        self.emailTextField.textField.keyboardType = .emailAddress
    }
    
    private func configureNotifications() {
        // keyboardWillShow observer 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func configureUI(width: CGFloat = 300) {
        self.addDismissingKeyboard()
        self.view.backgroundColor = Colors.signinBackground
        
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
        
        contentView.addSubview(self.textFieldsStackView)
        NSLayoutConstraint.activate([
            self.textFieldsStackView.topAnchor.constraint(equalTo: self.logoTitle.bottomAnchor, constant: 68),
            self.textFieldsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            self.textFieldsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        if self.viewModel.isSignin {
            self.emailTextField.isHidden = true
            NSLayoutConstraint.activate([
                self.textFieldsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -74)
            ])
        } else {
            NSLayoutConstraint.activate([
                self.textFieldsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
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
        // MARK: Signup & Signin Action
        self.actionButton.addAction(UIAction(handler: { [weak self] _ in
            guard let username = self?.nicknameTextField.textField.text,
                  let password = self?.passwordTextField.textField.text else { return }
            
            if self?.viewModel.isSignin == true {
                self?.viewModel.signin(info: TestUserSigninInfo(username: username, password: password))
            } else {
                guard let email = self?.emailTextField.textField.text else { return }
                self?.viewModel.signup(info: TestUserSignupInfo(username: username, email: email, password: password))
            }
        }), for: .touchUpInside)
    }
}

extension SignupSigninVC {
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardRectangle = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            // keyboard 높이에 따라 bounds.origin 값 조정
            print(keyboardRectangle.height)
            let keyboardY = self.view.bounds.height - keyboardRectangle.height
            let textFieldOrigin = self.textFieldOrigin
            let targetY = textFieldOrigin.y + SigninInputTextfield.height + 16
            
            if keyboardY <= targetY {
                UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut, .overrideInheritedCurve]) { [weak self] in
                    self?.view.bounds.origin.y = targetY - keyboardY
                }
            }
        }
    }
}

extension SignupSigninVC {
    private func bindAll() {
        self.bindLoadingText()
        self.bindAlert()
        self.bindPostable()
        self.bindSigninSuccess()
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
    
    private func bindPostable() {
        self.viewModel.$postable
            .receive(on: DispatchQueue.main)
            .sink { [weak self] postable in
                if postable {
                    self?.actionButton.backgroundColor = .tintColor
                    self?.actionButton.setTitleColor(.white, for: .normal)
                    self?.actionButton.isUserInteractionEnabled = true
                } else {
                    self?.actionButton.isUserInteractionEnabled = false
                    self?.actionButton.backgroundColor = .white
                    self?.actionButton.setTitleColor(.gray, for: .normal)
                }
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
    
    private func bindSigninSuccess() {
        self.viewModel.$signinSuccess
            .receive(on: DispatchQueue.main)
            .sink { [weak self] signinSuccess in
                guard signinSuccess else { return }
                
                let title: String = self?.viewModel.isSignin == true ? Localized.string(.SignIn_Popup_SigninSuccess) : Localized.string(.SignUp_Popup_SignupSuccess)
                self?.showAlertWithOKAfterHandler(title: title, text: "") { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            .store(in: &self.cancellables)
    }
}

extension SignupSigninVC: UITextFieldDelegate {
    /// return 키 설정
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.nicknameTextField.textField {
            if self.viewModel.isSignin {
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
    
    /// textField 활성화시 origin 값 설정 -> 이후 keyboardWillShow 메소드 내에서 bounds.origin 값 조정
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.textFieldOrigin = self.textFieldOrigin(textField)
    }
    
    /// textField 비활성화시 bounds.origin 리셋
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut,.overrideInheritedCurve]) { [weak self] in
            self?.view.bounds.origin.y = 0
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let nickname = self.nicknameTextField.textField.text
        let email = self.emailTextField.textField.text
        let password = self.passwordTextField.textField.text
        self.viewModel.check(nickname: nickname, email: email, password: password)
    }
    
    private func textFieldOrigin(_ textField: UITextField) -> CGPoint {
        var textFieldOrigin: CGPoint = .zero
        if textField == self.nicknameTextField.textField {
            textFieldOrigin = self.nicknameTextField.origin
        } else if textField == self.emailTextField.textField {
            textFieldOrigin = self.emailTextField.origin
        } else {
            textFieldOrigin = self.passwordTextField.origin
        }
        
        let stackViewOrigin = self.textFieldsStackView.frame.origin
        let contentViewOrigin = self.contentView.frame.origin
        
        return textFieldOrigin + stackViewOrigin + contentViewOrigin
    }
}
