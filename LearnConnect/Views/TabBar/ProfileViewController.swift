//
//  ProfileViewController.swift
//  LearnConnect
//
//  Created by Mustafa on 23.11.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .systemOrange
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Session.user?.username
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.boldSystemFont(ofSize: 18)
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        textField.isHidden = true
        return textField
    }()
    
    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 10.0, leading: 10.0, bottom: 10.0, trailing: 10.0)
        button.configuration = config
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .orange
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "power"), for: .normal)
        button.tintColor = .red
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Favorite Courses"
        label.textColor = .systemOrange
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private var isEditingProfile: Bool = false
    private let viewModel = ProfileViewModel()
    private var favoriteCourses: [Course] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Profile"
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavoriteCourses()
    }
    
    private func setupLayout() {
        // Add subviews
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(editButton)
        let separator = SeparatorLineView()
        separator.configure(height: 2.0)
        view.addSubview(separator)
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: logoutButton)
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "ProfileCell")
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            
            nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
            
            nameTextField.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
            
            editButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            titleLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            titleLabel.heightAnchor.constraint(equalToConstant: 24),
            
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separator.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            
            tableView.topAnchor.constraint(equalTo: separator.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadFavoriteCourses() {
        viewModel.fetchFavoriteCourses { [weak self] courses in
            guard let self = self else { return }
            self.favoriteCourses = courses
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @objc private func editButtonTapped() {
        isEditingProfile.toggle()
        if isEditingProfile {
            nameTextField.text = nameLabel.text
            nameLabel.isHidden = true
            nameTextField.isHidden = false
            nameTextField.becomeFirstResponder()
            editButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        } else {
            if let updatedName = nameTextField.text, !updatedName.isEmpty {
                viewModel.updateUsername(newUsername: updatedName)
                nameLabel.text = updatedName
            }
            nameLabel.isHidden = false
            nameTextField.isHidden = true
            nameTextField.resignFirstResponder()
            editButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        }
    }
    
    @objc func logoutButtonTapped() {
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            let loginVC = LoginViewController()
            sceneDelegate.window?.rootViewController = loginVC
            UIView.animate(withDuration: 0.3) {
                sceneDelegate.window?.makeKeyAndVisible()
            }
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteCourses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as? ProfileTableViewCell else {
            return UITableViewCell()
        }
        let course = favoriteCourses[indexPath.row]
        cell.textLabel?.text = course.title
        cell.isUserInteractionEnabled = false
        return cell
    }
}
