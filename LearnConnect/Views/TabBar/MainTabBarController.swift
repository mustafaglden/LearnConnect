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
        self.navigationItem.hidesBackButton = true
        tabBar.backgroundColor = .systemOrange
        tabBar.unselectedItemTintColor = .black
        tabBar.tintColor = .white
        
        let allCoursesVC = UINavigationController(rootViewController: CoursesListViewController())
        allCoursesVC.tabBarItem = UITabBarItem(title: "all_courses".localized, image: UIImage(systemName: "list.bullet"), tag: 0)
                
        let myCoursesVC = UINavigationController(rootViewController: MyCoursesViewController())
        myCoursesVC.tabBarItem = UITabBarItem(title: "my_courses".localized, image: UIImage(systemName: "star.fill"), tag: 1)
        
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        profileVC.tabBarItem = UITabBarItem(title: "profile".localized, image: UIImage(systemName: "person.fill"), tag: 2)
        
        viewControllers = [allCoursesVC, myCoursesVC, profileVC]
    }
}
