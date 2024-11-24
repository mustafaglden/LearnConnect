//
//  CourseDetailViewController.swift
//  LearnConnect
//
//  Created by Mustafa on 22.11.2024.
//

import UIKit

import UIKit

class CourseDetailViewController: UIViewController {
    var course: Course?
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let enrollSwitch = UISwitch()
    private let enrollLabel = UILabel()
    private let viewModel = CourseListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadCourseDetails()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        
        enrollLabel.text = "Enroll in this course"
        enrollLabel.font = UIFont.systemFont(ofSize: 18)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, enrollLabel, enrollSwitch])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .leading
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        enrollSwitch.addTarget(self, action: #selector(toggleEnrollment), for: .valueChanged)
    }
    
    private func loadCourseDetails() {
        guard let course = course else { return }
        titleLabel.text = course.title
        descriptionLabel.text = course.description
        enrollSwitch.isOn = course.isEnrolled
    }
    
    @objc private func toggleEnrollment() {
        guard let course = course else { return }
        viewModel.enrollInCourse(course: course, isEnrolled: enrollSwitch.isOn)
    }
}
