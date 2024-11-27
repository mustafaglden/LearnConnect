//
//  ProfileViewModel.swift
//  LearnConnect
//
//  Created by Mustafa on 27.11.2024.
//

import CoreData

final class ProfileViewModel {
    private let context = CoreDataStack.shared.context
    
    func updateUsername(newUsername: String) {
        guard let currentUser = Session.user else {
            return
        }
        currentUser.username = newUsername
        CoreDataStack.shared.saveContext()
    }
    
    func fetchFavoriteCourses(completion: @escaping ([Course]) -> Void) {
        guard let user = Session.user else {
            completion([])
            return
        }
            
        if let favoriteCourses = user.favoriteCourses {
            let favCoursesArray = Array(favoriteCourses as? Set<Course> ?? [])
            completion(favCoursesArray)
        } else {
            completion([]) 
        }
    }
}
