//
//  ProfileViewController.swift
//  LearnConnect
//
//  Created by Mustafa on 23.11.2024.
//

import UIKit

final class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person.circle") // Placeholder image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40 // Assuming the width/height is 80
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Mustafa Gülden" // Replace with dynamic user name
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
        config.contentInsets = NSDirectionalEdgeInsets(top: 15.0, leading: 15.0, bottom: 15.0, trailing: 15.0)
        button.configuration = config
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .orange
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var isEditingProfile: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "My Profile"
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self

        setupLayout()
    }

    private func setupLayout() {
        // Add subviews
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(editButton)
        view.addSubview(tableView)

        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        // Profile ImageView constraints
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
        // Name Label constraints
            nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
        // Name Label constraints
            nameTextField.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
        // Edit Button constraints
            editButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        // TableView constraints
            tableView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func editButtonTapped() {
        isEditingProfile.toggle()
        if isEditingProfile {
            // Enable editing
            nameTextField.text = nameLabel.text // Transfer label text to text field
            nameLabel.isHidden = true
            nameTextField.isHidden = false
            nameTextField.becomeFirstResponder()
            editButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        } else {
            // Save changes
            if let updatedName = nameTextField.text, !updatedName.isEmpty {
                nameLabel.text = updatedName // Update label text with text field input
            }
            nameLabel.isHidden = false
            nameTextField.isHidden = true
            nameTextField.resignFirstResponder()
            editButton.setImage(UIImage(systemName: "pencil"), for: .normal)
            // Save to database or API if necessary
            print("Updated Name: \(nameLabel.text ?? "")")
        }
    }

    // MARK: - UITableView DataSource and Delegate Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let user = Session.user, let courseCount = user.enrolledCourses?.count else {
            return 0
        }
        return courseCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell", for: indexPath)
        guard let user = Session.user, let courses = user.enrolledCourses else {
            cell.textLabel?.text = "No Courses"
            return cell
        }
//        let coursesArray = course.allObjects as? Course ?? [
//        let course = coursesArray[indexPath.row]
//        cell.textLabel?.text = course.title
        return cell
    }
}
