//
//  MainTabBarController.swift
//  LearnConnect
//
//  Created by Mustafa on 22.11.2024.
//

import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationItem.hidesBackButton = true
        let allCoursesVC = UINavigationController(rootViewController: CoursesListViewController())
        allCoursesVC.tabBarItem = UITabBarItem(title: "All Courses", image: UIImage(systemName: "list.bullet"), tag: 0)
                
        let myCoursesVC = UINavigationController(rootViewController: MyCoursesViewController())
        myCoursesVC.tabBarItem = UITabBarItem(title: "My Courses", image: UIImage(systemName: "star.fill"), tag: 1)
        
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        profileVC.tabBarItem = UITabBarItem(title: "My Profile", image: UIImage(systemName: "person.fill"), tag: 2)
        
        viewControllers = [allCoursesVC, myCoursesVC, profileVC]
    }
}
