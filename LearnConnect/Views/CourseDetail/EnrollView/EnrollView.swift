//
//  EnrollView.swift
//  LearnConnect
//
//  Created by Mustafa on 27.11.2024.
//

import UIKit

final class EnrollView: UIStackView {
    private let enrollButton = UIButton(type: .system)
    private let enrollLabel = UILabel()
    
    private var isEnrolled: Bool = false {
        didSet {
            updateButtonState()
        }
    }
    
    var onToggleEnrollment: ((Bool) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        enrollLabel.text = "Course Status"
        enrollLabel.font = .systemFont(ofSize: 16)
        
        enrollButton.setTitle("Enroll", for: .normal)
        enrollButton.setTitleColor(.white, for: .normal)
        enrollButton.backgroundColor = .systemGreen
        enrollButton.layer.cornerRadius = 8
        enrollButton.addTarget(self, action: #selector(enrollButtonTapped), for: .touchUpInside)
                
        let stackView = UIStackView(arrangedSubviews: [enrollLabel, enrollButton])
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
    
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
                
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            enrollButton.widthAnchor.constraint(equalToConstant: 80),
            enrollButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    private func updateButtonState() {
        if isEnrolled {
            enrollButton.setTitle("Leave", for: .normal)
            enrollButton.backgroundColor = .systemRed
        } else {
            enrollButton.setTitle("Enroll", for: .normal)
            enrollButton.backgroundColor = .systemGreen
        }
    }
    
    @objc private func enrollButtonTapped() {
        isEnrolled.toggle()
        onToggleEnrollment?(isEnrolled)
    }
    
    func configure(isEnrolled: Bool) {
        self.isEnrolled = isEnrolled
    }
}
