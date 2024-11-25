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
    private let rateButton = UIButton(type: .system)
    private let feedbackTextView = UITextView()
    private let tableView = UITableView()
    private let viewModel = CourseListViewModel()
    
    
    var selectedRating: Int {
        return ratingPickerSelectedIndex + 1
    }
    var ratingPickerSelectedIndex: Int = 0
    
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
        
        // Rating button setup
        rateButton.setTitle("Rate this Course", for: .normal)
        rateButton.addTarget(self, action: #selector(rateCourse), for: .touchUpInside)
        
        // Feedback TextView setup
        feedbackTextView.layer.borderWidth = 1
        feedbackTextView.layer.borderColor = UIColor.lightGray.cgColor
        feedbackTextView.layer.cornerRadius = 8
        feedbackTextView.font = UIFont.systemFont(ofSize: 14)
        
        // TableView setup
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FeedbackCell")
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, enrollLabel, enrollSwitch, rateButton, feedbackTextView, tableView])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .leading
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        enrollSwitch.addTarget(self, action: #selector(toggleEnrollment), for: .valueChanged)
    }
    
    private func loadCourseDetails() {
        guard let course = course else { return }
        titleLabel.text = course.title
        descriptionLabel.text = course.description
    }
    
    @objc private func toggleEnrollment() {
        guard let course = course else { return }
        viewModel.manageEnrollment(course: course, isEnrolled: enrollSwitch.isOn)
    }
    
    @objc private func rateCourse() {
        let rateVC = RateCourseViewController()
        rateVC.modalPresentationStyle = .pageSheet // Set modal presentation to pageSheet
        if let sheet = rateVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()] // Set the bottom sheet sizes
            sheet.prefersGrabberVisible = true // Show a grabber for user convenience
        }
        
        rateVC.onSubmit = { [weak self] rating, comment in
            guard let self = self else { return }
            print("Rating: \(rating), Comment: \(comment)")
            self.submitFeedback(rating: rating, comment: comment)
        }
            
        present(rateVC, animated: true, completion: nil)
    }
    
    private func submitFeedback(rating: Int, comment: String) {
        guard let course = course else { return }

        viewModel.submitFeedback(for: course, rating: rating, feedback: comment) { success in
            if success {
                print("Feedback submitted successfully")
                self.tableView.reloadData() // Reload the table to show the new feedback
            } else {
                print("Failed to submit feedback")
            }
        }
    }
}


extension CourseDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let course = course else { return 0 }
        return course.feedbacks?.count ?? 0
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedbackCell", for: indexPath)
        guard let course = course else { return cell }
        let feedbacks = Array(course.feedbacks as? Set<Feedback> ?? [])
        let feedback = feedbacks[indexPath.row] // Assuming feedback is a Set
        cell.textLabel?.text = feedback.feedback // Adjust to the actual property of feedback
        return cell
    }
}
