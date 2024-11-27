//
//  LoginViewController.swift
//  LearnConnect
//
//  Created by Mustafa on 22.11.2024.
//

import UIKit
import CoreData
import Foundation

final class LoginViewController: UIViewController {
    
    private let viewModel = AuthenticationViewModel()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let registerButton = UIButton(type: .system)
    private let loginButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        setupView()
    }
    
    func setupView() {
        setupTitle()
        setupTextFields()
        setupButtons()
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            titleLabel.heightAnchor.constraint(equalToConstant: 80),
            
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            loginButton.heightAnchor.constraint(equalToConstant: 40),
            loginButton.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
            
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 15),
            registerButton.heightAnchor.constraint(equalToConstant: 40),
            registerButton.widthAnchor.constraint(equalTo: loginButton.widthAnchor)
        ])
    }
    
    func setupTitle() {
        view.addSubview(titleLabel)
        
        titleLabel.textColor = Constants.customTintColor
        titleLabel.text = "welcome".localized
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupTextFields() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        
        emailTextField.placeholder = "enter_email".localized
        emailTextField.borderStyle = .roundedRect
        
        passwordTextField.placeholder = "enter_password".localized
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupButtons() {
        view.addSubview(registerButton)
        view.addSubview(loginButton)
        
        registerButton.setTitle("register".localized, for: .normal)
        registerButton.tintColor = .white
        registerButton.backgroundColor = .lightGray
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        loginButton.setTitle("login".localized, for: .normal)
        loginButton.backgroundColor = .green
        loginButton.tintColor = .white
        loginButton.layer.cornerRadius = 4
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc private func registerButtonTapped() {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @objc private func loginButtonTapped() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        if viewModel.loginUser(email: email, password: password) {
            if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
                let tabbarVC = MainTabBarController()
                sceneDelegate.window?.rootViewController = tabbarVC
                UIView.animate(withDuration: 0.3) {
                    sceneDelegate.window?.makeKeyAndVisible()
                }
            }
        } else {
            showAlert("user_not_match".localized)
        }
    }
    
}
