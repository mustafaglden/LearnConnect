//
//  MyCoursesViewController.swift
//  LearnConnect
//
//  Created by Mustafa on 22.11.2024.
//

import UIKit

class MyCoursesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let viewModel = CourseListViewModel()
    private let tableView = UITableView()
    private var courses: [Course] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Courses"
        setupUI()
        fetchEnrolledCourses()
    }
    
    private func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCourseCell")
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    private func fetchEnrolledCourses() {
        guard let courseSet = Session.user?.enrolledCourses else {
            return
        }
        courses = (courseSet.allObjects as? [Course]) ?? []
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCourseCell", for: indexPath)
        let course = courses[indexPath.row]
        cell.textLabel?.text = course.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let course = courses[indexPath.row]
        // MARK: TODO(Create new detail page)
//        let detailVC = CourseDetailVideoPlayerViewController()
        let detailVC = VideoPlayerViewController()
//        detailVC.course = course
        let fileURL = Bundle.main.url(forResource: course.fileName, withExtension: "mp4")
        detailVC.videoURL = fileURL
        detailVC.course = course
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
