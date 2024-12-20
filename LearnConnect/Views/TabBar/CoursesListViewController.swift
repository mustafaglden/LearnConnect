//
//  CoursesListViewController.swift
//  LearnConnect
//
//  Created by Mustafa on 22.11.2024.
//

import UIKit

final class CoursesListViewController: UIViewController, UISearchResultsUpdating {
    
    private let viewModel = CourseListViewModel()
    private let tableView = UITableView()
    private var courses: [Course] = []
    private var filteredCourses: [Course] = []
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "all_courses".localized
        
        setupUI()
        setupSearchController()
        fetchCourses()
    }
    
    private func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CourseCell")
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "search".localized
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func fetchCourses() {
        courses = viewModel.fetchCourse()
        tableView.reloadData()
    }
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.isEmpty else {
            filteredCourses = courses
            tableView.reloadData()
            return
        }
        filteredCourses = courses.filter { course in
            return (course.title?.lowercased() ?? "").contains(query.lowercased()) ||
            (course.description.lowercased()).contains(query.lowercased())
        }
        tableView.reloadData()
    }
}

extension CoursesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell", for: indexPath)
        let course = courses[indexPath.row]
        cell.textLabel?.text = course.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let course = courses[indexPath.row]
        let detailVC = CourseDetailViewController()
        detailVC.course = course
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
