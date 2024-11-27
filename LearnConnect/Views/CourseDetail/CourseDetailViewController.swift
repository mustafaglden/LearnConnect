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
    private let titleView = TitleView()
    private let descriptionLabel = UILabel()
    private let enrollView = EnrollView()
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
        notificationHandlers()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0

        enrollView.translatesAutoresizingMaskIntoConstraints = false
        
        rateButton.setTitle("Rate this Course", for: .normal)
        rateButton.tintColor = .systemOrange
        rateButton.addTarget(self, action: #selector(rateCourse), for: .touchUpInside)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RatingTableViewCell.self, forCellReuseIdentifier: "FeedbackCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView(arrangedSubviews: [titleView, descriptionLabel, enrollView, rateButton, tableView])
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
        titleView.configure(title: course.title ?? "Unknown Title", isFavorite: viewModel.isFavorite(course: course))
        descriptionLabel.text = course.desc
    }
    
    private func updateFavoriteButtonState() {
        guard let course = course else { return }
        titleView.configure(title: course.title ?? "Unknown Title", isFavorite: viewModel.isFavorite(course: course))
    }
    
    @objc private func rateCourse() {
        let rateVC = RateCourseViewController()
        rateVC.modalPresentationStyle = .pageSheet
        if let sheet = rateVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
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
            self.tableView.reloadData()
        }
        viewModel.submitFeedback(for: course, rating: rating, feedback: comment)
    }
    
    private func notificationHandlers() {
        titleView.onFavoriteToggle = { [weak self] in
                    guard let self = self, let course = self.course else { return }
                    self.viewModel.toggleFavorite(course: course) { success in
                        if success {
                            self.updateFavoriteButtonState()
                        }
                    }
                }
        
        enrollView.onToggleEnrollment = { [weak self] isEnrolled in
            guard let self = self else { return }
                if let course = self.course {
                self.viewModel.manageEnrollment(course: course, isEnrolled: isEnrolled)
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
