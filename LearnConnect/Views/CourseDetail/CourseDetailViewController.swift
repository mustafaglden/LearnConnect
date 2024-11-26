//
//  CourseDetailViewController.swift
//  LearnConnect
//
//  Created by Mustafa on 22.11.2024.
//

import UIKit

import UIKit

final class CourseDetailViewController: UIViewController {
    
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
        enrollSwitch.addTarget(self, action: #selector(toggleEnrollment), for: .valueChanged)
        
        // Rating button setup
        rateButton.setTitle("Rate this Course", for: .normal)
        rateButton.addTarget(self, action: #selector(rateCourse), for: .touchUpInside)

        // TableView setup
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RatingTableViewCell.self, forCellReuseIdentifier: "FeedbackCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, enrollLabel, enrollSwitch, rateButton, tableView])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill

        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadCourseDetails() {
        guard let course = course else { return }
        titleLabel.text = course.title
        descriptionLabel.text = course.desc
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
        viewModel.onFeedbackSaved = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData() // Reload table view when feedback is saved
        }
        viewModel.submitFeedback(for: course, rating: rating, feedback: comment)
    }
}


extension CourseDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let course = course else { return 0 }
        return course.feedbacks?.count ?? 0
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedbackCell", for: indexPath) as? RatingTableViewCell else {
            return UITableViewCell()
        }
        guard let course = course else { return cell }
        let feedbacks = Array(course.feedbacks as? Set<Feedback> ?? [])
        let feedback = feedbacks[indexPath.row] 
        cell.configure(with: feedback)
        cell.isUserInteractionEnabled = false
        return cell
    }
}
