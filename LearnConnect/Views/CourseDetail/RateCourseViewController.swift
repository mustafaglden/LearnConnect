//
//  RateCourseViewController.swift
//  LearnConnect
//
//  Created by Mustafa on 25.11.2024.
//

import UIKit

final class RateCourseViewController: UIViewController {
    
    // MARK: - Properties
    private let pickerView = UIPickerView()
    private let commentTextField = UITextField()
    private let submitButton = UIButton(type: .system)
    private var selectedRating: Int = 1
    
    var onSubmit: ((Int, String) -> Void)?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        
        // PickerView setup
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // Comment TextField setup
        commentTextField.placeholder = "make_comment".localized
        commentTextField.borderStyle = .roundedRect
        commentTextField.translatesAutoresizingMaskIntoConstraints = false
        
        // Submit Button setup
        submitButton.setTitle("submit".localized, for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.backgroundColor = .systemBlue
        submitButton.layer.cornerRadius = 8
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        
        // StackView to organize the elements
        let stackView = UIStackView(arrangedSubviews: [pickerView, commentTextField, submitButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add stackView to the view
        view.addSubview(stackView)
        
        // Add constraints
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            commentTextField.heightAnchor.constraint(equalToConstant: 40),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Actions
    @objc private func submitTapped() {
        let comment = commentTextField.text ?? ""
        onSubmit?(selectedRating, comment) // Trigger the callback with rating and comment
        dismiss(animated: true, completion: nil)
    }
    
}

extension RateCourseViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: - UIPickerView DataSource & Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5 // For 1 to 5 stars
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1) Stars"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRating = row + 1 // Update the selected rating
    }
}

