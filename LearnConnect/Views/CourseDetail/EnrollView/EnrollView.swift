//
//  EnrollView.swift
//  LearnConnect
//
//  Created by Mustafa on 27.11.2024.
//

import UIKit

final class EnrollView: UIStackView {
    private let enrollSwitch = UISwitch()
    private let enrollLabel = UILabel()
    
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
        enrollLabel.text = "Enroll in this course"
        enrollLabel.font = UIFont.systemFont(ofSize: 18)
        enrollLabel.textAlignment = .center

        axis = .horizontal
        spacing = 10
        alignment = .center
        distribution = .equalSpacing

        addArrangedSubview(enrollLabel)
        addArrangedSubview(UIView())
        addArrangedSubview(enrollSwitch)
        
        enrollSwitch.addTarget(self, action: #selector(toggleEnrollment), for: .valueChanged)
    }
    
    @objc private func toggleEnrollment() {
        onToggleEnrollment?(enrollSwitch.isOn)
    }
}
