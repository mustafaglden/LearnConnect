//
//  RatingTableViewCell.swift
//  LearnConnect
//
//  Created by Mustafa on 26.11.2024.
//

import UIKit

final class RatingTableViewCell: UITableViewCell {
    private let nameLabel = UILabel()
    private let commentLabel = UILabel()
    private let ratingLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.textColor = .black
                
        commentLabel.font = UIFont.systemFont(ofSize: 14)
        commentLabel.textColor = .darkGray
        commentLabel.numberOfLines = 0
        
        ratingLabel.font = UIFont.systemFont(ofSize: 14)
        ratingLabel.textColor = .systemBlue
        ratingLabel.textAlignment = .right
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(commentLabel)
        contentView.addSubview(ratingLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            nameLabel.trailingAnchor.constraint(equalTo: ratingLabel.leadingAnchor, constant: -15),
                
            ratingLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            ratingLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 15),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),

            commentLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            commentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            commentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            commentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with feedback: Feedback) {
        nameLabel.text = feedback.user?.username ?? "user_unknown".localized
        commentLabel.text = feedback.feedback
        ratingLabel.text = "rating".localized + ": \(feedback.rating)/5"
    }
}
