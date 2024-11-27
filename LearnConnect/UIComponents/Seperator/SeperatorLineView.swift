//
//  Untitled.swift
//  LearnConnect
//
//  Created by Mustafa on 27.11.2024.
//

import UIKit

final class SeparatorLineView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .systemOrange
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configure(color: UIColor = .systemOrange, height: CGFloat = 1.0) {
        backgroundColor = color
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}
